module Ahiru
  class MethodDefinitionResolver < BlockDefinitionResolver
    attr_reader :malleable_ducks

    def initialize(name, args_exp, expressions, parent_scope)
      super(args_exp, expressions, parent_scope)
      @name = name
    end

    def create_scope
      MethodScope.new(@parent_scope.world, @parent_scope.t_self.instance_type, @parent_scope, @parent_scope)
    end

    def resolve
      callable = super

      if @scope.block
        callable.block = @scope.block
        callable.free_types << @scope.block.return_type
      end

      Method.from_callable(callable, @scope.t_self, @name)
    end
  end
end