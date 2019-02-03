module WillItRuby
  module InstanceVariables
    def ivar_hash
      @instance_variables ||= {}
    end

    def get_ivar(name)
      ivar_hash[name] || v_nil
    end

    def set_ivar(name, value)
      ivar_hash[name] = value
    end
  end
end