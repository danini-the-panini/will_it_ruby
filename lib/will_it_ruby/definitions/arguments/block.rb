module WillItRuby
  class Block < MethodDefinition
    attr_reader :scope

    def initialize(args, expressions, processor, parent_scope)
      super(nil, args, expressions, processor, parent_scope)
    end

    def make_call(yielding_scope, call)
      @scope = BlockScope.new(@processor, @expressions, @parent_scope, yielding_scope, @parent_scope.self_type)
      @args.assign_arguments_to_scope(call, scope)
      scope.process
    end
  end
end