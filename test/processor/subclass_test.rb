require "test_helper"

module Ahiru
  class Processor::SubclassTest < ProcessorTest
    def test_happy_case
      process <<-RUBY
        class Foo
          def foo
          end
        end

        class Bar < Foo
          def bar
            self.foo
          end
        end

        Bar.new.foo
        Bar.new.bar
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_sad_method_case
      process <<-RUBY
        class Foo
          def foo
          end
        end

        class Bar < Foo
          def bar
            self.baz
          end
        end

        Bar.new.bar
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):8 Undefined method `baz' for #<Bar>", processor.issues.first.to_s
    end

    def test_sad_superclass_case
      process <<-RUBY
        class Foo < nil
        end
      RUBY

      assert_equal 1, processor.issues.count
      assert_equal "(unknown):1 superclass must be a Class (NilClass given)", processor.issues.first.to_s
    end

    def test_happy_moneypatch_case
      process <<-RUBY
        class Foo < BasicObject
        end

        class Foo
        end

        class Foo < BasicObject
        end
      RUBY

      assert_predicate processor.issues, :empty?
    end

    def test_sad_monkeypatch_case
      process <<-RUBY
        class Foo < BasicObject
        end

        class Foo < Object
        end

        class Bar
        end

        class Bar < BasicObject
        end
      RUBY

      assert_equal 2, processor.issues.count
      assert_equal "(unknown):4 superclass mismatch for class Foo", processor.issues[0].to_s
      assert_equal "(unknown):10 superclass mismatch for class Bar", processor.issues[1].to_s
    end
  end
end
