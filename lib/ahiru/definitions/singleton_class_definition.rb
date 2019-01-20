module Ahiru
  class SingletonClassDefinition < ClassDefinition
    def initialize(name, super_type, processor, label: label)
      super(name, super_type, nil, processor)
      @label = label
    end

    def create_instance
      @_instance ||= ClassInstance.new(self, label: @label)
    end
  end
end