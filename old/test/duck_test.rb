require "test_helper"

module Ahiru
  class DuckTest < Minitest::Test
    Any = Duck.new
    Thing = Duck.new(methods: {
      :+ => [Method.new(Any, [Callable::Argument.new(Any)])]
    })
    AnyThing = Duck.new(Any)

    def test_match
      assert Any <= Any
      assert Any <= Thing
      assert Any <= AnyThing
      assert Thing <= Thing
      assert AnyThing <= Thing

      assert Any <= (Thing | AnyThing)

      refute Thing <= Any
      refute AnyThing <= Any
      refute Thing <= (Thing | AnyThing)

      refute T_String <= T_Nil
      refute T_Nil <= T_String
    end

    def test_pipe
      u = T_Nil | T_String

      assert_equal Union.new([T_Nil, T_String]), u
    end

    def test_pipe_with_same_duck
      u = T_String | T_String

      assert_equal T_String, u
    end

    def test_pipe_with_super_duck
      u1 = T_Integer | T_Numeric
      u2 = T_Numeric | T_Integer

      assert_equal u1, u2
      assert_equal T_Numeric, u1
    end

    def test_pipe_with_union
      u = Union.new([T_Nil, T_String])
      u2 = T_Integer | u

      assert_equal Union.new([T_Nil, T_String, T_Integer]), u2
    end
  end
end