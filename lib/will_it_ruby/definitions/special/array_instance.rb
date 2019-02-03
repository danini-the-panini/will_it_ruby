module WillItRuby
  class ArrayInstance < ClassInstance
    attr_reader :element_type

    def initialize(class_definition, label: nil, value: nil, element_type: nil)
      super(class_definition, label: label, value: value)
      @element_type = element_type || v_nil
    end
  end
end