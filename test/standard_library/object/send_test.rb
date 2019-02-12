require "test_helper"

module WillItRuby
  class StandardLibrary::ObjectSend < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
          def foo(a)
            a + 1
          end
        end

        Foo.new.send(:foo, 7)
      RUBY

      assert_no_issues
      assert_result :Integer, 8
    end

    def test_sad_case
      process <<-RUBY
        class Foo
          def foo(a)
            a + 1
          end
        end

        Foo.new.send(:bar)
      RUBY

      assert_issues "(unknown):7 Undefined method `bar' for #<Foo>"
    end

    def test_sad_argument_case
      process <<-RUBY
        class Foo
          def foo(a)
            a + 1
          end
        end

        Foo.new.send(:foo)
      RUBY

      assert_issues "(unknown):7 Wrong number of arguments (given 0, expected 1)"
    end

    def test_maybe_case
      process <<-RUBY
        class Foo
          def foo(a)
            a + 1
          end

          def bar(b)
            b - 1
          end
        end

        m = [:foo, :bar].sample
        Foo.new.send(m, 7)
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 8], [:Integer, 6]
    end
  end
end
