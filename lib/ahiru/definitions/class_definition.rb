module Ahiru
  class ClassDefinition
    attr_reader :name, :singleton_class_definition, :super_type

    def initialize(name, super_type, parent_scope)
      @name = name
      @scopes = []
      @parent_scope = parent_scope
      @super_type = super_type
      @instance_methods = {}
      @class_methods = {
        new: NewMethodDefinition.new(self)
      }
      @constants = {}
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
      @class_methods[name] || @super_type&.get_method(name)
    end

    def get_instance_method(name)
      @instance_methods[name] || @super_type&.get_instance_method(name)
    end

    def create_instance
      ClassInstance.new(self)
    end

    def to_s
      name
    end

    def class_definition
      @parent_scope.processor.object_class.get_constant(:Class)
    end

    def add_constant(name, value)
      @constants[name] = value
    end

    def get_constant(name)
      @constants[name]
    end
  end
end