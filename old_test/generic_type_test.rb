require "test_helper"

class Gemologist::GenericTypeTest < Minitest::Test
  def test_equals
    a = T(Array, T(Integer) | T(String))
    b = T(Array, T(String) | T(Integer))
    c = T(Array, T(String))

    assert a == b
    assert b == a
    refute a == c
    refute c == a
    refute b == c
  end

  def test_matches
    a = T(Array, T(Integer) | T(String))
    b = T(Array, T(String))

    c = T(Hash, T(Symbol) | T(String), T(Numeric))
    d = T(Hash, T(Symbol), T(Integer))

    assert a.match?(a)
    assert a.match?(b)
    refute b.match?(a)

    assert c.match?(d)
    refute d.match?(c)
  end
end