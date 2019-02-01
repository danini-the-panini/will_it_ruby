require "test_helper"

module WillItRuby
  class StandardLibrary::NilClassTest < ProcessorTest
    def test_nil?
      process <<-RUBY
        nil.nil?
      RUBY

      assert_no_issues
      assert_equal v_true, processor.last_evaluated_result
    end

    def test_to_s
      process <<-RUBY
        nil.to_s
      RUBY

      assert_no_issues
      assert_result :String, ''
    end

    def test_sad_case
      process <<-RUBY
        nil.upcase
      RUBY

      assert_issues "(unknown):1 Undefined method `upcase' for nil:NilClass"
    end
  end
end
