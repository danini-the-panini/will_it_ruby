require "test_helper"

module WillItRuby
  class Processor::MethodExistenceTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
          def foo
          end
        end

        Foo.new.foo
      RUBY

      assert_no_issues
    end

    def test_sad_case
      process <<-RUBY
        class Foo
          def foo
          end
        end

        Foo.new.bar
      RUBY

      assert_issues "(unknown):6 Undefined method `bar' for #<Foo>"
    end

    def test_indirect_happy_case
      process <<-RUBY
        class Foo
          def foo
            self.bar
          end

          def bar
          end
        end

        Foo.new.foo
      RUBY

      assert_no_issues
    end

    def test_indirect_sad_case
      process <<-RUBY
        class Foo
          def foo
            self.baz
          end

          def bar
          end
        end

        Foo.new.foo
      RUBY

      assert_issues "(unknown):3 Undefined method `baz' for #<Foo>"
    end

    def test_argument_happy_case
      process <<-RUBY
        class Foo
          def foo(a)
            a.bar
          end

          def bar
          end
        end

        class Bar
          def bar
          end
        end

        Foo.new.foo(Bar.new)
      RUBY

      assert_no_issues
    end

    def test_argument_sad_case
      process <<-RUBY
        class Foo
          def foo(a)
            a.baz
          end

          def bar
          end
        end

        class Bar
          def bar
          end
        end

        Foo.new.foo(Bar.new)
      RUBY

      assert_issues "(unknown):3 Undefined method `baz' for #<Bar>"
    end
  end
end
