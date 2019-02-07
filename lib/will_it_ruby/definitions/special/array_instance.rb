module WillItRuby
  class ArrayInstance < ClassInstance
    attr_reader :element_type

    def initialize(class_definition, label: nil, value: nil, element_type: nil)
      super(class_definition, label: label, value: value)
      if element_type.nil?
        update_element_type
      else
        @element_type = element_type
      end
    end

    def element_type_known?
      !@element_type.nil?
    end

    def update_element_type
      if value_known?
        @element_type =
          if value.size > 0
            Maybe::Object.from_possibilities(*value)
          else
            v_nil
          end
      end
    end

    def add_element_type(v)
      if @element_type.nil?
        @element_type = v
      else
        @element_type |= v
      end
    end

    def to_s
      if value_known?
        "[#{value.map(&:to_s_simple).join(', ')}]:#{@class_definition}"
      else
        "[#{element_type}]"
      end
    end
  end
end
