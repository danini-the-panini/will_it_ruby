require "test_helper"

module Ahiru
  class Processor::InitializeTest < Minitest::Test
    def test_happy_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def initialize(a, b)
          end

          def foo
          end
        end

        Foo.new(1, 2).foo
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_sad_case
      processor = Processor.new
      processor.process_string <<-RUBY
        class Foo
          def initialize(a, b)
          end

          def foo
          end
        end

        Foo.new(1, 2, 3).foo
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):9 Wrong number of arguments (given 3, expected 2)", processor.issues.first.to_s
    end
  end
end
