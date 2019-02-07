require "test_helper"

module WillItRuby
  class Processor::SymbolTest < ProcessorTest
    def test_basic_case
      process <<-RUBY
        :asdf
      RUBY

      assert_no_issues
      assert_result :Symbol, :asdf
    end

    def test_dynamic_case
      process <<-RUBY
        :"asdf#{1}qwer"
      RUBY

      assert_no_issues
      assert_result :Symbol, :asdf1qwer
    end

    def test_dynamic_unknown_case
      process <<-'RUBY'
        foo = 'FOO'
        if [1, nil].sample
          foo = 'BAR'
        end

        :"asdf#{foo}qwer"
      RUBY

      assert_no_issues
      assert_maybe_result [:Symbol, :asdfFOOqwer], [:Symbol, :asdfBARqwer]
    end
  end
end
