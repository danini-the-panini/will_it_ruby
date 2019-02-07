require "test_helper"

module WillItRuby
  class StandardLibrary::ArraySampleTest < ProcessorTest
    def test_common_case
      process <<-RUBY
        a = [1,2]
        a.sample
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 1], [:Integer, 2]
    end

    def test_single_case
      process <<-RUBY
        a = [7]
        a.sample
      RUBY

      assert_no_issues
      assert_result :Integer, 7
    end

    def test_empty_case
      process <<-RUBY
        a = []
        a.sample
      RUBY

      assert_no_issues
      assert_result :NilClass
    end
  end
end