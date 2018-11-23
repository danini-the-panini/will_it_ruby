require "test_helper"

class Gemologist::SingleTypeTest < Minitest::Test
  def test_equals
    a = T(Integer)
    b = T(Integer)
    c = T(String)

    assert a == b
    assert b == a
    refute a == c
    refute c == a
    refute b == c
  end

  def test_matches
    a = T(Numeric)
    b = T(Integer)
    c = T(String)

    assert a.matches?(a)
    assert a.matches?(b)
    refute b.matches?(a)
    refute a.matches?(c)
    refute c.matches?(a)
    refute b.matches?(c)
    refute c.matches?(b)
  end
end