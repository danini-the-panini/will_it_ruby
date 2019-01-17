module Ahiru
  class Issue
    def initialize(message, line, world)
      @message = message
      @line = line
      @world = world
    end

    def to_s
      "#{@world.to_s}:#{@line} #{@message}"
    end
  end
end