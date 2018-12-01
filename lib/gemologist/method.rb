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
      "#{name}(#{args_to_s}) #{block&.to_s || ' '}-> #{return_type.to_s}"
    end
  end
end