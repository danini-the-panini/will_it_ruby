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
      assert_equal T_Object, type.super_duck
      assert_equal klass, C_Object.constant(:Foo)
      
      refute_nil type.find_method_by_call(:initialize)
      refute_nil klass.find_method_by_call(:new)
    end

    def test_resolve_with_super_class
      r = ClassDefinitionResolver.new(:Foo, s(:const, :BasicObject), [], @scope)

      klass = r.resolve
      type = klass.instance_type

      assert_equal :Foo, type.name
      assert_equal T_BasicObject, type.super_duck
    end

    def test_resolve_with_method
      r = ClassDefinitionResolver.new(:Foo, nil, [s(:defn, :foo, s(:args), s(:str, "foo"))], @scope)

      klass = r.resolve
      type = klass.instance_type

      method = type.find_method_by_call(:foo)
      refute_nil method
      assert_equal T_String, method.return_type
    end
  end
end