module Ahiru
  class SingletonClassDefinition < ClassDefinition
    def create_instance
      @_instance ||= ClassInstance.new(self)
    end
  end
end