require "test_helper"

module Ahiru
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

      assert_predicate processor.issues, :empty?
      assert_kind_of Maybe::Object, processor.last_evaluated_result
      maybe_int, maybe_float = processor.last_evaluated_result.possiblities
      assert_equal processor.object_class.get_constant(:Integer), maybe_int.class_definition
      assert_equal 2, maybe_int.value
      assert_equal processor.object_class.get_constant(:Float), maybe_float.class_definition
      assert_equal 2.5, maybe_float.value
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

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):11 Undefined method `/' for nil:NilClass", processor.issues.first.to_s
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

      assert_predicate processor.issues, :empty?
      assert_kind_of Maybe::Object, processor.last_evaluated_result
      maybe_int, maybe_float = processor.last_evaluated_result.possiblities
      assert_equal processor.object_class.get_constant(:Integer), maybe_int.class_definition
      assert_equal 2, maybe_int.value
      assert_equal processor.object_class.get_constant(:Float), maybe_float.class_definition
      assert_equal 2.5, maybe_float.value
    end
  end
end
