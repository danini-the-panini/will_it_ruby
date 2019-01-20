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

        Foo.new.foo
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

        Foo.new.bar
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):6 Undefined method `bar' for #<Foo>", processor.issues.first.to_s
    end

    def test_indirect_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo
            self.bar
          end

          def bar
          end
        end

        Foo.new.foo
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_indirect_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def foo
            self.baz
          end

          def bar
          end
        end

        Foo.new.foo
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):3 Undefined method `baz' for #<Foo>", processor.issues.first.to_s
    end

    def test_argument_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
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

      assert_predicate processor.issues, :empty?
    end

    def test_argument_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
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

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):3 Undefined method `baz' for #<Bar>", processor.issues.first.to_s
    end
  end
end
