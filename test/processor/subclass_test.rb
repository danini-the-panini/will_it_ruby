require "test_helper"

module Ahiru
  class Processor::MethodExistenceTest < Minitest::Test
    def test_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo
          end
        end

        class Bar < Foo
          def bar
            self.foo
          end
        end

        Bar.new.foo
        Bar.new.bar
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

        class Bar < Foo
          def bar
            self.baz
          end
        end

        Bar.new.bar
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):8 Undefined method `baz' for #<Bar>", processor.issues.first.to_s
    end
  end
end
