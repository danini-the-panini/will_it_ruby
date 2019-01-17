module Ahiru
  class MethodScope < BlockScope
    def initialize(world, t_self, parent_scope = nil, ceiling_scope = nil)
      super(world, t_self, parent_scope, ceiling_scope, self)
      @return_types = []
    end

    def process_return_from_child_scope(type)
      @return_types << type
    end

    def return_type
      @return_types.reduce(@last_expression) { |a,b| a | b }
    end

    def process_yield_expression(*args)
      arg_types = args.map { |a| process_expression(a) }
      # TODO: parse kwargs, optional, etc
      if @block
        @block = Block.new(@block.return_type, @block.pargs.map(&:type).zip(arg_types).map { |a,b| a | b }.map { |a| Callable::Argument.new(a) })
      else
        @block = Block.new(Duck.new(free: true), arg_types.map { |a| Callable::Argument.new(a) })
      end
      @block.return_type
    end

    def block
      @block
    end
  end
end