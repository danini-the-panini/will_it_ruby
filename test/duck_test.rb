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

      refute Thing <= Any
      refute AnyThing <= Any
    end
  end
end