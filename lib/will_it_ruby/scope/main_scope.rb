module WillItRuby
  class MainScope < Scope
    def initialize(processor, expressions)
      super(processor, expressions, nil)
      @self_type = MainObjectInstance.new(processor)
    end

    def register_issue(line, message)
      processor.register_issue Issue.new('(main)', line, message)
    end

    def check_create_class(name, super_type)
      return if super_type.nil?
      if !super_type.is_a?(ClassDefinition)
        return "superclass must be a Class (#{super_type.class_definition.to_s} given)"
      else
        klass = process_const_expression(name)
        if klass && klass.super_type != super_type
          return "superclass mismatch for class #{name}"
        end
      end
      nil
    end

    def find_or_create_class(name, super_type, expressions, scope)
      klass = process_const_expression(name) || create_class(name, super_type || @processor.object_class, scope)
      klass.monkey_patch_expressions(expressions)
    end

    def create_class(name, super_type, scope)
      @processor.object_class.add_constant(name, ClassDefinition.new(name, super_type, scope))
    end

    def process_const_expression(name)
      @processor.object_class.get_constant(name)
    end

    def process_defn_expression(name, args, *expressions)
      object_class.add_instance_method(name, MethodDefinition.new(name, args, expressions, @processor, self))
    end
  end
end