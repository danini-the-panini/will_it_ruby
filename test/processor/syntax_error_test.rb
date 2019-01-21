require "test_helper"

module Ahiru
  class Processor::SyntaxErrorTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
        end
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_sad_case
      process <<-RUBY
        class Foo
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):2 parse error on value \"$end\" ($end)", processor.issues.first.to_s
    end
  end
end
