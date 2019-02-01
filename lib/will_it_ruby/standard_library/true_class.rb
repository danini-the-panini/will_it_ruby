module WillItRuby
  class StandardLibrary
    def initialize_true_class(d)
      d.def_instance_method(:&, s(:args, :other)) do |other|
        if other.definitely_truthy?
          v_true
        elsif other.definitely_falsey?
          v_false
        else
          v_bool
        end
      end

      d.def_instance_method(:|, s(:args, :other)) do |other|
        v_true
      end
    end
  end
end