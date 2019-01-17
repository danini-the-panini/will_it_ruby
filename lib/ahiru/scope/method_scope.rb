module Ahiru
  class MethodScope < Scope
    def initialize(processor, sexp)
      super(processor, sexp, nil)
    end
  end
end