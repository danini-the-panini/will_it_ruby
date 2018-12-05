require 'test_helper'

module Ahiru
  class ScopeTest < Minitest::Test
    attr_reader :world, :scope

    def setup
      @world = World.new
      @scope = Scope.new @world
    end

    def test_process_lit_expression
      assert_equal T_Integer, scope.process_expression(s(:lit, 1))
      assert_equal T_Float,   scope.process_expression(s(:lit, 1.2))
      assert_equal T_Symbol,  scope.process_expression(s(:lit, :a))
      assert_equal T_Regexp,  scope.process_expression(s(:lit, /a/))
      
      range = scope.process_expression(s(:lit, (1..2)))
      assert T_Range <= range
      assert_equal T_Integer, range.concretes.first
    end

    def test_process_dot2_expression
      range = scope.process_expression(s(:dot2, s(:lit, 1), s(:lit, 2)))
      assert T_Range <= range
      assert_equal T_Integer, range.concretes.first
    end

    def test_process_dot3_expression
      range = scope.process_expression(s(:dot3, s(:lit, 1), s(:lit, 2)))
      assert T_Range <= range
      assert_equal T_Integer, range.concretes.first
    end

    def test_process_bool_expression
      assert_equal T_True, scope.process_expression(s(:true))
      assert_equal T_False, scope.process_expression(s(:false))
    end

    def test_process_nil_expression
      assert_equal T_Nil, scope.process_expression(s(:nil))
    end

    def test_process_str_expression
      assert_equal T_String, scope.process_expression(s(:str, "asdf"))
    end

    def test_process_dstr_expression
      assert_equal T_String, scope.process_expression(s(:dstr, "asdf", s(:evstr, s(:lit, 1))))
    end

    def test_process_dsym_expression
      assert_equal T_Symbol, scope.process_expression(s(:dsym, "asdf", s(:evstr, s(:lit, 1))))
    end

    def test_process_dregx_expression
      assert_equal T_Regexp, scope.process_expression(s(:dregx, "asdf", s(:evstr, s(:lit, 1))))
    end

    def test_process_xstr_expression
      assert_equal T_String, scope.process_expression(s(:xstr, "asdf"))
    end

    def test_process_dxstr_expression
      assert_equal T_String, scope.process_expression(s(:dxstr, "asdf", s(:evstr, s(:lit, 1))))
    end

    def test_array_expression
      array = scope.process_expression(s(:array, s(:lit, 1), s(:lit, 2)))
      assert T_Array <= array
      assert_equal T_Integer, array.concretes.first

      array = scope.process_expression(s(:array, s(:splat, s(:array, s(:lit, 1)))))
      assert T_Array <= array
      assert_equal T_Integer, array.concretes.first
    end

    def test_hash_expression
      hash = scope.process_expression(s(:hash, s(:lit, :a), s(:lit, 1)))
      assert T_Hash <= hash
      assert_equal T_Symbol, hash.concretes[0]
      assert_equal T_Integer, hash.concretes[1]

      hash = scope.process_expression(s(:hash, s(:kwsplat, s(:hash, s(:lit, :a), s(:lit, 1)))))
      assert T_Hash <= hash
      assert_equal T_Symbol, hash.concretes[0]
      assert_equal T_Integer, hash.concretes[1]
    end

    def test_lasgn_expression
      scope.process_expression(s(:lasgn, :a, s(:lit, 1)))
      assert scope.local_variable_defined?(:a)
      assert_equal T_Integer, scope.local_variable(:a)
    end

    def test_lvar_expression
      scope.assign_local_variable(:a, T_Integer)

      assert_equal T_Integer, scope.process_expression(s(:lvar, :a))
    end
  end
end