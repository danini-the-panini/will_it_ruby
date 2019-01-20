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

    def test_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a, b)
          end
        end

        Foo.new.foo(1)
        Foo.new.foo(1, 2, 3)
      RUBY

      assert_equal 2, processor.issues.count
      assert_equal "(unknown):6 Wrong number of arguments (given 1, expected 2)", processor.issues[0].to_s
      assert_equal "(unknown):7 Wrong number of arguments (given 3, expected 2)", processor.issues[1].to_s
    end

    def test_optional_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a, b=1)
          end
        end

        Foo.new.foo(1, 2)
        Foo.new.foo(1)
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_optional_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a, b=1)
          end
        end

        Foo.new.foo()
        Foo.new.foo(1, 2, 3)
      RUBY

      assert_equal 2, processor.issues.count
      assert_equal "(unknown):6 Wrong number of arguments (given 0, expected 1..2)", processor.issues[0].to_s
      assert_equal "(unknown):7 Wrong number of arguments (given 3, expected 1..2)", processor.issues[1].to_s
    end

    def test_kwarg_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a:, b:1)
          end
        end

        Foo.new.foo(a:1)
        Foo.new.foo(a:1, b:2)
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_kwarg_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo(a:, b:1)
          end
        end

        Foo.new.foo()
        Foo.new.foo(a:1, b:2, c:3)
      RUBY

      assert_equal 2, processor.issues.count
      assert_equal "(unknown):6 Wrong number of arguments (missing required keywords: a)", processor.issues[0].to_s
      assert_equal "(unknown):7 Wrong number of arguments (unknown keywords: c)", processor.issues[1].to_s
    end
  end
end
