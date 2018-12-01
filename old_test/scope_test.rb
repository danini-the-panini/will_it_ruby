require 'test_helper'

class Gemologist::ScopeTest < Minitest::Test
  def teardown
    kernel_def = Gemologist::Definition.for_class(Kernel)
    kernel_def.instance_methods.delete :foo
  end

  def test_variable_assignment
    scope = Gemologist::Scope.new
    sexp = s(:lasgn, :x, s(:lit, 1)) # x = 1

    assert_equal T(Integer), scope.determine_type(sexp)

    assert_equal T(Integer), scope.local_variable(:x)
    assert_equal T(Integer), scope.determine_type(s(:call, nil, :x))
  end

  def test_method_calls
    scope = Gemologist::Scope.new
    scope.determine_type s(:lasgn, :x, s(:str, "hello"))
    sexp1 = s(:call, s(:call, nil, :x), :length) # x.length
    sexp2 = s(:call, s(:call, nil, :x), :upcase) # x.upcase

    assert_equal T(Integer), scope.determine_type(sexp1)
    assert_equal T(String), scope.determine_type(sexp2)
    assert_equal T(NilClass), scope.determine_type(s(:call, nil, :puts))
  end

  def test_complex_method_calls
    Gemologist::Definition.add_class_definition(Kernel) do
      add_method_definition :foo, [T(Integer), !T(Integer), !T(Numeric), a: T(Integer), b: !T(Integer), c: !T(Integer)] => T(String)
      add_method_definition :foo, { [T(Integer), !T(Integer), !T(Numeric), a: T(Integer), b: !T(Integer), c: !T(Integer)] => T(Integer) },
        [!T(Integer), !T(Integer)] => Gemologist::Any
      add_method_definition :bar, [T(String), +T(String)] => T(Array, T(String))
    end
    scope = Gemologist::Scope.new

    # foo(1, 2, 3, a:1, b:2) { |x,y| x + y }
    sexp1 = s(:iter,
      s(:call, nil, :foo,
        s(:lit, 1), s(:lit, 2), s(:lit, 3),
        s(:hash, s(:lit, :a), s(:lit, 1), s(:lit, :b), s(:lit, 2))
      ), s(:args, :x, :y), s(:call, s(:lvar, :x), :+, s(:lvar, :y)))

    assert_equal T(Integer), scope.determine_type(sexp1)

    # foo(1, 2, a:1, b:2) { nil }
    sexp2 = s(:iter,
      s(:call, nil, :foo,
        s(:lit, 1), s(:lit, 2), s(:lit, 3),
        s(:hash, s(:lit, :a), s(:lit, 1), s(:lit, :b), s(:lit, 2))
      ), 0, s(:nil))

    assert_equal T(Integer), scope.determine_type(sexp2)

    # foo(1, 2, 3.5, a:1, b:2, c: 3)
    sexp3 = s(:call, nil, :foo,
      s(:lit, 1), s(:lit, 2), s(:lit, 3),
      s(:hash, s(:lit, :a), s(:lit, 1), s(:lit, :b), s(:lit, 2)))

    assert_equal T(String), scope.determine_type(sexp3)

    # bar('asdf', 'qwer', 'zxcv')
    sexp4 = s(:call, nil, :bar,
      s(:str, 'asdf'), s(:str, 'qwer'), s(:str, 'zxcv'))

    assert_equal T(Array, T(String)), scope.determine_type(sexp4)
  end

  def test_parsing_method
    scope = Gemologist::Scope.new
    sexp = s(:defn, :foo, s(:args), s(:lasgn, :x, s(:lit, 1)), s(:lvar, :x))

    assert_equal T(Symbol), scope.determine_type(sexp)

    d = Gemologist::Definition.for_class(Kernel)
    m = d.find_methods_by_name(:foo)

    refute_nil m
    refute_predicate m, :empty?

    assert_equal 1, m.length
    m = m.first

    assert_equal d, m.class_definition
    assert_equal :foo, m.name
    assert_equal [], m.argument_list.types
    assert_equal T(Integer), m.return_type
    assert_equal({}, m.kwarg_types)
    assert_nil m.block_type
  end

  def test_parsing_method_with_args
    scope = Gemologist::Scope.new
    sexp = s(:defn, :foo, s(:args, :x), s(:call, s(:lvar, :x), :+, s(:lit, 1)))

    assert_equal T(Symbol), scope.determine_type(sexp)

    d = Gemologist::Definition.for_class(Kernel)
    m = d.find_methods_by_name(:foo)

    refute_nil m
    refute_predicate m, :empty?

    assert_equal 1, m.length
    m = m.first

    assert_equal d, m.class_definition
    assert_equal :foo, m.name
    assert_equal 1, m.argument_list.types.count
    t = m.argument_list.types.first
    assert_equal Gemologist::DuckType, t.class
    assert_equal Gemologist::Any, m.return_type
    assert_equal({}, m.kwarg_types)
    assert_nil m.block_type
  end
end

