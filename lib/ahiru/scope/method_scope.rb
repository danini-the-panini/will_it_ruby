module Ahiru
  class MethodScope < Scope
    def initialize(processor, expressions, parent, self_type)
      super(processor, expressions, parent)
      @self_type = self_type
    end
  end
end