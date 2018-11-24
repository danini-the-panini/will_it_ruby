require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Class, C) do
  add_class_method_definition :new, !Class(Y) => T(Class, T)
  add_class_method_definition :new, !Class(Y) => T(Class, T), !Class => Any

  add_method_definition :allocate, C
  add_method_definition :json_creatable?, Bool
  add_method_definition :new, +Any => C # TODO: must match "initialize" in this special case
  add_method_definition :superclass, T | Nil
  add_method_definition :inherited, T(Class, C) => Nil
end