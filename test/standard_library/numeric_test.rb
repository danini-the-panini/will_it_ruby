require "test_helper"

module Ahiru
  class StandardLibrary::NumericTest < ProcessorTest
    def test_plus
      process <<-RUBY
        1 + 2
      RUBY

      assert_predicate processor.issues, :empty?
      assert_equal processor.object_class.get_constant(:Integer), processor.last_evaluated_result.class_definition
      assert_equal 3, processor.last_evaluated_result.value
    end

    def test_plus_sad_case
      process <<-RUBY
        1 + nil
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):1 nil:NilClass can't be coerced into Integer", processor.issues.first.to_s
    end
  end
end
