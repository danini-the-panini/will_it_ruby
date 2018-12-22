module Ahiru
  class MainScope < Scope
    def initialize(world)
      super(world, T_Object)
    end

    def define_method(method)
      T_Object.add_method_definition(method)
      C_Object.add_method_definition(method)
    end

    def declare_constant(name, value)
      C_Object.add_constant(name, value)
    end
  end
end