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

    assert a.match?(a)
    assert a.match?(b)
    refute b.match?(a)
    refute a.match?(c)
    refute c.match?(a)
    refute b.match?(c)
    refute c.match?(b)
  end
end