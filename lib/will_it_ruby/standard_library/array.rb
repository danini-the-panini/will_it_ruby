module WillItRuby
  class StandardLibrary
    def initialize_array(d)
      d.def_instance_method(:to_a, s(:args)) do
        self
      end
    end
  end
end