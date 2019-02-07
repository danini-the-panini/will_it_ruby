require "test_helper"

module WillItRuby
  class StandardLibrary::ArrayMapTest < ProcessorTest
    def test_basic_map
      process <<-RUBY
        a = [1,2,3]
        a.map do |x|
          x.to_s
        end
      RUBY

      assert_no_issues
      last_evaluated_result.value.each do |v|
        assert_type :String, v
      end
      assert_equal ['1', '2', '3'], last_evaluated_result.value.map(&:value)
    end
  end
end