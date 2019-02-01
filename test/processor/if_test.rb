require "test_helper"

module WillItRuby
  class Processor::IfTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            if a == b
              5
            else
              5.0
            end
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_sad_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            if a == b
              5
            else
              nil
            end
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_issues "(unknown):11 Undefined method `/' for nil:NilClass"
    end

    def test_implicit_else_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            if a == b
              5
            end
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_issues "(unknown):9 Undefined method `/' for nil:NilClass"
    end

    def test_lasgn_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            x = if a == b
                  5
                else
                  5.0
                end

            x
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_lasgn_inside_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            x = nil
            
            if a == b
              x = 5
            else
              x = 5.0
            end

            x
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_lasgn_sometimes_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            x = 5.0
            
            if a == b
              x = 5
            end

            x
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_nested_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            if a == b
              5
            elsif b.equal?(a)
              5.0
            else
              0
            end
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5], [:Integer, 0]
    end

    def test_nested_lasgn_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            x = nil
            if a == b
              x = 5
            elsif b.equal?(a)
              x = 5.0
            else
              x = 0
            end
            x
          end
        end

        Foo.new.foo(Object.new, Object.new) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5], [:Integer, 0]
    end

    def test_nil_check
      process <<-RUBY
        def foo(a)
          if a.nil?
            0
          else
            a + 2
          end
        end

        foo(1)
      RUBY

      assert_no_issues
      assert_result :Integer, 3

      process <<-RUBY
        foo(nil)
      RUBY

      assert_no_issues
      assert_result :Integer, 0
    end

    def test_is_a_check
      process <<-RUBY
        def foo(a)
          if a.is_a?(Numeric)
            a + 2
          else
            0
          end
        end

        foo(1)
      RUBY

      assert_no_issues
      assert_result :Integer, 3

      process <<-RUBY
        foo(nil)
      RUBY

      assert_no_issues
      assert_result :Integer, 0
    end

    def test_or
      process <<-RUBY
        def foo(a)
          if a.is_a?(Integer) || a.is_a?(Float)
            a + 2
          else
            0
          end
        end

        foo(1)
      RUBY

      assert_no_issues
      assert_result :Integer, 3

      process <<-RUBY
        foo(1.2)
      RUBY

      assert_no_issues
      assert_result :Float, 3.2

      process <<-RUBY
        foo(nil)
      RUBY

      assert_no_issues
      assert_result :Integer, 0
    end

    def test_and
      process <<-RUBY
        def foo(a)
          if !a.nil? && a > 7
            a - 5
          else
            0
          end
        end

        foo(8)
      RUBY

      assert_no_issues
      assert_result :Integer, 3

      process <<-RUBY
        foo(1.2)
      RUBY

      assert_no_issues
      assert_result :Integer, 0

      process <<-RUBY
        foo(nil)
      RUBY

      assert_no_issues
      assert_result :Integer, 0
    end

    def test_quantum_type_checking_nil
      process <<-RUBY
        def foo(a, b)
          if a == b
            1
          else
            nil
          end
        end

        maybe = foo(Object.new, Object.new)

        x = if maybe.nil?
          2.5
        else
          maybe + 1
        end
      RUBY

      assert_no_issues
      assert_maybe_result [:Float, 2.5], [:Integer, 2]
    end

    def test_quantum_type_checking_not
      process <<-RUBY
        def foo(a, b)
          if a == b
            1
          else
            nil
          end
        end

        maybe = foo(Object.new, Object.new)

        x = if !maybe.nil?
          maybe + 1
        else
          2.5
        end
      RUBY

      assert_no_issues
      assert_maybe_result [:Float, 2.5], [:Integer, 2]
    end

    def test_quantum_type_checking_is_a
      process <<-RUBY
        def foo(a, b)
          if a == b
            1
          else
            :a
          end
        end

        maybe = foo(Object.new, Object.new)

        x = if maybe.is_a?(Symbol)
          2.5
        else
          maybe + 1
        end
      RUBY

      assert_no_issues
      assert_maybe_result [:Float, 2.5], [:Integer, 2]
    end

    def test_quantum_type_checking_or
      process <<-RUBY
        def foo(a, b, c)
          if a == b
            1
          elsif a == c
            1.5
          else
            nil
          end
        end

        maybe = foo(Object.new, Object.new, Object.new)

        x = if maybe.is_a?(Integer) || maybe.is_a?(Float)
          maybe + 1
        else
          2.5
        end
      RUBY

      assert_no_issues
      assert_maybe_result [:Float, 2.5], [:Integer, 2]
    end

    def test_quantum_type_checking_or2
      process <<-RUBY
        def foo(a, b)
          if a == b
            1
          else
            nil
          end
        end

        maybe = foo(Object.new, Object.new)

        if maybe.nil? || maybe <= 0
          2.5
        else
          maybe + 1
        end
      RUBY

      assert_no_issues
      assert_maybe_result [:Float, 2.5], [:Integer, 2]
    end

    def test_quantum_type_checking_and
      process <<-RUBY
        def foo(a, b)
          if a == b
            1
          else
            nil
          end
        end

        maybe = foo(Object.new, Object.new)

        if !maybe.nil? && maybe > 0
          maybe + 1
        else
          2.5
        end
      RUBY

      assert_no_issues
      assert_maybe_result [:Float, 2.5], [:Integer, 2]
    end

    def test_case_when
      process <<-RUBY
        def foo(a)
          case a
          when Integer, Float
            a + 1
          when Symbol
            :a
          when true
            1
          when false
            0
          else
            7
          end
        end

        foo(1)
      RUBY

      assert_no_issues
      assert_result :Integer, 2

      process <<-RUBY
        foo(1.7)
      RUBY

      assert_no_issues
      assert_result :Float, 2.7

      process <<-RUBY
        foo(:foo)
      RUBY

      assert_no_issues
      assert_result :Symbol, :a

      process <<-RUBY
        foo(true)
      RUBY

      assert_no_issues
      assert_result :Integer, 1

      process <<-RUBY
        foo(Object.new == Object.new)
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 1], [:Integer, 0]

      process <<-RUBY
        foo(Object.new)
      RUBY

      assert_no_issues
      assert_result :Integer, 7
    end
  end
end
