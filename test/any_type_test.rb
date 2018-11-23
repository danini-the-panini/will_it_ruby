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

    assert a.matches?(a)
    assert a.matches?(b)
    assert a.matches?(c)
    assert a.matches?(d)
    assert a.matches?(e)

    refute b.matches?(a)
    refute c.matches?(a)
    refute d.matches?(a)
    refute e.matches?(a)
  end
end