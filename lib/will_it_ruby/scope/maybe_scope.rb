module WillItRuby
  class MaybeScope < Scope
    include Returnable
    include Yieldable

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

    def block
      @parent.block
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

    def process_ivar_expression(name)
      q get_ivar(name)
    end

    def process_iasgn_expression(name, value)
      set_ivar(name, q( process_expression(value) ))
    end
  end
end