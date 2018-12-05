module Ahiru
  class ChildScope < Scope
    def local_variable_defined?(name)
      @ceiling_scope.local_variable_defined?(name)
    end

    def local_variable(name)
      @ceiling_scope.local_variable(name)
    end

    def assign_local_variable(name, value)
      @ceiling_scope.assign_local_variable(name, value)
    end
  end
end