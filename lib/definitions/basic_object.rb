require 'gemologist/definition'

Geomologist::Definition.add_class_definition(BasicObject) do
  add_method_definition :!, Bool
  add_method_definition :!=, Bool, Any
  add_method_definition :==, Bool, Any
  add_method_definition :equal?, Bool, Any

  add_method_definition :instance_exec, Self # TODO: takes block
  add_method_definition :instance_eval, Self
  add_method_definition :instance_eval, Self, T(String)
  add_method_definition :instance_eval, Self, T(String), T(String)
  add_method_definition :instance_eval, Self, T(String), T(String), T(Integer)

  add_method_definition :send, Any, T(String) | T(Symbol) # TODO: Variadic... with block and kwargs and all
  add_method_definition :__send__, Any, T(String) | T(Symbol)

  add_method_definition :method_missing, Any, T(Symbol) # TODO: variadic

  add_method_definition :__id__, T(Integer)
  add_method_definition :object_id, T(Integer)

  add_method_definition :singleton_method_added, Nil, T(Symbol)
  add_method_definition :singleton_method_removed, Nil, T(Symbol)
  add_method_definition :singleton_method_undefined, Nil, T(Symbol)

  add_class_method_definition :new, Self
end