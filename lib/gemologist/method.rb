module Gemologist
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
      "#{name}(#{args_to_s}) #{block ? "#{block.to_s} " : ''}-> #{return_type.to_s}"
    end

    def dup
      Method.new(scope, name, return_type, pargs.map(&:dup), kwargs.transform_values(&:dup), block.dup, free_types)
    end
  end
end