module WillItRuby
  class ArrayClassDefinition < ClassDefinition
    def create_instance(**options)
      ArrayInstance.new(self, **options)
    end
  end
end