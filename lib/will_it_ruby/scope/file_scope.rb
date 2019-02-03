module WillItRuby
  class FileScope < Scope
    def initialize(processor, expressions, source_file)
      super(processor, expressions)
      @source_file = source_file
    end

    def register_issue(line, message)
      processor.register_issue Issue.new(@source_file.path, line, message)
    end

    def self_type
      @parent.self_type
    end

    # TODO: move this, as classes are not only defined on the file-level scope
    def process_class_expression(name, super_exp, *expressions)
      case name
      when Symbol
        super_type = super_exp ? process_expression(super_exp) : nil

        error = check_create_class(name, super_type)

        if error
          register_issue @current_sexp.line, error
        else
          find_or_create_class(name, super_type, expressions, self)
        end
      else
        # TODO: class names like A::B::C
      end
    end

    def process_defn_expression(name, args, *expressions)
      object_class.add_instance_method(name, MethodDefinition.new(name, args, expressions, @processor, self))
    end

    def process_defn_expression(name, args, *expressions)
      object_class.add_instance_method(name, MethodDefinition.new(name, args, expressions, @processor, self))
    end

    def ivar_hash
      self_type.ivar_hash
    end

    private

    def check_create_class(name, super_type)
      return if super_type.nil?
      if !super_type.is_a?(ClassDefinition)
        return "superclass must be a Class (#{super_type.class_definition} given)"
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
  end
end