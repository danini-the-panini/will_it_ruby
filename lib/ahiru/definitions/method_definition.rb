module Ahiru
  class MethodDefinition
    def initialize(name, self_type, args, expressions, processor, parent_scope)
      @name = name
      @self_type = self_type
      @args = args
      @expressions = expressions
      @processor = processor
      @parent_scope = parent_scope
    end

    def call_with_args(args)
      scope = MethodScope.new(@processor, @expressions, @parent_scope)
      scope.process
    end

    def check_call_with_args(args)
      if args.count != arg_count
        return "Wrong number of arguments (given #{args.count}, expected #{arg_count})"
      end
    end

    def arg_count
      @args.count - 1
    end
  end
end