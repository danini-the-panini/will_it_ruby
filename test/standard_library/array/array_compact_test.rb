require "test_helper"

module WillItRuby
  class StandardLibrary::ArrayCompactTest < ProcessorTest
    def test_basic_copact
      process <<-RUBY
        a = [1,nil,3]
        a.compact
      RUBY

      assert_no_issues
      last_evaluated_result.value.each do |v|
        assert_type :Integer, v
      end
      assert_equal [1, 3], last_evaluated_result.value.map(&:value)
    end

    def test_compact_no_nils
        process <<-RUBY
          a = [1,2,3]
          a.compact
        RUBY

        assert_no_issues
        last_evaluated_result.value.each do |v|
          assert_type :Integer, v
        end
        assert_equal [1, 2, 3], last_evaluated_result.value.map(&:value)
    end

    def test_compact_all_nils
        process <<-RUBY
          a = [nil, nil, nil]
          a.compact
        RUBY

        assert_no_issues
        assert_type :NilClass, last_evaluated_result.element_type
        assert_equal [], last_evaluated_result.value
    end

    def test_compact_empty
        process <<-RUBY
          a = []
          a.compact
        RUBY

        assert_no_issues
        assert_type :NilClass, last_evaluated_result.element_type
        assert_equal [], last_evaluated_result.value
    end

    def test_maybe_nil_in_array
      process <<-RUBY
        maybe_nil = [7, nil].sample
        a = [1, maybe_nil, 2]
        a.compact
      RUBY

      assert_no_issues
      assert_maybe_result [:Array], [:Array]
      p1, p2 = last_evaluated_result.possibilities
      assert_equal [1, 2],    p1.value.map(&:value)
      assert_equal [1, 7, 2], p2.value.map(&:value)
    end
  end
end