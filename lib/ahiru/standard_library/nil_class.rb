module Ahiru
  class StandardLibrary
    def initialize_nil_class(d)
      d.def_instance_method(:!, s(:args), resolve_for_scope: -> (scope, truthy, receiver_sexp, *) {
        Quantum::Resolver.new(scope, receiver_sexp, !truthy).process
      }) do
        v_true
      end

      d.def_instance_method(:nil?, s(:args), resolve_for_scope: -> (scope, truthy, *) {
        new_value = truthy ? nil : ImpossibleDefinition.new
        scope.add_override(self, new_value)
      }) do
        v_true
      end

      d.def_instance_method(:to_s, s(:args)) do
        object_class.get_constant(:String).create_instance(value: '')
      end
    end
  end
end