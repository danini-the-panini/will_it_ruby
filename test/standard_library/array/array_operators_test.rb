require "test_helper"

module WillItRuby
  class StandardLibrary::ArrayOperatorsTest < ProcessorTest
    def test_union
      process <<-RUBY
        [1,2] | [2, 3]
      RUBY

      assert_no_issues
      assert_result :Array
      # TODO: when implemented ...
      # assert_equal [1, 2, 2, 3], last_evaluated_result.value.map(&:value)
    end

    def test_intersection
      process <<-RUBY
        [1,2] & [2, 3]
      RUBY

      assert_no_issues
      assert_result :Array
      # TODO: when implemented ...
      # assert_equal [2], last_evaluated_result.value.map(&:value)
    end

    def test_addition
      process <<-RUBY
        [1,2] + [2, 3]
      RUBY

      assert_no_issues
      assert_result :Array
      assert_equal [1, 2, 2, 3], last_evaluated_result.value.map(&:value)
    end

    def test_subtraction
      process <<-RUBY
        [1,2] - [2, 3]
      RUBY

      assert_no_issues
      assert_result :Array
      # TODO: when implemented ...
      # assert_equal [1], last_evaluated_result.value.map(&:value)
    end

    [[:union, :|], [:intersection, :&], [:addition, :+], [:subtraction, :-]].each do |name, op|
      define_method("test_#{name}_type_check") do
        process <<-RUBY
          [1,2] #{op} 7
        RUBY

        assert_issues "(unknown):1 no implicit conversion of Integer into Array"
      end

      define_method("test_#{name}_type_conversion") do
        process <<-RUBY
          class Foo
            def to_ary
              [2, 3]
            end
          end

          [1,2] #{op} Foo.new
        RUBY

        assert_no_issues
        assert_result :Array
      end

      define_method("test_#{name}_broken_type_conversion") do
        process <<-RUBY
          class Foo
            def to_ary
              7
            end
          end

          [1,2] #{op} Foo.new
        RUBY

        assert_issues "(unknown):7 can't convert Foo to Array (Foo#to_ary gives Integer)"
      end
    end

    def test_multiply_integer
      process <<-RUBY
        [1, 2] * 3
      RUBY

      assert_no_issues
      assert_result :Array
      assert_equal [1, 2, 1, 2, 1, 2], last_evaluated_result.value.map(&:value)
    end

    def test_multiply_string
      process <<-RUBY
        [1, 2] * ','
      RUBY

      assert_no_issues
      assert_result :String #, '1,2' # TODO: when implemented ...
    end

    def test_multiply_type_check
      process <<-RUBY
        [1, 2] * Object.new
      RUBY

      assert_issues "(unknown):1 no implicit conversion of Object into Integer"
    end
  end
end
