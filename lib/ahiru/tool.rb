module Ahiru
  class Tool
    def initialize
      @world = World.new
    end

    def process_string(string, filename='<?>')
      expression = RubyParser.new.parse(string)

      if expression[0] == :block
        _, *expressions = expression
      else
        expressions = [expression]
      end

      expressions.each do |exp|
        @world.process_expression(exp)
      end
    end

    def process_file(path)
      string = File.read(path)

      process_string(string, path)
    end
  end
end