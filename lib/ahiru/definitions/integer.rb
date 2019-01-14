module Ahiru
  T_Integer.define do
    m :%, T_Numeric => T_Real
    m :*, T_Integer => T_Integer
    m :*, T_Float => T_Float
    m :*, T_Rational => T_Rational
    m :**, T_Integer => T_Integer
    m :**, T_Float => T_Float
    m :**, T_Rational => T_Float
    m :+, T_Integer => T_Integer
    m :+, T_Float => T_Float
    m :+, T_Rational => T_Rational
    m :-, T_Integer => T_Integer
    m :-, T_Float => T_Float
    m :-, T_Rational => T_Rational
    m :/, T_Integer => T_Integer
    m :/, T_Float => T_Float
    m :/, T_Rational => T_Rational
    m :-, T_Integer
    m :+, T_Integer

    m :<, T_Real => T_Bool
    m :>, T_Real => T_Bool
    m :<=, T_Real => T_Bool
    m :>=, T_Real => T_Bool
    m :==, T_Any => T_Bool
    m :<=>, T_Numeric => T_Integer | T_Nil

    m :<<, T_Integer => T_Integer
    m :>>, T_Integer => T_Integer
    m :&, T_Integer => T_Integer
    m :|, T_Integer => T_Integer
    m :~, T_Integer
    m :'^', T_Integer => T_Integer
    m :[], T_Integer => T_Integer

    m :abs, T_Integer
    m :allbits?, T_Integer => T_Integer
    m :bit_length, T_Integer
    m :ceil, o(T_Integer) => T_Integer | T_Float
    m :chr, o(T_Encoding) => T_String
    m :coerce, T_Numeric => T_Array[T_Integer]
    m :dclone, T_Integer
    m :denominator, T_Integer
    m :digits, o(T_Integer) => T_Array[T_Integer]
    m :div, T_Numeric => T_Integer
    m :divmod, T_Numeric => T_Array[T_Numeric]
    m :downto, T_Integer => T_Integer do
      { T_Integer => T_Any }
    end
    m :downto, T_Integer => T_Enumerator[T_Integer]
    m :even?, T_Bool
    m :fdiv, T_Numeric => T_Float
    m :floor, o(T_Integer) => T_Integer | T_Float
    m :gcd, T_Integer => T_Integer
    m :gcdlcm, T_Integer => T_Array[T_Integer]
    m :inspect, o(T_Integer) => T_String
    m :integer?, T_True
    m :lcm, T_Integer => T_Integer
    m :magnitude, T_Integer
    m :module, T_Numeric => T_Real
    m :next, T_Integer
    m :nobits?, T_Integer => T_Bool
    m :numerator, T_Integer
    m :odd?, T_Bool
    m :ord, T_Integer
    m :pow, T_Numeric => T_Numeric
    m :pow, [T_Integer, T_Integer] => T_Integer
    m :pred, T_Integer
    m :prime?, T_Bool
    m :prime_division, T_Any => T_Any
    m :rationalize, o(T_Numeric) => T_Rational
    m :remainder, T_Numeric => T_Real
    m :round, [o(T_Integer), half: o(T_Symbol)] => T_Integer | T_Float
    m :size, T_Integer
    m :succ, T_Integer
    m :times, T_Integer do
      { T_Integer => T_Any }
    end
    m :times, T_Enumerator[T_Integer]
    # m :to_bn, T_BigDecimal
    m :to_f, T_Float
    m :to_i, T_Integer
    m :to_int, T_Integer
    m :to_r, T_Rational
    m :to_s, o(T_Integer) => T_String
    m :truncate, o(T_Integer) => T_Integer | T_Float
    m :upto, T_Integer => T_Integer do
      { T_Integer => T_Any }
    end
    m :upto, T_Integer => T_Enumerator[T_Integer]
  end

  C_Integer.define do
    c :GMP_VERSION, T_Any

    m :each_prime, T_Any => T_Any do
      { T_Integer => T_Any }
    end
    m :from_prime_division, T_Any => T_Any
    m :sqrt, T_Integer => T_Integer
  end
end