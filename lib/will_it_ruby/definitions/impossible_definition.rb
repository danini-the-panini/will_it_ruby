module WillItRuby
  class ImpossibleDefinition < BrokenDefinition
    def get_method(name, *)
      nil
    end

    def has_method?(name)
      false
    end

    def to_s
      "!Impossible!"
    end
  end
end