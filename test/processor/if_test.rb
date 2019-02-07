require "test_helper"

module WillItRuby
  class Processor::IfTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
          def foo(x)
            if x
              5
            else
              5.0
            end
          end
        end

        Foo.new.foo([1, nil].sample) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_sad_case
      process <<-RUBY
        class Foo
          def foo(x)
            if x
              5
            else
              nil
            end
          end
        end

        Foo.new.foo([1, nil].sample) / 2
      RUBY

      assert_issues "(unknown):11 Undefined method `/' for nil:NilClass"
    end

    def test_implicit_else_case
      process <<-RUBY
        class Foo
          def foo(x)
            if x
              5
            end
          end
        end

        Foo.new.foo([1, nil].sample) / 2
      RUBY

      assert_issues "(unknown):9 Undefined method `/' for nil:NilClass"
    end

    def test_lasgn_case
      process <<-RUBY
        class Foo
          def foo(x)
            x = if x
                  5
                else
                  5.0
                end

            x
          end
        end

        Foo.new.foo([1, nil].sample) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_lasgn_inside_case
      process <<-RUBY
        class Foo
          def foo(a)
            x = nil
            
            if a
              x = 5
            else
              x = 5.0
            end

            x
          end
        end

        Foo.new.foo([1, nil].sample) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_lasgn_sometimes_case
      process <<-RUBY
        class Foo
          def foo(a)
            x = 5.0
            
            if a
              x = 5
            end

            x
          end
        end

        Foo.new.foo([1, nil].sample) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5]
    end

    def test_nested_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            if a
              5
            elsif b
              5.0
            else
              0
            end
          end
        end

        a = [1, nil]
        Foo.new.foo(a.sample, a.sample) / 2
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 2], [:Float, 2.5], [:Integer, 0]
    end

    def test_nested_lasgn_case
      process <<-RUBY
        class Foo
          def foo(a, b)
            x = nil
            if a
              x = 5
            elsif b
              x = 5.0
            else
              x = 0
            end
            x
          end
        end

        a = [1, nil]
        Foo.new.foo(a.sample, a.sample) / 2
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

      process <<-RUBY
        foo([1, nil].sample)
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 0], [:Integer, 3]
    end

    def test_maybe_nil_check
      process <<-RUBY
        r = [1,nil].sample

        x = if r.nil?
              'asdf'
            else
              nil
            end

        x
      RUBY

      assert_no_issues
      assert_maybe_result [:String, 'asdf'], [:NilClass]
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
        maybe = [1, nil].sample

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
        maybe = [1, nil].sample

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
        maybe = [1, :a].sample

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
        maybe = [1, 1.5, nil].sample

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
        maybe = [1, nil].sample

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
        maybe = [1, nil].sample

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
        foo([true, false].sample)
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
