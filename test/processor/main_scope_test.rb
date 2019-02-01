require "test_helper"

module WillItRuby
  class Processor::MainScopeTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        x = 7

        x
      RUBY

      assert_no_issues
      assert_result :Integer, 7
    end

    def test_method_happy_case
      process <<-RUBY
        def x
          42
        end

        x
      RUBY

      assert_no_issues
      assert_result :Integer, 42
    end

    def test_sad_case
      process <<-RUBY
        x + 1
      RUBY

      assert_issues "(unknown):1 Undefined local variable or method `x' for main:Object"
    end
  end
end
