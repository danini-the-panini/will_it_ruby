module WillItRuby
  class MainObjectInstance < ClassInstance
    def initialize(processor)
      super(processor.object_class, label: 'main')
    end
  end
end