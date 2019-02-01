require "test_helper"

module WillItRuby
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

      assert_no_issues
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

      assert_issues "(unknown):8 Undefined method `baz' for #<Bar>"
    end

    def test_sad_superclass_case
      process <<-RUBY
        class Foo < nil
        end
      RUBY

      assert_issues "(unknown):1 superclass must be a Class (NilClass given)"
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

      assert_no_issues
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

      assert_issues "(unknown):4 superclass mismatch for class Foo",
                    "(unknown):10 superclass mismatch for class Bar"
    end
  end
end
