module Ahiru
  class StandardLibrary
    def initialize_false_class(d)
      d.def_instance_method(:!, s(:args)) { v_true }

      d.def_instance_method(:&, s(:args, :other)) do |other|
        v_false
      end

      d.def_instance_method(:|, s(:args, :other)) do |other|
        if other.definitely_truthy?
          v_true
        elsif other.definitely_falsey?
          v_false
        else
          v_bool
        end
      end
    end
  end
end