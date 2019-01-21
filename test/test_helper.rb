$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "ahiru"

require "minitest/autorun"

module Ahiru
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
