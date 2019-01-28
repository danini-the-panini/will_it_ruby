module Ahiru
  class StandardLibrary
    def initialize_nil_class(d)
      d.def_instance_method(:!, s(:args)) { v_true }

      d.def_instance_method(:nil?, s(:args)) do
        v_true
      end

      d.def_instance_method(:to_s, s(:args)) do
        object_class.get_constant(:String).create_instance(value: '')
      end
    end
  end
end