require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Class, C) do
  add_class_method_definition :new, T(Class, X) # TODO: takes a block
  add_class_method_definition :new, T(Class, X), Class(Y)

  add_method_definition :allocate, C
  add_method_definition :json_creatable?, Bool
  add_method_definition :new, C # TODO variadic function.. must match "initialize"
  add_method_definition :superclass, X | Nil
  add_method_definition :inherited, Nil, T(Class, C)
end