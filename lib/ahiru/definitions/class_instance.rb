module Ahiru
  class ClassInstance
    attr_reader :class_definition, :singleton_class_definition
    include ProcessorDelegateMethods

    def initialize(class_definition, label: nil)
      @class_definition = class_definition
      @label = label
    end

    def processor
      @class_definition.processor
    end

    def get_method(name)
      @class_definition.get_instance_method(name)
    end

    def to_s
      if @label
        "#{@label}:#{@class_definition.to_s}" 
      else
        "#<#{@class_definition.to_s}>"
      end
    end
  end
end