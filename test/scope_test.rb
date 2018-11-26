require 'test_helper'

class Gemologist::ScopeTest < Minitest::Test
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
  end
end

