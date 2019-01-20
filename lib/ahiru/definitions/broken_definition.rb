module Ahiru
  class BrokenDefinition
    def self.new
      @_broken_definition_instance ||= super
    end

    def add_instance_method(*)
    end

    def monkey_patch_expressions(*)
    end

    def get_method(name, *)
      BrokenMethodDefinition.new(name)
    end

    def get_instance_method(name, *)
      BrokenMethodDefinition.new(name)
    end

    class BrokenMethodDefinition < MethodDefinition
      def initialize(name)
        super(name, s(:args), [], nil, nil)
      end

      def make_call(*)
        BrokenDefinition.new
      end

      def check_call_with_args(*)
      end
    end
  end
end