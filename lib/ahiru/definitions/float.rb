module Ahiru
  T_Float.define do
    m :%, T_Numeric => T_Float
    m :*, T_Numeric => T_Float
    m :**, T_Numeric => T_Float
    m :+, T_Numeric => T_Float
    m :+, T_Float
    m :-, T_Numeric => T_Float
    m :-, T_Float
    m :/, T_Numeric => T_Float
    m :<, T_Real => T_Bool
    m :<=, T_Real => T_Bool
    m :<=>, T_Real => T_Integer | T_Nil
    m :==, T_Any, T_Bool
    m :>, T_Real => T_Bool
    m :>=, T_Real, T_Bool
    m :abs, T_Float
    m :angle, T_Float
    m :arg, T_Float
    m :ceil, o(T_Integer) => T_Integer | T_Float
    m :coerce, T_Numeric => T_Array[T_Float]
    m :dclone, T_Float
    m :denominator, T_Integer
    m :divmod, T_Numeric => T_Array[T_Integer | T_Float]
    m :eql?, T_Any => T_Bool
    m :fdiv, T_Numeric => T_Float
    m :finite?, T_Bool
    m :floor, o(T_Integer) => T_Integer | T_Float
    m :hash, T_Integer
    m :infinite?, T_Bool
    m :inspect, T_String
    m :magnitude, T_Float
    m :modulo, T_Numeric => T_Float
    m :nan?, T_Bool
    m :next_float, T_Float
    m :numerator, T_Integer
    m :phase, T_Float
    m :positive?, T_Bool
    m :prev_float, T_Float
    m :quo, T_Numeric => T_Float
    m :rationalize, o(T_Numeric) => T_Rational
    m :round, [o(T_Integer), half: o(T_Symbol)] => T_Integer | T_Float
    # m :to_d, o(T_Integer) => T_BigDecimal
    m :to_f, T_Float
    m :to_i, T_Integer
    m :to_int, T_Integer
    m :to_r, T_Rational
    m :to_s, T_String
    m :truncate, o(T_Integer) => T_Integer | T_Float
    m :zero?, T_Bool
  end

  C_Float.define do
    c :DIG, T_Integer
    c :EPSILON, T_Float
    c :INFINITY, T_Float
    c :MANT_DIG, T_Integer
    c :MAX, T_Float
    c :MAX_10_EXP, T_Integer
    c :MAX_EXP, T_Integer
    c :MIN, T_Float
    c :MIN_10_EXP, T_Integer
    c :MIN_EXP, T_Integer
    c :NAN, T_Float
    c :RADIX, T_Integer
    c :ROUNDS, T_Integer
  end
end