module Ahiru
  class StandardLibrary
    def initialize_basic_object
      @basic_object_class.tap do |d|
        d.def_instance_method(:!, s(:args), resolve_for_scope: -> (scope, truthy, receiver_sexp, *) {
          Quantum::Resolver.new(scope, receiver_sexp, !truthy).process
        }) { v_false }

        d.def_instance_method(:!=, s(:args, :other)) do |other|
          other == self ? v_false : v_bool
        end

        d.def_instance_method(:==, s(:args, :other), resolve_for_scope: -> (scope, truthy, receiver_sexp, other, *) {
          if other.is_a?(Maybe::Object)
            true_options, false_options = other.possibilities.partition { |p|
              self.check_equality(other) != v_false
            }

            scope.add_override(other, Maybe::Object.from_possibilities(truthy ? true_options : false_options))
          end
        }) do |other|
          self.check_equality(other)
        end

        d.def_instance_method(:equal?, s(:args, :other)) do |other|
          other == self ? v_true : v_bool
        end
      end
    end
  end
end