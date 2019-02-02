require "test_helper"

module WillItRuby
  class ArgumentsTest < Minitest::Test
    def test_no_arguments
      args = Arguments.new(s(:args))

      assert_equal 0, args.min_count
      assert_equal 0, args.max_count
      assert_equal "0", args.count_string
      assert_equal [], args.required_keywords
      assert_equal [], args.allowed_keywords
      refute_predicate args, :variadic?
      refute_predicate args, :varikwardic?
    end

    def test_some_arguments
      args = Arguments.new(s(:args, :a, :b))

      assert_equal 2, args.min_count
      assert_equal 2, args.max_count
      assert_equal "2", args.count_string
      assert_equal [], args.required_keywords
      assert_equal [], args.allowed_keywords
      refute_predicate args, :variadic?
      refute_predicate args, :varikwardic?
    end

    def test_optional_arguments
      args = Arguments.new(s(:args, :a, :b, s(:lasgn, :c, s(:lit, 1))))

      assert_equal 2, args.min_count
      assert_equal 3, args.max_count
      assert_equal "2..3", args.count_string
      assert_equal [], args.required_keywords
      assert_equal [], args.allowed_keywords
      refute_predicate args, :variadic?
      refute_predicate args, :varikwardic?
    end

    def test_kwargs
      args = Arguments.new(s(:args,  s(:kwarg, :a),  s(:kwarg, :b)))

      assert_equal 0, args.min_count
      assert_equal 0, args.max_count
      assert_equal "0", args.count_string
      assert_equal [:a, :b], args.required_keywords
      assert_equal [:a, :b], args.allowed_keywords
      refute_predicate args, :variadic?
      refute_predicate args, :varikwardic?
    end

    def test_optional_kwargs
      args = Arguments.new(s(:args, s(:kwarg, :a), s(:kwarg, :b), s(:kwarg, :c, s(:lit, 2))))

      assert_equal 0, args.min_count
      assert_equal 0, args.max_count
      assert_equal "0", args.count_string
      assert_equal [:a, :b], args.required_keywords
      assert_equal [:a, :b, :c], args.allowed_keywords
      refute_predicate args, :variadic?
      refute_predicate args, :varikwardic?
    end

    def test_splat
      args = Arguments.new(s(:args, :a, :b, :"*c"))

      assert_equal 2, args.min_count
      assert_predicate args.max_count, :infinite?
      assert_equal "2+", args.count_string
      assert_equal [], args.required_keywords
      assert_equal [], args.allowed_keywords
      assert_predicate args, :variadic?
      refute_predicate args, :varikwardic?
    end

    def test_kwsplat
      args = Arguments.new(s(:args, s(:kwarg, :a), s(:kwarg, :b), :"**c"))

      assert_equal 0, args.min_count
      assert_equal 0, args.max_count
      assert_equal "0", args.count_string
      assert_equal [:a, :b], args.required_keywords
      assert_equal [:a, :b], args.allowed_keywords
      refute_predicate args, :variadic?
      assert_predicate args, :varikwardic?
    end

    def test_anon_splat
      args = Arguments.new(s(:args, :a, :*))

      assert_equal 1, args.min_count
      assert_predicate args.max_count, :infinite?
      assert_equal "1+", args.count_string
      assert_equal [], args.required_keywords
      assert_equal [], args.allowed_keywords
      assert_predicate args, :variadic?
      refute_predicate args, :varikwardic?
    end

    def test_anon_kwsplat
      args = Arguments.new(s(:args, s(:kwarg, :a), s(:kwarg, :b), :**))

      assert_equal 0, args.min_count
      assert_equal 0, args.max_count
      assert_equal "0", args.count_string
      assert_equal [:a, :b], args.required_keywords
      assert_equal [:a, :b], args.allowed_keywords
      refute_predicate args, :variadic?
      assert_predicate args, :varikwardic?
    end

    def test_all_the_arguments
      args = Arguments.new(s(:args, :a, s(:lasgn, :b, s(:lit, 1)), :"*c", s(:kwarg, :d), s(:kwarg, :e, s(:lit, 2)), :"**f"))

      assert_equal 1, args.min_count
      assert_predicate args.max_count, :infinite?
      assert_equal "1+", args.count_string
      assert_equal [:d], args.required_keywords
      assert_equal [:d, :e], args.allowed_keywords
      assert_predicate args, :variadic?
      assert_predicate args, :varikwardic?
    end

    def test_evaluate_call
      scope = BogusScope.new

      args = Arguments.new(s(:args, :a, s(:lasgn, :b, s(:lit, 1))))
      call1 = Call.new([s(:lit, 42)], scope)
      call2 = Call.new([s(:lit, 77), s(:lit, 2)], scope)

      call1.process
      call2.process

      assert_equal({ a: 42, b: 1 }, args.evaluate_call(call1, scope))
      assert_equal({ a: 77, b: 2 }, args.evaluate_call(call2, scope))
    end

    def test_evaluate_call_with_kwargs
      scope = BogusScope.new

      args = Arguments.new(s(:args, :a, s(:lasgn, :b, s(:lit, 1)), s(:kwarg, :c), s(:kwarg, :d, s(:lit, 3))))
      call1 = Call.new([s(:lit, 42), s(:hash, s(:lit, :c), s(:lit, 7))], scope)
      call2 = Call.new([s(:lit, 77), s(:lit, 2), s(:hash, s(:lit, :c), s(:lit, 8), s(:lit, :d), s(:lit, 4))], scope)

      call1.process
      call2.process

      assert_equal({ a: 42, b: 1, c: 7, d: 3 }, args.evaluate_call(call1, scope))
      assert_equal({ a: 77, b: 2, c: 8, d: 4 }, args.evaluate_call(call2, scope))
    end

    def test_evaluate_call_with_splat
      # TODO: needs array logic
    end

    def test_evaluate_call_with_ksplat
      # TODO: needs hash logic
    end

    class BogusScope < Scope
      def initialize
        super(nil, nil, nil)
      end

      def process_lit_expression(value)
        value
      end
    end
  end
end