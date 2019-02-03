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

    def test_argument_case
      process <<-RUBY
        def foo(a)
          4 + yield(a - 1)
        end

        foo(7) do |x|
          x * 42
        end
      RUBY

      assert_no_issues
      assert_result :Integer, 256
    end

    def test_block_arguments_are_permissive
      process <<-RUBY
        def foo
          yield 1, 2, 3
        end

        foo do
          1
        end
      RUBY

      assert_no_issues
      assert_result :Integer, 1

      process <<-RUBY
        foo do |a,b,c,d|
          a + b + c
        end
      RUBY

      assert_no_issues
      assert_result :Integer, 6

      process <<-RUBY
        foo do |a,b,c,d|
          d
        end
      RUBY

      assert_no_issues
      assert_result :NilClass
    end

    def test_block_scope
      process <<-RUBY
        class Foo
          def foo
            a = 1
            yield(7)
            a
          end

          def bar
            1
          end
        end

        class Bar
          def baz
            a = 2
            Foo.new.foo do |x|
              a = a + x
            end
            a
          end
        end

        Foo.new.foo do |x|
          x + 1
        end
      RUBY

      assert_no_issues
      assert_result :Integer, 1

      process <<-RUBY
        Bar.new.baz
      RUBY

      assert_no_issues
      assert_result :Integer, 9

      process <<-RUBY
        Foo.new.foo do
          bar
        end
      RUBY

      assert_issues "(unknown):2 Undefined local variable or method `bar' for main:Object"
    end

    def test_block_return
      process <<-RUBY
        def foo
          a = 1
          yield
          a
        end

        def bar
          foo do
            return 2
          end
        end

        bar
      RUBY

      assert_no_issues
      assert_result :Integer, 2
    end

    def test_yield_in_if
      process <<-RUBY
        def foo(a, b)
          if a == b
            yield
          end
        end

        a = 1
        foo(Object.new, Object.new) do
          a = 2
        end

        a
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 1], [:Integer, 2]
    end
  end
end
