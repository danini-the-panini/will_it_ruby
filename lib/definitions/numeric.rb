require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Numeric) do
  add_method_definition :modulo, Real => Real
  add_method_definition :+, Self
  add_method_definition :-, Self
  add_method_definition :<=>, T(Numeric) => T(Integer) | Nil
  add_method_definition :abs, Self
  add_method_definition :abs2, Real
  add_method_definition :angle, T(Integer) | T(Float)
  add_method_definition :arg, T(Integer) | T(Float)
  add_method_definition :ceil, T(Integer)
  add_method_definition :ceil, T(Integer) => T(Float)
  add_method_definition :clone, {freeze: !Bool} => Self # TODO: acces kwarg
  add_method_definition :coerce, Self => T(Array, Self)
  add_method_definition :coerce, T(Numeric) => T(Array, Float)
  add_method_definition :conj, Self
  add_method_definition :conjugate, Self
  add_method_definition :denominator, T(Integer)
  add_method_definition :div, T(Numeric) => T(Integer)
  add_method_definition :divmod, T(Numeric) => T(Array, T(Integer) | T(Float))
  add_method_definition :dup, Self
  add_method_definition :eql?, T(Numeric) => Bool
  add_method_definition :fdiv, T(Numeric) => T(Float)
  add_method_definition :finite?, Bool
  add_method_definition :floor, T(Integer)
  add_method_definition :floor, T(Integer) => T(Float)
  add_method_definition :i, T(Complex)
  add_method_definition :imag, T(Numeric)
  add_method_definition :imaginary, T(Numeric)
  add_method_definition :infinite?, Bool
  add_method_definition :magnitude, T(Numeric)
  add_method_definition :negative?, Bool
  add_method_definition :nonzero?, Self | Nil
  add_method_definition :numerator, T(Integer)
  add_method_definition :phase, T(Integer) | T(Float)
  add_method_definition :polar, T(Array, Numeric)
  add_method_definition :positive?, Bool
  add_method_definition :quo, [T(Integer) | T(Rational)] => T(Rational)
  add_method_definition :quo, T(Float), T(Float)
  add_method_definition :real, T(Numeric)
  add_method_definition :real?, Bool
  add_method_definition :rect, T(Array, Numeric)
  add_method_definition :rectangular, T(Array, Numeric)
  add_method_definition :remainder, T(Numeric) => Real
  add_method_definition :round, T(Integer)
  add_method_definition :round, T(Integer) => T(Float)

  add_method_definition :step, T(Enumerator, Numeric)
  add_method_definition :step, Self, T(Numeric) => Any
  add_method_definition :step, {by: !T(Numeric), to: !T(Numeric)} => Self, T(Numeric) => Any
  add_method_definition :step, {by: !T(Numeric), to: !T(Numeric)} => T(Enumerator, Numeric)
  add_method_definition :step, [T(Numeric), !T(Numeric)] => T(Enumerator, Numeric)
  add_method_definition :step, [T(Numeric), !T(Numeric)] => Self, T(Numeric) => Any

  add_method_definition :to_c, T(Complex)
  add_method_definition :to_int, T(Integer)
  add_method_definition :truncate, T(Integer)
  add_method_definition :truncate, T(Integer) => T(Float)
  add_method_definition :zero?, Bool
end