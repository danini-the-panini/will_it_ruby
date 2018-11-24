require 'gemologist/definition'

Geomologist::Definition.add_class_definition(BasicObject) do
  add_method_definition :!, Bool
  add_method_definition :!=, Any => Bool
  add_method_definition :==, Any => Bool
  add_method_definition :equal?, Any => Bool

  add_method_definition :instance_exec, { +Any => Self }, +Any => Any # TODO: args == block args in this special case
  add_method_definition :instance_eval, [!T(String), !T(String), !T(Integer)] => Self
  add_method_definition :instance_eval, Self, Self => Any

  add_method_definition :send, [T(String) | T(Symbol), +Any] => Any
  add_method_definition :send, { [T(String) | T(Symbol), +Any] => Any }, +Any => Any
  add_method_definition :__send__, [T(String) | T(Symbol), +Any] => Any
  add_method_definition :__send__, { [T(String) | T(Symbol), +Any] => Any }, +Any => Any

  add_method_definition :method_missing, { [T(Symbol), +Any] => Any }, +Any => Any
  add_method_definition :method_missing, [T(Symbol), +Any] => Any

  add_method_definition :__id__, T(Integer)
  add_method_definition :object_id, T(Integer)

  add_method_definition :singleton_method_added, T(Symbol) => Nil
  add_method_definition :singleton_method_removed, T(Symbol) => Nil
  add_method_definition :singleton_method_undefined, T(Symbol) => Nil

  add_class_method_definition :new, Self
end