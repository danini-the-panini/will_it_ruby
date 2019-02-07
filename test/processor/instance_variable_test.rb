require "test_helper"

module WillItRuby
  class Processor::InstanceVariableTest < ProcessorTest
    def test_basic_case
      process <<-RUBY
        class Foo
          def set_foo(a)
            @foo = a
          end

          def get_foo
            @foo
          end
        end

        foo = Foo.new
        foo.get_foo
      RUBY

      assert_no_issues
      assert_result :NilClass

      process <<-RUBY
        foo = Foo.new
        foo.set_foo(7)
      RUBY

      assert_no_issues
      assert_result :Integer, 7

      process <<-RUBY
        foo = Foo.new
        foo.set_foo(7)
        foo.get_foo
      RUBY

      assert_no_issues
      assert_result :Integer, 7
    end

    def test_optional_case
      process <<-RUBY
        class Foo
          def set_foo(a, b)
            if [1, nil].sample
              @foo = a
            else
              @foo = b
            end
          end

          def get_foo
            @foo
          end
        end

        foo = Foo.new
        foo.set_foo(1, 2)
        foo.get_foo
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 1], [:Integer, 2]
    end

    def test_block_case
      process <<-RUBY
        def foo(a)
          yield(-a)
        end

        class Bar
          def bar(a)
            foo(a + 1) do |x|
              @bar = x * 2
            end
          end

          def get_bar
            @bar
          end
        end

        bar = Bar.new
        bar.bar(7)
        bar.get_bar
      RUBY

      assert_no_issues
      assert_result :Integer, -16
    end

    def test_yield_if_case
      process <<-RUBY
        def foo(a)
          if [1, nil].sample
            yield(-a)
          else
            yield(a)
          end
        end

        class Bar
          def bar(a)
            foo(a + 1) do |x|
              @bar = x * 2
            end
          end

          def get_bar
            @bar
          end
        end

        bar = Bar.new
        bar.bar(7)
        bar.get_bar
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 16], [:Integer, -16]
    end

    def test_if_in_block_case
      process <<-RUBY
        def foo(a)
          yield(-a)
        end

        class Bar
          def bar(a)
            foo(a + 1) do |x|
              if [1, nil].sample
                @bar = x * 2
              end
            end
          end

          def get_bar
            @bar
          end
        end

        bar = Bar.new
        bar.bar(7)
        bar.get_bar
      RUBY

      assert_no_issues
      assert_maybe_result [:NilClass], [:Integer, -16]
    end

    def test_block_in_if_case
      process <<-RUBY
        def foo(a)
          yield(-a)
        end

        class Bar
          def bar(a)
            if [1, nil].sample
              foo(a + 1) do |x|
                @bar = x * 2
              end
            end
          end

          def get_bar
            @bar
          end
        end

        bar = Bar.new
        bar.bar(7)
        bar.get_bar
      RUBY

      assert_no_issues
      assert_maybe_result [:NilClass], [:Integer, -16]
    end
  end
end
