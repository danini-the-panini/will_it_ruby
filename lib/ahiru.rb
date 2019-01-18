require "ruby_parser"

require "ahiru/version"

require "ahiru/processor"
require "ahiru/source_file"
require "ahiru/issue"

require "ahiru/scope/scope"
require "ahiru/scope/main_scope"
require "ahiru/scope/file_scope"
require "ahiru/scope/method_scope"
require "ahiru/scope/class_scope"

# TODO: put these things in the right place with the right name
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
        new: BakedMethodDefinition.new(:new, -> () { ClassInstance.new(self) })
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

  class ClassInstance
    def initialize(class_definition)
      @class_definition = class_definition
    end

    def get_method(name)
      @class_definition.get_instance_method(name)
    end

    def to_s
      "#<#{@class_definition.name}>"
    end
  end

  class MethodDefinition
    def initialize(name, self_type, args, expressions, processor, parent_scope)
      @name = name
      @self_type = self_type
      @args = args
      @expressions = expressions
      @processor = processor
      @parent_scope = parent_scope
    end

    def call_with_args(*)
      scope = MethodScope.new(@processor, @expressions, @parent_scope)
      scope.process
    end
  end

  class BakedMethodDefinition
    def initialize(name, proc)
      @name = name
      @proc = proc
    end

    def call_with_args(*)
      @proc.call
    end
  end
end