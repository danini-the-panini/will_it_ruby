module Gemologist
  T_Numeric.define do
    m :modulo, T_Real => T_Real
    m :+, t_self
    m :-, t_self
    m :<=>, T_Numeric => T_Integer | T_Nil
    m :abs, t_self
    m :abs2, T_Real
    m :angle, T_Integer | T_Float
    m :arg, T_Integer | T_Float
    m :ceil, T_Integer
    m :ceil, T_Integer => T_Float
    m :clone, {freeze: o(T_Bool)} => t_self
    m :coerce, t_self => T_Array[t_self]
    m :coerce, T_Numeric => T_Array[T_Float]
    m :conj, t_self
    m :conjugate, t_self
    m :denominator, T_Integer
    m :div, T_Numeric => T_Integer
    m :divmod, T_Numeric => T_Array[T_Integer | T_Float]
    m :dup, t_self
    m :eql?, T_Numeric => T_Bool
    m :fdiv, T_Numeric => T_Float
    m :finite?, T_Bool
    m :floor, T_Integer
    m :floor, T_Integer => T_Float
    m :i, T_Complex
    m :imag, T_Numeric
    m :imaginary, T_Numeric
    m :infinite?, T_Bool
    m :magnitude, T_Numeric
    m :negative?, T_Bool
    m :nonzero?, t_self | T_Nil
    m :numerator, T_Integer
    m :phase, T_Integer | T_Float
    m :polar, T_Array[T_Numeric]
    m :positive?, T_Bool
    m :quo, [T_Integer | T_Rational] => T_Rational
    m :quo, T_Float => T_Float
    m :real, T_Numeric
    m :real?, T_Bool
    m :rect, T_Array[T_Numeric]
    m :rectangular, T_Array[T_Numeric]
    m :remainder, T_Numeric => T_Real
    m :round, T_Integer
    m :round, T_Integer => T_Float

    m :step, T_Enumerator[T_Numeric]
    m :step, t_self do
      { o(T_Numeric) => T_Any }
    end
    m :step, [by: o(T_Numeric), to: o(T_Numeric)] => t_self do
      { o(T_Numeric) => T_Any }
    end
    m :step, [by: o(T_Numeric), to: o(T_Numeric)] => T_Enumerator[T_Numeric]
    m :step, [T_Numeric, o(T_Numeric)] => T_Enumerator[T_Numeric]
    m :step, [T_Numeric, o(T_Numeric)] => t_self do
      { o(T_Numeric) => T_Any }
    end

    m :to_c, T_Complex
    m :to_int, T_Integer
    m :truncate, T_Integer
    m :truncate, T_Integer => T_Float
    m :zero?, T_Bool
  end
end