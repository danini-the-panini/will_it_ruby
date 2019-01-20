module Ahiru
  class MethodScope < Scope
    def initialize(processor, expressions, parent, self_type)
      super(processor, expressions, parent)
      @self_type = self_type
    end

    def process
      super
      return_value
    end

    def return_value
      @last_evaluated_result
    end
  end
end