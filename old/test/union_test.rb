require "test_helper"

module Ahiru
  class UnionTest < Minitest::Test
    T_SuperThing = Duck.new(name: "SuperThing")
    T_SuperThing.define do
      m :asdf, T_Nil
    end
    T_ThingA = Duck.new(T_SuperThing, name: "ThingA")
    T_ThingB = Duck.new(T_SuperThing, name: "ThingB")

    def test_pipe
      u = Union.new([T_Nil])
      u2 = u | T_String

      assert_equal 2, u2.types.length
      assert_includes u2.types, T_Nil
      assert_includes u2.types, T_String
    end

    def test_equality
      u1 = Union.new([T_Nil, T_String])
      u2 = Union.new([T_String, T_Nil])
      u3 = Union.new([T_Nil, T_Integer])

      assert_equal u1, u2
      assert_equal u2, u1

      refute_equal u1, u3
      refute_equal u2, u3
      
      refute_equal u3, u1
      refute_equal u3, u2
    end

    def test_pipe_already_included
      u = T_Nil | T_String
      u2 = u | T_Nil

      assert_equal 2, u2.types.length
      assert_includes u2.types, T_Nil
      assert_includes u2.types, T_String
    end

    def test_pipe_already_included_superduck
      u = Union.new([T_Integer, T_Float])
      u2 = u | T_Numeric

      assert_equal T_Numeric, u2

      u = Union.new([T_Integer, T_Float, T_String])
      u2 = u | T_Numeric

      assert_equal Union.new([T_Numeric, T_String]), u2
    end

    def test_pipe_already_included_subduck
      u = Union.new([T_String, T_Numeric])
      u2 = u | T_Integer

      assert_equal u, u2
    end

    def test_pipe_union
      u1 = Union.new([T_Nil, T_String])
      u2 = Union.new([T_Nil, T_Integer])
      u3 = u1 | u2
      u4 = u2 | u1

      assert_equal u3, u4
      assert_equal 3, u3.types.length
      assert_includes u3.types, T_Nil
      assert_includes u3.types, T_String
      assert_includes u3.types, T_Integer
    end

    def test_pipe_union_with_superducks
      u1 = Union.new([T_Integer, T_Float, T_SuperThing])
      u2 = Union.new([T_Numeric, T_ThingA, T_ThingB])
      u3 = u1 | u2
      u4 = u2 | u1

      assert_equal Union.new([T_SuperThing, T_Numeric]), u3
      assert_equal u3, u4
    end

    def test_match?
      u1 = T_Integer | T_String

      assert u1 <= T_Integer
      assert u1 <= T_String

      refute T_Integer <= u1
      refute T_String <= u1

      refute T_Nil <= u1
      refute u1 <= T_Nil
    end
  end
end