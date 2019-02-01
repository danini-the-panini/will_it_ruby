require "test_helper"

module WillItRuby
  class Processor::SyntaxErrorTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
        end
      RUBY

      assert_no_issues
    end

    def test_sad_case
      process <<-RUBY
        class Foo
      RUBY

      assert_issues "(unknown):2 parse error on value \"$end\" ($end)"
    end
  end
end
