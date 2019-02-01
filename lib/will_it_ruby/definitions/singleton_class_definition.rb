module WillItRuby
  class SingletonClassDefinition < ClassDefinition
    def initialize(name, super_type, processor, label: nil, value: nil)
      super(name, super_type, nil, processor)
      @label = label
      @value = value
    end

    def create_instance(*)
      @_instance ||= ClassInstance.new(self, label: @label, value: @value)
    end
  end
end