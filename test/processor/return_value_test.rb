require "test_helper"

module Ahiru
  class Processor::ReturnValueTest < Minitest::Test
    def test_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
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

      assert_predicate processor.issues, :empty?
    end

    def test_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
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

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):12 Undefined method `bar' for #<Foo>", processor.issues.first.to_s
    end
  end
end
