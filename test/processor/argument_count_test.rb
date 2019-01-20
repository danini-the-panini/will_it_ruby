require "test_helper"

module Ahiru
  class Processor::ArgumentCountTest < Minitest::Test
    def test_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a, b)
          end
        end

        Foo.new.foo(1, 2)
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_too_many_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a, b)
          end
        end

        Foo.new.foo(1, 2, 3)
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):6 Wrong number of arguments (given 3, expected 2)", processor.issues.first.to_s
    end

    def test_too_few_many_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a, b)
          end
        end

        Foo.new.foo(1)
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):6 Wrong number of arguments (given 1, expected 2)", processor.issues.first.to_s
    end
  end
end
