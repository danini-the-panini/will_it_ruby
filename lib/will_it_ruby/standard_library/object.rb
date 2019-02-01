module WillItRuby
  class StandardLibrary
    def initialize_object
      @object_class.tap do |d|
        d.def_alias_instance_method(:===, :==)

        d.def_instance_method(:=~, s(:args, :other)) do
          v_nil
        end

        d.def_instance_method(:eql?, s(:args, :other)) do |other|
          other == self ? v_true : v_bool
        end

        d.def_instance_method(:is_a?, s(:args, :other), precheck: -> (other) {
          if !other.is_a?(ClassDefinition) # TODO: also module definition
            "class or module required"
          end
        }, resolve_for_scope: -> (scope, truthy, receiver_sexp, other, *) {
          new_value = truthy == self.check_is_a(other) ? nil : ImpossibleDefinition.new
          scope.add_override(self, new_value)
        }) do |other|
          case self.check_is_a(other)
          when true
            v_true
          when false
            v_false
          else
            v_bool
          end
        end
        d.def_alias_instance_method(:kind_of?, :is_a?)

        d.def_instance_method(:nil?, s(:args), resolve_for_scope: -> (scope, truthy, *) {
          new_value = truthy ? ImpossibleDefinition.new : nil
          scope.add_override(self, new_value)
        }) do
          v_false
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