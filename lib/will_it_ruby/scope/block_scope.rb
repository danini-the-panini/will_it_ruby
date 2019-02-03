module WillItRuby
  class BlockScope < MethodScope
    def initialize(processor, expressions, parent, yielding, self_type, block=nil)
      super(processor, expressions, parent, self_type, block)
      @yielding = yielding
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

    def handle_return(processed_value)
      if maybe?
        handle_partial_return(processed_value)
      else
        @return_value = processed_value
      end
    end
  end
end