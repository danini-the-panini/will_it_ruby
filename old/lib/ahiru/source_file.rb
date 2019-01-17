module Ahiru
  class SourceFile < World
    def initialize(path, source, sexp, world)
      super()
      @path = path
      @source = source
      @sexp = sexp
      @world = world
      @scope = FileScope.new(self)
    end

    def process
      process_expression(@sexp)
    end

    def to_s
      @path
    end
  end
end