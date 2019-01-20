require "test_helper"

module Ahiru
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
      assert_nil args.max_count
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
      assert_nil args.max_count
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
      assert_nil args.max_count
      assert_equal "1+", args.count_string
      assert_equal [:d], args.required_keywords
      assert_equal [:d, :e], args.allowed_keywords
      assert_predicate args, :variadic?
      assert_predicate args, :varikwardic?
    end
  end
end