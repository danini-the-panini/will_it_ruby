require "test_helper"

module WillItRuby
  class Processor::MainScopeTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        x = 7

        x
      RUBY

      assert_predicate processor.issues, :empty?
      assert_equal processor.object_class.get_constant(:Integer), processor.last_evaluated_result.class_definition
      assert_equal 7, processor.last_evaluated_result.value
    end

    def test_method_happy_case
      process <<-RUBY
        def x
          42
        end

        x
      RUBY

      assert_predicate processor.issues, :empty?
      assert_equal processor.object_class.get_constant(:Integer), processor.last_evaluated_result.class_definition
      assert_equal 42, processor.last_evaluated_result.value
    end

    def test_sad_case
      process <<-RUBY
        x + 1
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):1 Undefined local variable or method `x' for main:Object", processor.issues.first.to_s
    end
  end
end
