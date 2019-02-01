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
  end
end
