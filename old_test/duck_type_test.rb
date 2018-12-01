require "test_helper"

class Gemologist::DuckTypeTest < Minitest::Test
  def test_matches
    a = Gemologist::DuckType.new([
      Gemologist::Definition::Method.new(nil, :to_s, T(String), [], {}, nil, nil)
    ])
    b = T(String)
    c = T(Integer)
    d = T(BasicObject)

    assert a.match?(a)
    assert a.match?(b)
    assert a.match?(c)
    refute a.match?(d)
  end
end