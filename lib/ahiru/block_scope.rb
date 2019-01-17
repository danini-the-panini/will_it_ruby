module Ahiru
  class BlockScope < Scope
    def initialize(*)
      super
      @last_expression = T_Nil
    end

    def process_expression(sexp)
      super.tap do |t|
        @last_expression = t
      end
    end

    def return_type
      @last_expression
    end
  end
end