require "test_helper"

module Ahiru
  class MethodDefinitionResolverTest < Minitest::Test
    def setup
      @world = World.new
      @scope = Scope.new(@world, C_Object)
    end

    def test_resolve_simple_case
      r = MethodDefinitionResolver.new(:foo, s(:args), [s(:nil)], @scope)

      method = r.resolve

      assert_equal :foo, method.name
      assert_equal T_Object, method.scope
      assert_equal T_Nil, method.return_type
      assert_equal [], method.pargs
      assert_equal({}, method.kwargs)
      assert_nil method.block
      assert_equal [], method.free_types
    end

    def test_resolve_simple_pargs_case
      r = MethodDefinitionResolver.new(:foo, s(:args, :a), [s(:lvar, :a)], @scope)

      method = r.resolve

      assert_equal :foo, method.name
      assert_equal T_Object, method.scope

      assert_equal 1, method.pargs.length
      assert_equal 1, method.free_types.length

      assert_equal method.free_types.first, method.return_type
      assert_equal method.free_types.first, method.pargs.first.type

      assert_equal({}, method.kwargs)
      assert_nil method.block
    end

    def test_resolve_simple_pargs_with_method
      r = MethodDefinitionResolver.new(:foo, s(:args, :a), [s(:call, s(:lvar, :a), :+, s(:lit, 1))], @scope)

      method = r.resolve

      assert_equal :foo, method.name
      assert_equal T_Object, method.scope

      assert_equal 1, method.pargs.length
      assert_equal 1, method.free_types.length

      assert_equal method.free_types.first, method.return_type
      a_type = method.pargs.first.type
      assert_equal 1, a_type.methods.length
      assert_equal method.free_types.first, a_type.methods[:+].first.return_type
      assert_equal T_Integer, a_type.methods[:+].first.pargs.first.type

      assert_equal({}, method.kwargs)
      assert_nil method.block
    end
  end
end