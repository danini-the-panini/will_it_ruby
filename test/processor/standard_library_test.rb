require "test_helper"

module Ahiru
  class Processor::StandardLibraryTest < Minitest::Test
    def test_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        nil.nil?
        nil.to_s
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
        nil.upcase
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):1 Undefined method `upcase' for nil:NilClass", processor.issues.first.to_s
    end
  end
end
