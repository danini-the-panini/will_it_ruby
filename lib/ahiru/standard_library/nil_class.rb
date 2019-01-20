module Ahiru
  class StandardLibrary
    def initialize_nil_class(d)
      d.add_instance_method :nil?, BuiltInMethodDefinition.new(:nil?, s(:args)) {
        v_true
      }
      d.add_instance_method :to_s, BuiltInMethodDefinition.new(:to_s, s(:args)) {
        object_class.get_constant(:String).create_instance
      }
    end
  end
end