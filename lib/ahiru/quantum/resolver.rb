module Ahiru
  module Quantum
    class Resolver
      def initialize(scope, sexp, truthy)
        @scope = scope
        @sexp = sexp
        @truthy = truthy
      end

      def truthy?
        @truthy
      end

      def falsey?
        !truthy?
      end

      def process
        name, *args = @sexp
        send(:"process_#{name}_expression", *args)
      end

      protected

      def process_or_expression(a, b)
        if truthy?
          process_either(a, b)
        else
          process_both(a, b)
        end
      end

      def process_and_expression(a, b)
        if truthy?
          process_both(a, b)
        else
          process_either(a, b)
        end
      end

      def process_lit_expression(value)
        return ImpossibleDefinition.new if falsey?
      end

      def process_dot2_expression(begin_exp, end_exp)
        puts "STUB: #{self.class.name}#process_dot2_expression"
      end

      def process_dot3_expression(*args)
        puts "STUB: #{self.class.name}#process_dot3_expression"
      end

      def process_true_expression
        return ImpossibleDefinition.new if falsey?
      end

      def process_false_expression
        return ImpossibleDefinition.new if truthy?
      end

      def process_nil_expression
        return ImpossibleDefinition.new if truthy?
      end

      def process_str_expression(_)
        return ImpossibleDefinition.new if falsey?
      end

      def process_dstr_expression(_, *values)
        return ImpossibleDefinition.new if falsey?
      end

      def process_evstr_expression(expression)
        puts "STUB: #{self.class.name}#process_evstr_expression"
      end

      def process_dsym_expression(_, *values)
        return ImpossibleDefinition.new if falsey?
      end

      def process_dregx_expression(_, *values)
        return ImpossibleDefinition.new if falsey?
      end

      def process_xstr_expression(value)
        puts "STUB: #{self.class.name}#process_xstr_expression"
      end

      def process_dxstr_expression(_, *values)
        puts "STUB: #{self.class.name}#process_dxstr_expression"
      end

      def process_array_expression(*values)
        return ImpossibleDefinition.new if falsey?
      end

      def process_hash_expression(*entries)
        return ImpossibleDefinition.new if falsey?
      end

      def process_lasgn_expression(name, value)
        Resolver.new(@scope, value, truthy?)
      end

      def process_lvar_expression(name)
        resolve_value @scope.instance_variable_get(name)
      end

      def process_self_expression
        resolve_value @scope.process_self_expression
      end

      def process_safe_call_expression(receiver, name, *args)
        puts "STUB: #{self.class.name}#process_safe_call_expression"
      end

      def process_call_expression(receiver, name, *args)
        if receiver.nil? && local_variable_defined?(name)
          process_lvar_expression(name)
        else
          call = Call.new(args, @scope)
          call.process
          receiver_type = receiver.nil? ? @scope.process_self_expression : @scope.process_expression(receiver)
          method = receiver_type.get_method(name)
          if method
            method.resolve_for_scope(@scope, receiver_type, truthy?, receiver, call)
          end
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
        puts "STUB: #{self.class.name}#process_const_expression"
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

      private

      def resolve_value(val)
        resolved_value = truthy? ? val.resolve_truthy : val.resolve_falsey
        return if resolved_value.nil?
        scope.add_override(val, resolved_value)
      end

      def process_either(a, b)
        left_scope = MaybeScope.new(@scope.processor, [], @scope)
        right_scope = MaybeScope.new(@scope.processor, [], @scope)
        Resolver.new(left_scope, a, truthy?).process
        Resolver.new(right_scope, b, truthy?).process

        combined_overrides = left_scope.overrides.merge(right_scope.overrides) do |_, left_val, right_val|
          Maybe::Object.from_possibilities(left_val, right_val)
        end

        combined_overrides.each do |k, v|
          @scope.add_override(k, v)
        end
      end
      
      def process_both(a, b)
        Resolver.new(@scope, a, truthy?).process
        Resolver.new(@scope, b, truthy?).process
      end
    end
  end
end