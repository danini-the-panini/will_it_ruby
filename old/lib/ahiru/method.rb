module Ahiru
  class Method < Callable
    attr_accessor :scope, :name

    def initialize(scope, name, *args)
      super(*args)
      @scope = scope
      @name = name
    end

    def <=(other)
      other.name == name && super
    end

    def to_s
      "#{name}#{super}"
    end

    def dup
      Method.new(scope, name, return_type, pargs.map(&:dup), kwargs.transform_values(&:dup), block.dup, free_types)
    end

    def self.from_callable(c, scope=Duck.new, name="UNKNOWN")
      new(scope, name, c.return_type, c.pargs, c.kwargs, c.block, c.free_types)
    end

    def to_method
      self
    end
  end
end