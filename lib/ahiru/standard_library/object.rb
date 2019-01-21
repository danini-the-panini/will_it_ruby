module Ahiru
  class StandardLibrary
    def initialize_object
      @object_class.tap do |d|
        d.def_instance_method(:===, s(:args, :other)) do
          v_bool # TODO: need to do crazy stuff here for type checking
        end
        d.def_instance_method(:=~, s(:args, :other)) do
          v_nil
        end
        d.def_instance_method(:eql?, s(:args, :other)) do |other|
          other == self ? v_true : v_bool
        end

        d.def_instance_method(:class, s(:args)) do
          class_definition
        end
        d.def_instance_method(:singleton_class, s(:args)) do
          singleton_class_definition
        end
      end
    end
  end
end