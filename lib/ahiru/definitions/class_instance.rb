module Ahiru
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
end