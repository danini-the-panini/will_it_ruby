require "test_helper"

module Gemologist
  class CallableResolveTest < Minitest::Test
    Any = Duck.new(name: "Any")
    Thing = Duck.new(Any, name: "Thing")
    IntThing = Duck.new(Any, name: "IntThing")
    IntThing.add_method_definition(Method.new(IntThing, :+, Thing, [Callable::Argument.new(IntThing)]))

    def test_resolve_call
      a = Callable.new(Any)

      assert_equal Any, a.resolve([])
    end

    def test_resolve_call_with_free_type
      a_type = Duck.new name: "A"
      a = Callable.new(a_type, [Callable::Argument.new(a_type)], {}, nil, [a_type])

      assert_equal Thing, a.resolve([Thing])
    end

    def test_resolve_call_with_indirect_free_type
      a_type = Duck.new name: "A"
      other_type = Duck.new(Any)
      other_type.add_method_definition(Method.new(other_type, :+, a_type, [Callable::Argument.new(IntThing)]))
      a = Callable.new(a_type, [Callable::Argument.new(other_type)], {}, nil, [a_type])

      assert_equal Thing, a.resolve([IntThing])
    end
  end
end