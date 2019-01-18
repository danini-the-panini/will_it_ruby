require "test_helper"

module Ahiru
  class ProcessorTest < Minitest::Test
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

      refute_predicate processor.issues, :empty?
      assert_equal "(unknown):6 Undefined method `bar' for #<Foo>", processor.issues.first.to_s
    end
  end
end
