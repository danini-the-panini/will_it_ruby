module WillItRuby
  class MethodDefinition
    def initialize(name, args, expressions, processor, parent_scope)
      @name = name
      @args = Arguments.new(args)
      @expressions = expressions
      @processor = processor
      @parent_scope = parent_scope
    end

    def make_call(self_type, call)
      scope = MethodScope.new(@processor, @expressions, @parent_scope, self_type)
      @args.assign_arguments_to_scope(call, scope)
      scope.process
    end

    def check_args(args)
      @args.check_call(args)
      # TODO: move this logic into check_call, we don't need two different methods for this
    end

    def check_call(call)
      # overridden in subclasses
    end

    def resolve_for_scope(scope, self_type, truthy, receiver_sexp, call)
      # TODO
    end

    def arg_count
      @args.count - 1
    end

    def inspect
      "#<#{self.class.name} @name=#{@name.inspect}>"
    end
  end
end