module Ahiru
  class MethodScope < Scope
    def initialize(world, t_self, parent_scope = nil, ceiling_scope = nil)
      super(world, t_self, parent_scope, ceiling_scope, self)
       @return_types = []
    end

    def process_expression(sexp)
      super.tap do |t|
        @last_expression = t
      end
    end

    def process_return_from_child_scope(type)
      @return_types << type
    end

    def return_type
      @return_types.reduce(@last_expression) { |a,b| a | b }
    end
  end
end