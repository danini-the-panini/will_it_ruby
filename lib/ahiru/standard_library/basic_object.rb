module Ahiru
  class StandardLibrary
    def install_basic_object
      @basic_object_class.tap do |d|
        d.add_instance_method :initialize, BuiltInMethodDefinition.new(:!, s(:args)) {}

        d.add_instance_method :!, BuiltInMethodDefinition.new(:!, s(:args)) { v_false }

        d.add_instance_method :!=, BuiltInMethodDefinition.new(:!=, s(:args, :other)) { |other|
          other == self ? v_false : v_bool
        }

        d.add_instance_method :==, BuiltInMethodDefinition.new(:==, s(:args, :other)) { |other|
          other == self ? v_true : v_bool
        }

        d.add_instance_method :equal?, BuiltInMethodDefinition.new(:equal?, s(:args, :other)) { |other|
          other == self ? v_true : v_bool
        }
      end
    end
  end
end