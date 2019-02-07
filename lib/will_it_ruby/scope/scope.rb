module WillItRuby
  class Scope
    attr_reader :processor, :self_type, :last_evaluated_result, :local_variables, :overrides
    attr_accessor :maybe
    include ProcessorDelegateMethods
    include InstanceVariables

    def initialize(processor, expressions, parent=processor.main_scope)
      @processor = processor
      @expressions = expressions
      @parent = parent
      @self_type = nil
      @last_evaluated_result = nil
      @local_variables = {}
      @overrides = {}
      @cache = {}
    end

    def process
      @expressions.each do |sexp|
        @current_sexp = sexp
        @last_evaluated_result = process_expression(sexp)
        should_stop = block_given? ? yield : false
        @current_sexp = nil
        break if should_stop
      end
    end

    def process_expression(sexp)
      @cache[sexp.__id__] ||= begin
        name, *args = sexp
        send(:"process_#{name}_expression", *args)
      end
    end

    def register_issue(line, message)
      @parent.register_issue(line, message)
    end

    def local_variable_defined?(name)
      @local_variables.key?(name)
    end

    def local_variable_set(name, value)
      @local_variables[name] = q value
    end

    def local_variable_get(name)
      q @local_variables[name]
    end

    def defined_local_variables
      @local_variables.keys
    end

    def maybe?
      maybe
    end

    def get_ivar(name)
      q( ivar_hash[name] || self_type.get_ivar(name) )
    end

    def inspect
      "#<#{self.class.name} @self_type=#{@self_type.inspect}>"
    end

    def q(value)
      new_value = (@overrides[value] || @parent&.q(value) || value)
      new_value.for_scope(self)
    end

    def add_override(value, new_value)
      @overrides[value] = new_value
    end

    def process_lit_expression(value)
      # TODO: should we handle Range literals differently?
      q object_class.get_constant(value.class.name.to_sym).create_instance(value: value)
    end

    def process_dot2_expression(begin_exp, end_exp)
      puts "STUB: #{self.class.name}#process_dot2_expression"
      BrokenDefinition.new
    end

    def process_dot3_expression(*args)
      puts "STUB: #{self.class.name}#process_dot3_expression"
      BrokenDefinition.new
    end

    def process_true_expression
      v_true
    end

    def process_false_expression
      v_false
    end

    def process_nil_expression
      v_nil
    end

    def process_str_expression(value)
      create_string(value)
    end

    def process_dstr_expression(start_value, *expressions)
      possibilities = [start_value]
      expressions.each do |exp|
        case exp[0]
        when :evstr
          result = process_expression(exp[1])
          case result
          when Maybe::Object
            string_results = Maybe::Object.normalize(result.possibilities.map { |p| call_to_s(p) })
          else
            string_results = [call_to_s(result)]
          end

          # If any evstr returns a completely unknown value, the whole string must be unknown
          if !string_results.all?(&:value_known?)
            return create_string
          end

          possibilities = possibilities.flat_map do |p|
            string_results.map { |s| p + s.value }
          end
        when :str
          possibilities.map! { |s| s + exp[1] }
        end
      end

      Maybe::Object.from_possibilities(possibilities.map { |p| create_string(p) })
    end

    def process_dsym_expression(start_value, *expressions)
      result = process_dstr_expression(start_value, *expressions)
      all_results = Maybe::Object.normalize([result])

      if !all_results.all?(&:value_known?)
        return create_symbol
      end

      Maybe::Object.from_possibilities(all_results.map { |p| create_symbol(p.value) })
    end

    def process_dregx_expression(_, *values)
      puts "STUB: #{self.class.name}#process_dregx_expression"
      BrokenDefinition.new
    end

    def process_xstr_expression(value)
      puts "STUB: #{self.class.name}#process_xstr_expression"
      BrokenDefinition.new
    end

    def process_dxstr_expression(_, *values)
      puts "STUB: #{self.class.name}#process_dxstr_expression"
      BrokenDefinition.new
    end

    def process_array_expression(*values)
      value_known = true
      element_type_known = true
      value = values.flat_map do |v|
        case v[0]
        when :splat
          splat_thing = q process_expression(v[1])
          if splat_thing.has_method?(:to_a)
            splat_thing = splat_thing.get_method(:to_a).make_call(splat_thing, empty_call)
          end

          if splat_thing.is_a?(ArrayInstance)
            if splat_thing.value_known?
              splat_thing.value
            else
              value_known = false
              if splat_thing.element_type_known?
                [splat_thing.element_type]
              else
                element_type_known = false
                []
              end
            end
          else
            [splat_thing]
          end
        else
          q process_expression(v)
        end
      end

      if !element_type_known
        return object_class.get_constant(:Array).create_instance
      end

      element_type = value.empty? ? v_nil : Maybe::Object.from_possibilities(*value)

      if !value_known
        return object_class.get_constant(:Array).create_instance(element_type: element_type)
      end

      object_class.get_constant(:Array).create_instance(value: value, element_type: element_type)
    end

    def process_hash_expression(*entries)
      puts "STUB: #{self.class.name}#process_hash_expression"
      BrokenDefinition.new
    end

    def process_lasgn_expression(name, value)
      result = q process_expression(value)
      local_variable_set(name, result)
      result
    end

    def process_lvar_expression(name)
      if local_variable_defined?(name)
        q local_variable_get(name)
      else
        register_issue @current_sexp.line, "Undefined local variable `#{name}' for #{process_self_expression}"
        BrokenDefinition.new
      end
    end

    def process_self_expression
      q self_type
    end

    def process_safe_call_expression(receiver, name, *args)
      puts "STUB: #{self.class.name}#process_safe_call_expression"
      BrokenDefinition.new
    end

    def process_call_expression(receiver, name, *args)
      if receiver.nil? && local_variable_defined?(name)
        q local_variable_get(name)
      else
        q call_method_on_receiver(receiver, name, args)
      end
    end

    def process_attrasgn_expression(receiver, name, *args)
      process_call_expression(receiver, name, *args)
      process_expression(args.last)
    end

    def process_iter_expression(call, blargs, blexp = s(:nil))
      _, receiver, name, *args = call
      
      block = if blargs && blexp
              Block.new(blargs, vectorize_sexp(blexp), processor, self)
            end

      result = q call_method_on_receiver(receiver, name, args, block)
      
      if !block.scopes.empty?
        # lvars
        # TODO: make sure blargs aren't included here
        all_affected_lvars = block.scopes.map { |s| s.local_variables.keys }.reduce([]) { |a, b| a | b }
        existing_affected_lvars = defined_local_variables & all_affected_lvars

        existing_affected_lvars.each do |k|
          value = block.scopes.reduce(local_variable_get(k)) do |a, b|
            if b.local_variables[k].nil?
              a
            else
              if b.maybe?
                Maybe::Object.from_possibilities(a, b.local_variables[k])
              else
                b.local_variables[k]
              end
            end
          end
          local_variable_set(k, value)
        end

        #ivars
        affected_ivars = block.scopes.map { |s| s.ivar_hash.keys }.reduce([]) { |a, b| a | b }

        affected_ivars.each do |k|
          value = block.scopes.reduce(get_ivar(k)) do |a, b|
            if b.ivar_hash[k].nil?
              a
            else
              if b.maybe?
                Maybe::Object.from_possibilities(a, b.ivar_hash[k])
              else
                b.ivar_hash[k]
              end
            end
          end
          set_ivar(k, value)
        end

        # return value
        if block.scopes.any?(&:did_return?)
          return handle_return block.scopes.find(&:did_return?).return_value
        elsif block.scopes.any?(&:did_partially_return?)
          result = block.scopes.select(&:did_partially_return?)
                               .map(&:partial_return)
                               .reduce(result) { |a, b| a | b }
        end
      end

      result
    end

    def process_defn_expression(name, args, *expressions)
      puts "STUB: #{self.class.name}#process_defn_expression"
      BrokenDefinition.new
    end

    def process_defs_expression(name, receiver, args, *expressions)
      puts "STUB: #{self.class.name}#process_defs_expression"
      BrokenDefinition.new
    end

    def process_class_expression(name, super_exp, *expressions)
      puts "STUB: #{self.class.name}#process_class_expression"
      BrokenDefinition.new
    end

    def process_sclass_expression(receiver, *expressions)
      puts "STUB: #{self.class.name}#process_sclass_expression"
      BrokenDefinition.new
    end

    def process_module_expression(name, *expressions)
      puts "STUB: #{self.class.name}#process_module_expression"
      BrokenDefinition.new
    end

    def process_cdecl_expression(name, value)
      puts "STUB: #{self.class.name}#process_cdecl_expression"
      BrokenDefinition.new
    end

    def process_const_expression(name)
      # TODO: has to be more complicated than this 
      object_class.get_constant(name)
    end

    def process_colon2_expression(left, right)
      puts "STUB: #{self.class.name}#process_colon2_expression"
      BrokenDefinition.new
    end

    def process_colon3_expression(name)
      puts "STUB: #{self.class.name}#process_colon3_expression"
      BrokenDefinition.new
    end

    def process_for_expression(iterable, variable, block)
      puts "STUB: #{self.class.name}#process_for_expression"
      BrokenDefinition.new
    end

    def process_while_expression(condition, block)
      puts "STUB: #{self.class.name}#process_while_expression"
      BrokenDefinition.new
    end

    def process_until_expression(condition, block)
      puts "STUB: #{self.class.name}#process_until_expression"
      BrokenDefinition.new
    end

    def process_if_expression(condition, true_block, false_block)
      condition_result = process_expression(condition)

      possible_scopes = []

      if condition_result.maybe_truthy?
        truthy_scope = MaybeScope.new(@processor, vectorize_sexp(true_block), self)
        Quantum::Resolver.new(truthy_scope, condition, true).process
        possible_scopes << truthy_scope
      end

      if condition_result.maybe_falsey?
        falsey_scope = MaybeScope.new(@processor, vectorize_sexp(false_block), self)
        Quantum::Resolver.new(falsey_scope, condition, false).process
        possible_scopes << falsey_scope
      end

      if possible_scopes.length > 1
        possible_scopes.each { |s| s.maybe = true }
      end

      possible_scopes.each(&:process)

      # lvars
      all_affected_lvars = possible_scopes.map { |s| s.local_variables.keys }.reduce([]) { |a, b| a | b }
      new_lvars = all_affected_lvars - defined_local_variables

      new_lvars.each do |k|
        local_variable_set(k, v_nil)
      end

      all_affected_lvars.each do |k|
        values = possible_scopes.map { |s| s.local_variable_get(k) || self.local_variable_get(k) }

        local_variable_set(k, Maybe::Object.from_possibilities(*values.map { |v| q v }))
      end

      #ivars
      affected_ivars = possible_scopes.map { |s| s.ivar_hash.keys }.reduce([]) { |a, b| a | b }

      affected_ivars.each do |k|
        values = possible_scopes.map { |s| s.get_ivar(k) || self.get_ivar(k) }

        set_ivar(k, Maybe::Object.from_possibilities(get_ivar(k), *values.map { |v| q v }))
      end

      # return value
      if possible_scopes.all?(&:did_return?)
        return handle_return Maybe::Object.from_possibilities(*possible_scopes.map(&:return_value).map { |v| q v })
      elsif possible_scopes.any? { |x| x.did_return? || x.did_partially_return? }
        handle_partial_return Maybe::Object.from_possibilities(
          *possible_scopes.select(&:did_return?).map(&:return_value).map { |v| q v },
          *possible_scopes.select(&:did_partially_return?).map(&:partial_return).map { |v| q v }
        )

        non_returning_overrides = possible_scopes.reject(&:did_return?).reduce({}) do |a, b|
          a.merge(b.overrides) do |k, left, right|
            Maybe::Object.from_possibilities(left, right)
          end
        end
        @overrides.merge!(non_returning_overrides)
      end

      Maybe::Object.from_possibilities(*possible_scopes.select(&:did_not_return?).map(&:last_evaluated_result).map { |v| q v })
    end

    def process_or_expression(a, b)
      process_if_expression(a, a, b)
    end

    def process_and_expression(a, b)
      process_if_expression(a, b, a)
    end

    def process_case_expression(input, *when_expressions, else_expression)
      case_to_if = when_expressions.reverse.reduce(else_expression) do |e, w|
                     s(:if, w[1][1..-1].map{ |x| casecmp(x, input) }.reduce { |a, b| s(:or, a, b) },
                       s(:block, *w[2..-1]),
                       e)
                   end
      
      process_expression(case_to_if)
    end

    def process_return_expression(value = nil)
      handle_return(value.nil? ? v_nil : process_expression(value))
    end

    def process_break_expression(value = nil)
      puts "STUB: #{self.class.name}#process_break_expression"
      BrokenDefinition.new
    end

    def process_next_expression(value = nil)
      puts "STUB: #{self.class.name}#process_next_expression"
      BrokenDefinition.new
    end

    def process_yield_expression(*args)
      register_issue @current_sexp.line, "no block given (yield)"
      BrokenDefinition.new
    end

    def process_block_expression(*expressions)
      puts "STUB: #{self.class.name}#process_block_expression"
      BrokenDefinition.new
    end

    def process_ivar_expression(name)
      q get_ivar(name)
    end

    def process_iasgn_expression(name, value)
      set_ivar(name, q( process_expression(value) ))
    end

    private
    attr_accessor :current_sexp

    def handle_return(processed_value)
      s(:block, @current_sexp).each_of_type(:return) do |sexp|
        register_issue sexp.line, "unexpected return"
      end
      BrokenDefinition.new
    end

    def handle_partial_return(processed_value)
      handle_return(processed_value)
    end

    def call_method_on_receiver(receiver, name, args, block=nil)
      receiver_type = receiver.nil? ? process_self_expression : process_expression(receiver)

      call = Call.new(args, self)
      call.process

      method = receiver_type.get_method(name)
      if method
        error = method.check_args(args)

        # TODO: this is ridiculous. need to consolidate check_args and check_call
        if error
          register_issue @current_sexp&.line, error
          BrokenDefinition.new
        else
          error = method.check_call(call)
          if error
            register_issue @current_sexp&.line, error
            BrokenDefinition.new
          else
            method.make_call(receiver_type, call, block)
          end
        end
      else
        thing = receiver.nil? ? "local variable or method" : "method"
        register_issue @current_sexp&.line, "Undefined #{thing} `#{name}' for #{receiver_type}"
        BrokenDefinition.new
      end
    end

    def vectorize_sexp(sexp)
      return [s(:nil)] if sexp.nil?
      case sexp[0]
      when :block
        _, *expressions = sexp
        expressions
      else
        [sexp]
      end
    end

    def casecmp(a, b)
      s(:call, a, :===, b)
    end

    def call_to_s(thing)
      to_s_method = thing.get_method(:to_s)
      if to_s_method
        s = to_s_method.make_call(thing, empty_call)
        if s.is_a?(ClassInstance) && s.class_definition == object_class.get_constant(:String)
          return s
        elsif s.is_a?(Maybe::Object)
          if s.possibilities.any? { |p| p.class_definition != object.class.get_constant(:String) }
            create_string
          else
            return s
          end
        else
          create_string
        end
      else
        register_issue @curent_sexp&.line, "undefined method `to_s' for #{thing}"
      end
    end

    def string_class
      object_class.get_constant(:String)
    end

    def create_string(value = nil)
      string_class.create_instance(value: value)
    end

    def symbol_class
      object_class.get_constant(:Symbol)
    end

    def create_symbol(value = nil)
      symbol_class.create_instance(value: value&.to_sym)
    end

    def empty_call
      Call.new([], self).tap(&:process)
    end
  end
end
