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
        if [1, nil].sample
          return
        else
          if [1, nil].sample
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
        def foo(x)
          if x
            return 1
          else
            return :a
          end
        end

        foo([1, nil].sample)
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
        foo([1, nil].sample)
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
      
      process <<-RUBY
        foo([1, nil].sample)
      RUBY

      assert_no_issues
      assert_maybe_result [:NilClass], [:Integer, 2]
    end

    def test_partial_case2
      process <<-RUBY
        def foo(a)
          b = 1

          if a.nil?
            return b
          else
            b = a + 7
          end

          b
        end

        foo(7)
      RUBY

      assert_no_issues
      assert_result :Integer, 14
      
      process <<-RUBY
        foo(nil)
      RUBY

      assert_no_issues
      assert_result :Integer, 1
      
      process <<-RUBY
        foo([42, nil].sample)
      RUBY

      assert_no_issues
      assert_maybe_result [:Integer, 1], [:Integer, 49]
    end
  end
end
