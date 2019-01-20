module Ahiru
  class NewMethodDefinition < MethodDefinition
    def initialize(class_definition)
      super(:new, s(:args), [], nil, nil)
      @class_definition = class_definition
    end

    def call_with_args(self_type, args)
      @class_definition.create_instance.tap do |new_instance|
        initialize_method.call_with_args(new_instance, args)
      end
    end

    def check_call_with_args(args)
      initialize_method.check_call_with_args(args)
    end

    def arg_count
      initialize_method.arg_count
    end

    private

    # TODO: do this until Object/BasicObject are defined
    def create_init_method
      MethodDefinition.new(:initialize, s(:args), [], @processor, @parent_scope)
    end

    def initialize_method
      @class_definition.get_instance_method(:initialize) || create_init_method
    end
  end
end