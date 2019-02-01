require "test_helper"

module WillItRuby
  class Processor::ReturnTest < ProcessorTest
    def test_trivial_case
      process <<-RUBY
        def foo
          return 1
        end

        foo
      RUBY

      assert_no_issues
      assert_result :Integer, 1
    end

    def test_sad_case
      process <<-RUBY
        return
      RUBY

      # FIXME: line should be 1 but RubyParser insists it's 2
      assert_issues "(unknown):2 unexpected return"
    end

    def test_sad_if_case
      process <<-RUBY
        if Object.new == Object.new
          return
        else
          if Object.new == Object.new
            return
          end
        end
      RUBY


      # FIXME: line should be 2, 5 but RubyParser insists it's 3, 5
      assert_issues "(unknown):3 unexpected return",
                    "(unknown):6 unexpected return"
    end

    def test_if_case
      process <<-RUBY
        def foo(a, b)
          if a == b
            return 1
          else
            return :a
          end
        end

        foo(Object.new, Object.new)
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 1], [:Symbol, :a]
    end

    def test_guard_case
      process <<-RUBY
        def foo(a)
          return 0 if a.nil?

          a + 1
        end

        foo(7)
      RUBY

      assert_no_issues
      assert_result :Integer, 8
      
      process <<-RUBY
        foo(nil)
      RUBY

      assert_no_issues
      assert_result :Integer, 0
      
      process <<-RUBY
        foo(Object.new == Object.new ? 1 : nil)
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 0], [:Integer, 2]
    end

    def test_partial_case
      process <<-RUBY
        def foo(a)
          b = nil

          if !a.nil?
            b = 1
            return a + b
          end

          b
        end

        foo(7)
      RUBY

      assert_no_issues
      assert_result :Integer, 8
      
      process <<-RUBY
        foo(nil)
      RUBY

      assert_no_issues
      assert_result :NilClass
    end
  end
end
