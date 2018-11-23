require "test_helper"

class Gemologist::UnionTypeTest < Minitest::Test
  def test_equals
    a = T(Integer) | T(String)
    b = T(String) | T(Integer)
    c = T(Integer) | T(Float)

    assert a == b
    assert b == a
    refute a == c
    refute c == a
    refute b == c
  end

  def test_matches
    a = T(Numeric) | T(String)
    b = T(Numeric) | T(NilClass)
    c = T(Float) | T(Integer)

    assert a.matches?(a)
    assert a.matches?(T(String))
    assert a.matches?(T(Integer))
    assert a.matches?(T(Float))
    refute a.matches?(T(NilClass))

    assert b.matches?(T(Integer))
    assert b.matches?(T(NilClass))
    assert b.matches?(c)
    refute c.matches?(b)
  end
end