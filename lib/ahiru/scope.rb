module Ahiru
  class Scope
    attr_reader :t_self

    def initialize(world, t_self, parent_scope = nil, ceiling_scope = nil, method_scope = nil)
      @world = world
      @t_self = t_self
      @parent_scope = parent_scope
      @ceiling_scope = nil
      @method_scope = nil
      @local_variables = {}
    end

    def local_variable_defined?(name)
      @local_variables.key?(name) || @parent_scope&.local_variable_defined?(name)
    end

    def local_variable(name)
      @local_variables.key?(name) ? @local_variables[name] : @parent_scope&.local_variable(name)
    end

    def assign_local_variable(name, value)
      if @parent_scope&.local_variable_defined?(name)
        @parent_scope.assign_local_variable(name, value)
      else
        @local_variables[name] = value
      end
    end

    def process_expression(sexp)
      name, *args = sexp
      send(:"process_#{name}_expression", *args)
    end

    private

    def process_lit_expression(value)
      case value
      when Integer then T_Integer
      when Float   then T_Float
      when Symbol  then T_Symbol
      when Regexp  then T_Regexp
      when Range
        T_Range[process_lit_expression(value.begin) | process_lit_expression(value.end)]
      else T_Any
      end
    end

    def process_dot2_expression(begin_exp, end_exp)
      T_Range[process_expression(begin_exp) | process_expression(end_exp)]
    end

    def process_dot3_expression(*args)
      process_dot2_expression(*args)
    end

    def process_true_expression
      T_True
    end

    def process_false_expression
      T_False
    end

    def process_nil_expression
      T_Nil
    end

    def process_str_expression(_)
      T_String
    end

    def process_dstr_expression(_, *values)
      values.each { |v| process_expression(v) }
      T_String
    end

    def process_evstr_expression(expression)
      # TODO: check that expression results in a thing that has a to_s
      process_expression(expression)
      T_String
    end

    def process_dsym_expression(_, *values)
      values.each { |v| process_expression(v) }
      T_Symbol
    end

    def process_dregx_expression(_, *values)
      values.each { |v| process_expression(v) }
      T_Regexp
    end

    def process_xstr_expression(value)
      T_String
    end

    def process_dxstr_expression(_, *values)
      values.each { |v| process_expression(v) }
      T_String
    end

    def process_array_expression(*values)
      return T_Array[T_Any] if values.empty?

      splat = nil
      if values.last[0] == :splat
        *values, splat = values
      end

      value_type = values.map { |v| process_expression(v) }.reduce { |a,b| a | b }

      if splat
        # TODO: check if splat type responds to to_a
        splat_type = process_expression(splat[1])

        if T_Array <= splat_type
          v = splat_type.concretes[0]
          if value_type
            value_type |= v
          else
            value_type = v
          end
        else
          value_type = T_Any
        end
      end

      T_Array[value_type]
    end

    def process_hash_expression(*entries)
      return T_Hash[T_Any, T_Any] if entries.empty?

      kwsplat = nil
      if entries.last[0] == :kwsplat
        *entries, kwsplat = entries
      end

      keys, values = [:even?, :odd?].map { |x| entries.values_at(*entries.each_index.select(&x)) }
      key_type    = keys.map   { |v| process_expression(v) }.reduce { |a,b| a | b }
      value_type  = values.map { |v| process_expression(v) }.reduce { |a,b| a | b }

      if kwsplat
        # TODO: check that splat type is
        #       Duck(to_hash() -> Hash<Symbol, ?>)
        splat_type = process_expression(kwsplat[1])

        if key_type
          key_type |= T_Symbol
        else
          key_type = T_Symbol
        end

        if T_Hash <= splat_type
          v = splat_type.concretes[1]
          if value_type
            value_type |= v
          else
            value_type = v
          end
        else
          value_type = T_Any
        end
      end

      T_Hash[key_type, value_type]
    end

    def process_lasgn_expression(name, value)
      assign_local_variable(name, process_expression(value))
    end

    def process_lvar_expression(name)
      # TODO: check if local variable exists
      local_variable(name)
    end

    def process_self_expression
      t_self
    end

    def process_call_expression(receiver, name, args, kwargs)
      # TODO
    end
    
    def process_iter_expression(call, blargs, blexp)
      # TODO
    end

    def process_defn_expression(name, args, *expressions)
      # TODO
    end

    def process_defs_expression(name, receiver, args, *expressions)
      # TODO
    end

    def process_class_expression(name, superclass, *expressions)
      # TODO
    end

    def process_module_expression(name, *expressions)
      # TODO
    end

    def process_cdecl_expression(name, value)
      # TODO: warn about dynamic constant assignment if not in class/module scope
      #       except when in main scope?
      t_self.add_constant(name, process_expression(value))
    end

    def process_const_expression(name)
      # TODO: check if constant exists
      t_self.constant(name)
    end

    def process_colon2_expression(left, right)
      # TODO: check if constant exists
      left_type = process_expression(left)
      left_type.immediate_constant(right)
    end

    def process_colon3_expression(name)
      # TODO: check if constant exists
      T_Object.immediate_constant(name)
    end

    def process_for_expression(iterable, variable, block)
      # TODO
    end

    def process_while_expression(condition, block)
      # TODO
    end

    def process_until_expression(condition, block)
      # TODO
    end

    def process_if_expression(condition, true_block, false_block)
      # TODO
    end

    def process_case_expression(input, *expressions)
      # TODO
    end

    def process_return_expression(value = nil)
      # TODO
    end

    def process_break_expression(value = nil)
      # TODO
    end

    def process_next_expression(value = nil)
      # TODO
    end

    def process_yield_expression(*args)
      # TODO
    end
  end
end