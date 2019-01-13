module Ahiru
  class Tool
    def initialize
      @world = World.new
    end

    def process_file(path)
      @world.process_file(path)
    end

    def issues
      @world.all_issues
    end
  end
end