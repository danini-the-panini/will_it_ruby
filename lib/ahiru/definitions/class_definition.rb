module Ahiru
  class ClassDefinition
    attr_reader :name

    def initialize(name, super_type, parent_scope)
      @name = name
      @scopes = []
      @parent_scope = parent_scope
      @super_type = super_type
      @instance_methods = {}
      @class_methods = {
        new: BakedMethodDefinition.new(:new, s(:args), -> () { ClassInstance.new(self) })
      }
    end

    def add_instance_method(name, definition)
      @instance_methods[name] = definition
    end
    
    def monkey_patch_expressions(expressions)
      scope = ClassScope.new(@parent_scope.processor, expressions, @parent_scope, self)
      @scopes << scope
      scope.process
    end

    def get_method(name)
      @class_methods[name]
    end

    def get_instance_method(name)
      @instance_methods[name]
    end
  end
end