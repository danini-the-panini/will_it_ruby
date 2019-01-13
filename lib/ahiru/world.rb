module Ahiru
  class World
    def initialize
      @listeners = {}
      @root_scope = MainScope.new self
    end

    def process_expression(sexp)
      @root_scope.process_expression(sexp)
    end
  end
end