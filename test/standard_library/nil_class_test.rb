require "test_helper"

module Ahiru
  class StandardLibrary::NilClassTest < ProcessorTest
    def test_nil?
      process <<-RUBY
        nil.nil?
      RUBY

      assert_predicate processor.issues, :empty?
      assert_equal v_true, processor.last_evaluated_result
    end

    def test_to_s
      process <<-RUBY
        nil.to_s
      RUBY

      assert_predicate processor.issues, :empty?
      assert_equal processor.object_class.get_constant(:String), processor.last_evaluated_result.class_definition
      assert_equal '', processor.last_evaluated_result.value
    end

    def test_sad_case
      process <<-RUBY
        nil.upcase
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):1 Undefined method `upcase' for nil:NilClass", processor.issues.first.to_s
    end
  end
end
