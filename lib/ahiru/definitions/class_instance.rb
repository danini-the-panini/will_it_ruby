module Ahiru
  class ClassInstance
    attr_reader :class_definition, :singleton_class_definition, :label, :value
    include ProcessorDelegateMethods

    def initialize(class_definition, label: nil, value: nil)
      @class_definition = class_definition
      @label = label
      @value = value
    end

    def processor
      @class_definition.processor
    end

    def get_method(name)
      @class_definition.get_instance_method(name)
    end

    def to_s
      if @value || @label
        "#{@value&.to_s || @label}:#{@class_definition.to_s}"
      else
        "#<#{@class_definition.to_s}>"
      end
    end

    def inspect
      "#<#{self.class.name} @class_definition=#{class_definition.name.inspect} @label=#{label} @value=#{value}>"
    end

    def value_known?
      return true if @class_definition == object_class.get_constant(:NilClass)
      !@value.nil?
    end

    def check_is_a(other)
      # TODO: check included modules
      @class_definition.is_or_sublass_of?(other)
    end

    def maybe_truthy?
      definitely_truthy?
    end

    def maybe_falsey?
      definitely_falsey?
    end

    def definitely_truthy?
      !value_known? || value
    end

    def definitely_falsey?
      value_known? && !value
    end

    def resolve_truthy
      maybe_truthy? ? nil : ImpossibleDefinition.new
    end

    def resolve_falsey
      maybe_falsey? ? nil : ImpossibleDefinition.new
    end

    def for_scope(scope)
      self
    end
  end
end
