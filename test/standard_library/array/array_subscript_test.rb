require "test_helper"

module WillItRuby
  class StandardLibrary::ArraySubscriptTest < ProcessorTest
    def test_empty_get
      process <<-RUBY
        a = []
        a[0]
      RUBY

      assert_no_issues
      assert_result :NilClass
    end

    def test_basic_get
      process <<-RUBY
        a = [1,2,3]
        a[1]
      RUBY

      assert_no_issues
      assert_result :Integer, 2
    end

    def test_out_of_bound_get
      process <<-RUBY
        a = [1,2,3]
        a[3]
      RUBY

      assert_no_issues
      assert_result :NilClass
    end

    def test_basic_set
      process <<-RUBY
        a = [1,2,3]
        a[1] = 7

        a
      RUBY

      assert_no_issues
      assert_result :Array
      last_evaluated_result.value.each do |v|
        assert_type :Integer, v
      end
      assert_equal [1, 7, 3], last_evaluated_result.value.map(&:value)
    end
  end
end