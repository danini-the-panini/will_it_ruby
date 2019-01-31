module Ahiru
  class StandardLibrary
    def initialize_class(d)
      d.def_instance_method(:===, s(:args, :other), resolve_for_scope: -> (scope, truthy, receiver_sexp, other, *) {
        new_value = truthy == other.check_is_a(self) ? nil : ImpossibleDefinition.new
        scope.add_override(other, new_value)
      }) do |other|
        case other.check_is_a(self)
        when true
          v_true
        when false
          v_false
        else
          v_bool
        end
      end
    end
  end
end