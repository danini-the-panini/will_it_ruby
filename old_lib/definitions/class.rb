require 'gemologist/definition'

module Gemologist
  Definition.add_class_definition(Class, C) do
    add_class_method_definition :new, !T(Class, Y) => T(Class, T)
    add_class_method_definition :new, { !T(Class, Y) => T(Class, T) }, !T(Class) => Any

    add_method_definition :allocate, C
    add_method_definition :json_creatable?, Bool
    add_method_definition :new, +Any => C # TODO: must match "initialize" in this special case
    add_method_definition :superclass, T | Nil
    add_method_definition :inherited, T(Class, C) => Nil
  end
end