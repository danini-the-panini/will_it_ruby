module Ahiru
  class StandardLibrary
    def install_object
      @object_class.tap do |d|
        d.add_instance_method :===, BuiltInMethodDefinition.new(:===, s(:args, :other)) {
          v_bool # TODO: need to do crazy stuff here for type checking
        }
        d.add_instance_method :=~, BuiltInMethodDefinition.new(:=~, s(:args, :other)) {
          v_nil
        }
        d.add_instance_method :eql?, BuiltInMethodDefinition.new(:eql?, s(:args, :other)) { |other|
          other == self ? v_true : v_bool
        }

        d.add_instance_method :class, BuiltInMethodDefinition.new(:eql?, s(:args)) {
          class_definition
        }
        d.add_instance_method :class, BuiltInMethodDefinition.new(:eql?, s(:args)) {
          singleton_class_definition
        }
      end
    end
  end
end