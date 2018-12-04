module Gemologist
  class Scope
    def process_expression(sexp)
      name, *args = sexp
      send(:"process_#{name}_expression", *args)
    end

    def process_lit_expression(value)
    end

    def process_str_expression(value)
    end

    def process_dstr_expression(*values)
    end

    def process_case_expression(input, *expressions)
    end

    def process_array_expression(*values)
    end

    def process_hash_expression(*entries)
    end

    def process_lasgn_expression(name, value)
    end

    def process_lvar_expression(name)
    end

    def process_call_expression(receiver, name, args, kwargs)
    end
    
    def process_iter_expression(call, blargs, blexp)
    end

    def process_defn_expression(name, args, *expressions)
    end

    def process_class_expression(name, superclass, *expressions)
    end

    def process_module_expression(name, *expressions)
    end

    def process_cdecl_expression(name, value)
    end

    def process_const_expression(name)
    end

    def process_for_expression(iterable, variable, block)
    end

    def process_while_expression(condition, block)
    end

    def process_until_expression(condition, block)
    end

    def process_if_expression(condition, true_block, false_block)
    end

    def process_return_expression(value = nil)
    end

    def process_break_expression(value = nil)
    end

    def process_next_expression(value = nil)
    end

    def process_yield_expression(*args)
    end

    def process_xstr_expression(value)
    end

    def process_dxstr_expression(*values)
    end
  end
end