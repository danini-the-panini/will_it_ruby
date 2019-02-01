module WillItRuby
  class Issue
    attr_reader :file, :line, :message

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