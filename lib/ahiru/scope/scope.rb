module Ahiru
  class Scope
    def initialize(processor, sexp, parent)
      @processor = processor
      @sexp = sexp
      @parent = parent
    end

    def process
      name, *args = @sexp
      send(:"process_#{name}_expression", *args)
    end

    def register_issue(line, message)
      @parent.register_issue(line, message)
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
      puts "STUB: process_dot2_expression"
    end

    def process_dot3_expression(*args)
      puts "STUB: process_dot3_expression"
    end

    def process_true_expression
      puts "STUB: process_true_expression"
    end

    def process_false_expression
      puts "STUB: process_false_expression"
    end

    def process_nil_expression
      puts "STUB: process_nil_expression"
    end

    def process_str_expression(_)
      puts "STUB: process_str_expression"
    end

    def process_dstr_expression(_, *values)
      puts "STUB: process_dstr_expression"
    end

    def process_evstr_expression(expression)
      puts "STUB: process_evstr_expression"
    end

    def process_dsym_expression(_, *values)
      puts "STUB: process_dsym_expression"
    end

    def process_dregx_expression(_, *values)
      puts "STUB: process_dregx_expression"
    end

    def process_xstr_expression(value)
      puts "STUB: process_xstr_expression"
    end

    def process_dxstr_expression(_, *values)
      puts "STUB: process_dxstr_expression"
    end

    def process_array_expression(*values)
      puts "STUB: process_array_expression"
    end

    def process_hash_expression(*entries)
      puts "STUB: process_hash_expression"
    end

    def process_lasgn_expression(name, value)
      puts "STUB: process_lasgn_expression"
    end

    def process_lvar_expression(name)
      puts "STUB: process_lvar_expression"
    end

    def process_self_expression
      puts "STUB: process_self_expression"
    end

    def process_safe_call_expression(receiver, name, *args)
      puts "STUB: process_safe_call_expression"
    end

    def process_call_expression(receiver, name, *args)
      puts "STUB: process_call_expression"
    end

    def process_iter_expression(call, blargs, blexp = s(:nil))
      puts "STUB: process_iter_expression"
    end

    def process_defn_expression(name, args, *expressions)
      puts "STUB: process_defn_expression"
    end

    def process_defs_expression(name, receiver, args, *expressions)
      puts "STUB: process_defs_expression"
    end

    def process_class_expression(name, super_exp, *expressions)
      puts "STUB: process_class_expression"
    end

    def process_sclass_expression(receiver, *expressions)
      puts "STUB: process_sclass_expression"
    end

    def process_module_expression(name, *expressions)
      puts "STUB: process_module_expression"
    end

    def process_cdecl_expression(name, value)
      puts "STUB: process_cdecl_expression"
    end

    def process_const_expression(name)
      puts "STUB: process_const_expression"
    end

    def process_colon2_expression(left, right)
      puts "STUB: process_colon2_expression"
    end

    def process_colon3_expression(name)
      puts "STUB: process_colon3_expression"
    end

    def process_for_expression(iterable, variable, block)
      puts "STUB: process_for_expression"
    end

    def process_while_expression(condition, block)
      puts "STUB: process_while_expression"
    end

    def process_until_expression(condition, block)
      puts "STUB: process_until_expression"
    end

    def process_if_expression(condition, true_block, false_block)
      puts "STUB: process_if_expression"
    end

    def process_case_expression(input, *expressions)
      puts "STUB: process_case_expression"
    end

    def process_return_expression(value = nil)
      puts "STUB: process_return_expression"
    end

    def process_break_expression(value = nil)
      puts "STUB: process_break_expression"
    end

    def process_next_expression(value = nil)
      puts "STUB: process_next_expression"
    end

    def process_yield_expression(*args)
      puts "STUB: process_yield_expression"
    end

    def process_block_expression(*expressions)
      puts "STUB: process_block_expression"
    end

  end
end