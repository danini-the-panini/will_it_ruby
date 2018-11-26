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

    assert a.match?(a)
    assert a.match?(T(String))
    assert a.match?(T(Integer))
    assert a.match?(T(Float))
    refute a.match?(T(NilClass))

    assert b.match?(T(Integer))
    assert b.match?(T(NilClass))
    assert b.match?(c)
    refute c.match?(b)
  end
end