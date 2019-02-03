module WillItRuby
  class StandardLibrary
    def initialize_string(d)
      d.def_instance_method(:to_s, s(:args)) do
        self
      end
    end
  end
end