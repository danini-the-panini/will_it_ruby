module WillItRuby
  class ClassScope < Scope
    def initialize(processor, expressions, parent, class_def)
      super(processor, expressions, parent)
      @class_def = @self_type = class_def
    end

    def process_defn_expression(name, args, *expressions)
      @class_def.add_instance_method(name, MethodDefinition.new(name, args, expressions, @processor, self))
    end

    def ivar_hash
      self_type.ivar_hash
    end
  end
end