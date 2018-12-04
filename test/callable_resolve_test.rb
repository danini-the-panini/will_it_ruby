require "test_helper"

module Gemologist
  class CallableResolveTest < Minitest::Test
    Any = Duck.new(name: "Any")
    Thing = Duck.new(Any, name: "Thing")
    FloatThing = Duck.new(Any, name: "FloatThing")
    IntThing = Duck.new(Any, name: "IntThing")
    IntThing.add_method_definition(Method.new(IntThing, :+, Thing, [Callable::Argument.new(IntThing)]))
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

    def test_resolve_call_with_multiple_arguments
      b_type = Duck.new name: "B"
      r_type = Duck.new name: "R"
      other_type = Duck.new(Any)
      other_type.add_method_definition(Method.new(other_type, :+, r_type, [Callable::Argument.new(b_type)]))

      a = Callable.new(r_type, [Callable::Argument.new(other_type), Callable::Argument.new(b_type)], {}, nil, [b_type, r_type])

      assert_equal Thing, a.resolve([IntThing, IntThing])
    end

    def test_resolve_call_with_keyword_arguments
      b_type = Duck.new name: "B"
      r_type = Duck.new name: "R"
      other_type = Duck.new(Any)
      other_type.add_method_definition(Method.new(other_type, :+, r_type, [Callable::Argument.new(b_type)]))

      a = Callable.new(r_type, [Callable::Argument.new(other_type)], {b: Callable::Argument.new(b_type)}, nil, [b_type, r_type])

      assert_equal Thing, a.resolve([IntThing], { b: IntThing })
    end

    def test_resolve_call_with_block
      a_type = Duck.new name: "A"
      r_type = Duck.new name: "R"

      e_type = Duck.new name: "E"

      a = Callable.new(r_type, [Callable::Argument.new(a_type)], {}, Block.new(r_type, [Callable::Argument.new(a_type)]), [a_type, r_type])

      assert_equal Thing, a.resolve([Thing], {}, Block.new(e_type, [Callable::Argument.new(e_type)], {}, nil, [e_type]))
    end
  end
end