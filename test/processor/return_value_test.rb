require "test_helper"

module WillItRuby
  class Processor::ReturnValueTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
          def foo
          end
        end

        class Bar
          def make_foo
            Foo.new
          end
        end

        Bar.new.make_foo.foo
      RUBY

      assert_no_issues
    end

    def test_sad_case
      process <<-RUBY
        class Foo
          def foo
          end
        end

        class Bar
          def make_foo
            Foo.new
          end
        end

        Bar.new.make_foo.bar
      RUBY

      assert_issues "(unknown):12 Undefined method `bar' for #<Foo>"
    end
  end
end
