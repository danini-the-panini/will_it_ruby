module Ahiru
  class Scope
    attr_reader :processor, :self_type

    def initialize(processor, expressions, parent=processor.main_scope)
      @processor = processor
      @expressions = expressions
      @parent = parent
      @self_type = nil
      @last_evaluated_result = nil
    end

    def process
      @expressions.each do |sexp|
        @current_sexp = sexp
        @last_evaluated_result = process_expression(sexp)
        @current_sexp = nil
      end
    end

    def process_expression(sexp)
      name, *args = sexp
      send(:"process_#{name}_expression", *args)
    end

    def register_issue(line, message)
      @parent.register_issue(line, message)
    end

    protected
    attr_accessor :current_sexp

    def process_lit_expression(value)
      puts "STUB: #{self.class.name}#process_lit_expression"
    end

    def process_dot2_expression(begin_exp, end_exp)
      puts "STUB: #{self.class.name}#process_dot2_expression"
    end

    def process_dot3_expression(*args)
      puts "STUB: #{self.class.name}#process_dot3_expression"
    end

    def process_true_expression
      puts "STUB: #{self.class.name}#process_true_expression"
    end

    def process_false_expression
      puts "STUB: #{self.class.name}#process_false_expression"
    end

    def process_nil_expression
      puts "STUB: #{self.class.name}#process_nil_expression"
    end

    def process_str_expression(_)
      puts "STUB: #{self.class.name}#process_str_expression"
    end

    def process_dstr_expression(_, *values)
      puts "STUB: #{self.class.name}#process_dstr_expression"
    end

    def process_evstr_expression(expression)
      puts "STUB: #{self.class.name}#process_evstr_expression"
    end

    def process_dsym_expression(_, *values)
      puts "STUB: #{self.class.name}#process_dsym_expression"
    end

    def process_dregx_expression(_, *values)
      puts "STUB: #{self.class.name}#process_dregx_expression"
    end

    def process_xstr_expression(value)
      puts "STUB: #{self.class.name}#process_xstr_expression"
    end

    def process_dxstr_expression(_, *values)
      puts "STUB: #{self.class.name}#process_dxstr_expression"
    end

    def process_array_expression(*values)
      puts "STUB: #{self.class.name}#process_array_expression"
    end

    def process_hash_expression(*entries)
      puts "STUB: #{self.class.name}#process_hash_expression"
    end

    def process_lasgn_expression(name, value)
      puts "STUB: #{self.class.name}#process_lasgn_expression"
    end

    def process_lvar_expression(name)
      puts "STUB: #{self.class.name}#process_lvar_expression"
    end

    def process_self_expression
      @self_type
    end

    def process_safe_call_expression(receiver, name, *args)
      puts "STUB: #{self.class.name}#process_safe_call_expression"
    end

    def process_call_expression(receiver, name, *args)
      if receiver.nil?
        # TODO: handle nil receivers
      else
        receiver_type = process_expression(receiver)
        binding.irb if receiver_type.nil?
        call_method_on_receiver(receiver_type, name, args)
      end
    end

    def process_iter_expression(call, blargs, blexp = s(:nil))
      puts "STUB: #{self.class.name}#process_iter_expression"
    end

    def process_defn_expression(name, args, *expressions)
      puts "STUB: #{self.class.name}#process_defn_expression"
    end

    def process_defs_expression(name, receiver, args, *expressions)
      puts "STUB: #{self.class.name}#process_defs_expression"
    end

    def process_class_expression(name, super_exp, *expressions)
      puts "STUB: #{self.class.name}#process_class_expression"
    end

    def process_sclass_expression(receiver, *expressions)
      puts "STUB: #{self.class.name}#process_sclass_expression"
    end

    def process_module_expression(name, *expressions)
      puts "STUB: #{self.class.name}#process_module_expression"
    end

    def process_cdecl_expression(name, value)
      puts "STUB: #{self.class.name}#process_cdecl_expression"
    end

    def process_const_expression(name)
      # TODO: has to be more complicated than this 
      @parent.process_const_expression(name)
    end

    def process_colon2_expression(left, right)
      puts "STUB: #{self.class.name}#process_colon2_expression"
    end

    def process_colon3_expression(name)
      puts "STUB: #{self.class.name}#process_colon3_expression"
    end

    def process_for_expression(iterable, variable, block)
      puts "STUB: #{self.class.name}#process_for_expression"
    end

    def process_while_expression(condition, block)
      puts "STUB: #{self.class.name}#process_while_expression"
    end

    def process_until_expression(condition, block)
      puts "STUB: #{self.class.name}#process_until_expression"
    end

    def process_if_expression(condition, true_block, false_block)
      puts "STUB: #{self.class.name}#process_if_expression"
    end

    def process_case_expression(input, *expressions)
      puts "STUB: #{self.class.name}#process_case_expression"
    end

    def process_return_expression(value = nil)
      puts "STUB: #{self.class.name}#process_return_expression"
    end

    def process_break_expression(value = nil)
      puts "STUB: #{self.class.name}#process_break_expression"
    end

    def process_next_expression(value = nil)
      puts "STUB: #{self.class.name}#process_next_expression"
    end

    def process_yield_expression(*args)
      puts "STUB: #{self.class.name}#process_yield_expression"
    end

    def process_block_expression(*expressions)
      puts "STUB: #{self.class.name}#process_block_expression"
    end

    private

    def call_method_on_receiver(receiver_type, name, args)
      # TODO: handle args
      method = receiver_type.get_method(name)
      if method
        arg_types = args.map do |arg|
          process_expression(arg)
        end

        error = method.check_call_with_args(arg_types)

        if error
          register_issue @current_sexp.line, error
        else
          method.call_with_args(receiver_type, arg_types)
        end
      else
        register_issue @current_sexp.line, "Undefined method `#{name}' for #{receiver_type}"
      end
    end
  end
end