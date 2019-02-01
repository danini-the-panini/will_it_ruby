module WillItRuby
  class MaybeScope < Scope
    include Returnable

    def initialize(processor, expressions, parent)
      super
      # TODO: make some kind of quantum clone of self_type, for ivar possibilities
      @self_type = parent.self_type
    end

    def process
      super do
        did_return?
      end
    end

    def local_variable_get(name)
      q( @local_variables[name] || @parent.local_variable_get(name) )
    end

    def local_variable_defined?(name)
      @local_variables.key?(name) || @parent.local_variable_defined?(name)
    end

    def defined_local_variables
      @parent.defined_local_variables | @local_variables.keys
    end
  end
end