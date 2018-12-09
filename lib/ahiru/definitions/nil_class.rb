module Ahiru
  T_NilClass.define do
    m :&, T_Any => T_False
    m :'^', T_Any => T_Bool
    m :|, T_Any => T_Bool
    m :'!', T_True

    m :rationalize, o(T_Any) => T_Rational

    m :nil?, T_True

    m :to_a, T_Array[T_Any]
    m :to_h, T_Hash[T_Any, T_Any]
    m :to_c, T_Complex
    m :to_f, T_Float
    m :to_i, T_Integer
    m :to_r, T_Rational
    m :to_s, T_String
    m :inspect, T_String
  end
end