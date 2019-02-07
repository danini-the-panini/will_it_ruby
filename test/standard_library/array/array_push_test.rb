require "test_helper"

module WillItRuby
  class StandardLibrary::ArrayPushTest < ProcessorTest
    def test_basic_push
      process <<-RUBY
        a = [1,2,3]
        a << 4
      RUBY

      assert_no_issues
      last_evaluated_result.value.each do |v|
        assert_type :Integer, v
      end
      assert_equal [1, 2, 3, 4], last_evaluated_result.value.map(&:value)
    end

    def test_empty_get
      process <<-RUBY
        a = []
        a << 7
      RUBY

      assert_no_issues
      last_evaluated_result.value.each do |v|
        assert_type :Integer, v
      end
      assert_equal [7], last_evaluated_result.value.map(&:value)
      assert_type :Integer, last_evaluated_result.element_type
    end
  end
end