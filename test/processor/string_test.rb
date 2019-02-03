require "test_helper"

module WillItRuby
  class Processor::StringTest < ProcessorTest
    def test_basic_case
      process <<-RUBY
        "asdf"
      RUBY

      assert_no_issues
      assert_result :String, "asdf"
    end

    def test_dynamic_case
      process <<-RUBY
        "asdf#{1}qwer"
      RUBY

      assert_no_issues
      assert_result :String, "asdf1qwer"
    end

    def test_dynamic_unknown_case
      process <<-'RUBY'
        foo = 'FOO'
        if Object.new == Object.new
          foo = 'BAR'
        end

        "asdf#{foo}qwer"
      RUBY

      assert_no_issues
      assert_maybe_result [:String, "asdfFOOqwer"], [:String, "asdfBARqwer"]
    end
  end
end
