require "test_helper"

class Gemologist::AnyTypeTest < Minitest::Test
  def test_equals
    a = Gemologist::Any
    b = T(String)

    assert a == a
    refute a == b
    refute b == a
  end

  def test_matches
    a = Gemologist::Any
    b = T(String)
    c = T(String) | T(NilClass)
    d = T(Array, T(String))
    e = T(Hash, T(Symbol), T(Integer))

    T(Proc, T(String), T(Integer), T(Integer))

    assert a.match?(a)
    assert a.match?(b)
    assert a.match?(c)
    assert a.match?(d)
    assert a.match?(e)

    refute b.match?(a)
    refute c.match?(a)
    refute d.match?(a)
    refute e.match?(a)
  end
end