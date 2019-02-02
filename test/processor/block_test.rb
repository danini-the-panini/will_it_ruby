require "test_helper"

module WillItRuby
  class Processor::BlockTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        def foo
          yield
        end

        foo do
          1
        end
      RUBY

      assert_no_issues
      assert_result :Integer, 1
    end

    def test_sad_case
      process <<-RUBY
        def foo
          yield
        end

        foo
      RUBY

      assert_issues "(unknown):3 no block given (yield)"
    end
  end
end
