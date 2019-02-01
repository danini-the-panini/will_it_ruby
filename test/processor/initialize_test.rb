require "test_helper"

module WillItRuby
  class Processor::InitializeTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
          def initialize(a, b)
          end

          def foo
          end
        end

        Foo.new(1, 2).foo
      RUBY

      assert_no_issues
    end

    def test_sad_case
      process <<-RUBY
        class Foo
          def initialize(a, b)
          end

          def foo
          end
        end

        Foo.new(1, 2, 3).foo
      RUBY

      assert_issues "(unknown):9 Wrong number of arguments (given 3, expected 2)"
    end
  end
end
