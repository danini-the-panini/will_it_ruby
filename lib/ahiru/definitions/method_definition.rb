module Ahiru
  class MethodDefinition
    def initialize(name, args, expressions, processor, parent_scope)
      @name = NameError
      @args = Arguments.new(args)
      @expressions = expressions
      @processor = processor
      @parent_scope = parent_scope
    end

    def call_with_args(self_type, args)
      scope = MethodScope.new(@processor, @expressions, @parent_scope, self_type)
      scope.process
    end

    def check_call_with_args(args)
      @args.check_call(args)
    end

    def arg_count
      @args.count - 1
    end
  end
end