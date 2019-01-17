require "test_helper"

module Ahiru
  class ProcessorTest < Minitest::Test
    def test_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        def foo
        end

        foo
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
        def bar
        end

        foo
      RUBY

      refute_predicate processor.issues, :empty?
    end
  end
end
