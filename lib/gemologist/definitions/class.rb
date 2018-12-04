module Gemologist
  T_Class.define do
    m :allocate, C
    m :json_creatable?, T_Bool
    m :new, v(T_Any) => C # TODO: must match "initialize" in this special case
    m :superclass, T | T_Nil
    m :inherited, t_self => T_Nil
  end

  C_Class.define do
    m :new, o(T_Class[Y]) => T_Class[T]
    m :new, o(T_Class[Y]) => T_Class[T] do
      { o(T_Class) => T_Any }
    end
  end
end