module Ahiru
  class Issue
    def initialize(file, line, message)
      @file = file
      @line = line
      @message = message
    end

    def to_s
      "#{@file}:#{@line} #{@message}"
    end
  end
end