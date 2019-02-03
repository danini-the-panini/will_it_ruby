module WillItRuby
  class Block < MethodDefinition
    attr_reader :scopes, :last_scope

    def initialize(args, expressions, processor, parent_scope)
      super(nil, args, expressions, processor, parent_scope)
      @scopes = []
    end

    def make_call(yielding_scope, call, maybe: false)
      @last_scope = BlockScope.new(@processor, @expressions, @parent_scope, yielding_scope, @parent_scope.self_type)
      @last_scope.maybe = maybe
      @scopes << @last_scope
      @args.assign_arguments_to_scope(call, @last_scope)
      @last_scope.process
    end
  end
end