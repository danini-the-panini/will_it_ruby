module Ahiru
  class MainScope < Scope
    def initialize(processor, expressions)
      super(processor, expressions, nil)

      @classes = {} # TODO: replace with actual constants with constant-lookup logic
    end

    def register_issue(line, message)
      processor.register_issue Issue.new('(main)', line, message)
    end

    def find_or_create_class(name, super_exp, expressions, scope)
      klass = @classes[name] || create_class(name, super_exp, scope)
      # TODO: check if super_exp matches
      klass.monkey_patch_expressions(expressions)
    end

    def create_class(name, super_exp, scope)
      super_type = nil # TODO
      @classes[name] = ClassDefinition.new(name, super_type, scope)
    end

    def process_const_expression(name)
      @classes[name]
    end
  end
end