$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "will_it_ruby"

require "minitest/autorun"

module WillItRuby
  class ProcessorTest < Minitest::Test
    attr_reader :processor
    include ProcessorDelegateMethods

    def setup
      @processor = Processor.new
    end

    def process(string)
      @processor.process_string(string)
    end

    def assert_no_issues
      assert processor.issues.empty?, "Expected no issues, got the following issues:\n\n#{print_issues(processor.issues)}"
    end

    def assert_issues(*issues)
      result = issues.all? do |e|
        processor.issues.find do |a|
          e.to_s == a.to_s
        end
      end
      assert result, "Expected Issues:\n#{print_issues(issues)}\nGot Issues:\n#{print_issues(processor.issues)}"
    end

    def assert_result(expected_type_name, expected_value=nil)
      assert_type([expected_type_name, expected_value], last_evaluated_result)
    end

    def assert_maybe_result(*expected_results)
      assert_maybe(*expected_results, last_evaluated_result)
    end

    def assert_type(expected_type_name, actual_type)
      if expected_type_name.is_a?(Array)
        expected_type_name, expected_value = *expected_type_name
      else
        expected_value = nil
      end
      expected_type = get_type(expected_type_name)
      assert_kind_of ClassInstance, actual_type
      assert same_type(expected_type_name, actual_type), "Expected #{actual_type.inspect} to be of type #{expected_type.inspect}"
      assert same_value(expected_value, actual_type), "Expected #{actual_type.inspect} to have value #{expected_value.inspect}"
    end

    def assert_maybe(*expected_results, actual_type)
      assert_kind_of Maybe::Object, actual_type, "Expected #{actual_type.inspect} to be a Maybe"
      result = expected_results.all? do |expected_type_name, expected_value=nil|
        actual_type.possibilities.find do |possibility|
          same_type(expected_type_name, possibility) && same_value(expected_value, possibility)
        end
      end
      assert result, "Expected #{actual_type.inspect} to have possibilities #{print_expected_possibilities(expected_results)}"
    end

    def last_evaluated_result
      processor.last_evaluated_result
    end

    private

    def get_type(name)
      processor.object_class.get_constant(name)
    end

    def same_type(expected, actual)
      expected_type = expected.is_a?(Symbol) ? get_type(expected) : expected
      expected_type == actual.class_definition
    end

    def same_value(expected, actual)
      return true if expected.nil?
      actual.value_known? && actual.value == expected
    end

    def print_expected_possibilities(possibilities)
      <<-STRING
        (#{possibilities.map { |t,v=nil|
          v.nil? ? "?:#{t}" : "#{v.inspect}:#{t}"
        }.join(' | ')})
      STRING
    end

    def print_issues(issues)
      issues.map { |i| "\t#{i}"}.join("\n")
    end
  end
end
