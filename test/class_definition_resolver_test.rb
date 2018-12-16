require "test_helper"

module Ahiru
  class ClassDefinitionResolverTest < Minitest::Test
    def setup
      @world = World.new
      @scope = Scope.new(@world, C_Object)
    end

    def test_resolve_simple_case
      r = ClassDefinitionResolver.new(:Foo, nil, [], @scope)

      klass = r.resolve
      type = klass.instance_type

      assert_equal :Foo, type.name
    end
  end
end