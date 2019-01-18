module Ahiru
  class ClassScope < Scope
    def initialize(processor, expressions, parent, class_def)
      super(processor, expressions, parent)
      @class_def = class_def
    end

    def process_defn_expression(name, args, *expressions)
      @class_def.add_instance_method(name, MethodDefinition.new(name, self, args, expressions, @processor, self))
    end
  end
end