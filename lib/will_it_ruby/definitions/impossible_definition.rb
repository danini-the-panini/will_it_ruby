module WillItRuby
  class ImpossibleDefinition < BrokenDefinition
    def get_method(name, *)
      nil
    end

    def to_s
      "!Impossible!"
    end
  end
end