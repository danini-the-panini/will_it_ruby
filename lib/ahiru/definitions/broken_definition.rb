module Ahiru
  class BrokenDefinition
    def self.new
      @_instance ||= super
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

    def maybe_truthy?
      true
    end

    def maybe_falsey?
      true
    end

    def definitely_truthy?
      false
    end

    def definitely_falsey?
      false
    end

    def resolve_truthy(scope)
      nil
    end

    def resolve_falsey(scope)
      nil
    end

    def for_scope(scope)
      self
    end

    def to_s
      "!Broken!"
    end

    class BrokenMethodDefinition < MethodDefinition
      def initialize(name)
        super(name, s(:args), [], nil, nil)
      end

      def make_call(*)
        BrokenDefinition.new
      end

      def check_args(*)
      end

      def check_call(*)
      end
      
      def resolve_for_scope(*)
      end
    end
  end
end