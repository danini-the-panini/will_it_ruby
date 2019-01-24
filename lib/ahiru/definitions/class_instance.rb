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
  end
end