require "test_helper"

module WillItRuby
  class Processor::InitializeTest < ProcessorTest
    def test_empty_case
      process <<-RUBY
        []
      RUBY

      assert_no_issues
      assert_result :Array, []
      assert_equal v_nil, last_evaluated_result.element_type
    end

    def test_non_empty_case
      process <<-RUBY
        [1, 2, 3]
      RUBY

      assert_no_issues
      assert_result :Array
      assert_type [:Integer, 1], last_evaluated_result.value[0]
      assert_type [:Integer, 2], last_evaluated_result.value[1]
      assert_type [:Integer, 3], last_evaluated_result.value[2]
      assert_maybe [:Integer, 1], [:Integer, 2], [:Integer, 3], last_evaluated_result.element_type
    end
  end
end
