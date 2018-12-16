module Ahiru
  class ClassScope < ModuleScope
    def define_method(method)
      t_self.instance_type.add_method_definition(method)
    end
  end
end