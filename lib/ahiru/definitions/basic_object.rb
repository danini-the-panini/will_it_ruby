module Ahiru
T_BasicObject.define do
    m :!, T_Bool
    m :!=, T_Any => T_Bool
    m :==, T_Any => T_Bool
    m :equal?, T_Any => T_Bool

    m :instance_exec, v(T_Any) => t_self do
      { v(T_Any) => T_Any }
    end
    m :instance_eval, [o(T_String), o(T_String), o(T_Integer)] => t_self
    m :instance_eval, t_self do
      { o(t_self) => T_Any }
    end

    m :send, [T_String | T_Symbol, v(T_Any)] => T_Any
    m :send, [T_String | T_Symbol, o(T_Any)] => T_Any do
      { v(T_Any) => T_Any }
    end
    m :__send__, [T_String | T_Symbol, v(T_Any)] => T_Any
    m :__send__, [T_String | T_Symbol, o(T_Any)] => T_Any do
      { v(T_Any) => T_Any }
    end

    m :method_missing, [T_Symbol, v(T_Any)] => T_Any do
      { v(T_Any) => T_Any }
    end
    m :method_missing, [T_Symbol, v(T_Any)] => T_Any

    m :__id__, T_Integer
    m :object_id, T_Integer

    m :singleton_method_added, T_Symbol => T_Nil
    m :singleton_method_removed, T_Symbol => T_Nil
    m :singleton_method_undefined, T_Symbol => T_Nil
  end

  C_BasicObject.define do
    m :new, T_BasicObject
  end
end