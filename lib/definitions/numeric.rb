require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Numeric) do
  add_method_definition :modulo, Real, Real # TODO: not defined on Complex?
  add_method_definition :+, Self
  add_method_definition :-, Self
  add_method_definition :<=>, T(Integer) | Nil, T(Numeric)
  add_method_definition :abs, Self
  add_method_definition :abs2, Real
  add_method_definition :angle, T(Integer) | T(Float)
  add_method_definition :arg, T(Integer) | T(Float)
  add_method_definition :ceil, T(Integer)
  add_method_definition :ceil, T(Float), T(Integer)
  add_method_definition :clone, Self # TODO: acces kwarg
  add_method_definition :coerce, T(Array, Self), Self
  add_method_definition :coerce, T(Array, Float), T(Numeric)
  add_method_definition :conj, Self
  add_method_definition :conjugate, Self
  add_method_definition :denominator, T(Integer)
  add_method_definition :div, T(Integer), T(Numeric)
  add_method_definition :divmod, T(Array, T(Integer) | T(Float)), T(Numeric)
  add_method_definition :dup, Self
  add_method_definition :eql?, Bool, T(Numeric)
  add_method_definition :fdiv, T(Float), T(Numeric)
  add_method_definition :finite?, Bool
  add_method_definition :floor, T(Integer)
  add_method_definition :floor, T(Float), T(Integer)
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
  add_method_definition :quo, T(Rational), T(Integer) | T(Rational)
  add_method_definition :quo, T(Float), T(Float)
  add_method_definition :real, T(Numeric)
  add_method_definition :real?, Bool
  add_method_definition :rect, T(Array, Numeric)
  add_method_definition :rectangular, T(Array, Numeric)
  add_method_definition :remainder, Real, T(Numeric)
  add_method_definition :round, T(Integer)
  add_method_definition :round, T(Float), T(Integer)
  # add_method_definition :step # TODO: kwargs and block
  add_method_definition :to_c, T(Complex)
  add_method_definition :to_int, T(Integer)
  add_method_definition :truncate, T(Integer)
  add_method_definition :truncate, T(Float), T(Integer)
  add_method_definition :zero?, Bool
end