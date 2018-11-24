require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Array, T) do
  add_class_method_definition :[], +G => T(Array, G)
  add_class_method_definition :new, [!T(Integer), !G] => T(Array, G)
  add_class_method_definition :new, T(Array, G) => T(Array, G)
  add_class_method_definition :new, { T(Integer) => T(Array, G) }, !T(Integer) => G
  add_class_method_definition :try_convert, Any => T(Array) | Nil

  add_method_definition :&, T(Array, G | T) => T(Array, T) # TODO: do an intersection of types?
  add_method_definition :*, T(Integer) => Self
  add_method_definition :*, T(String) => T(String)
  add_method_definition :+, T(Array, G) => T(Array, G | T)
  add_method_definition :-, T(Array, G | T) => T(Array, T)
  add_method_definition :<<, T => Self
  add_method_definition :<=>, T(Array) => T(Integer) | Nil
  add_method_definition :==, T(Array) => Bool

  add_method_definition :[], T(Integer) => T | Nil
  add_method_definition :[], [T(Integer), T(Integer)] => T(Array, T) | Nil
  add_method_definition :[], [T(Range, Integer)] => T(Array, T) | Nil
  add_method_definition :slice, T(Integer) => T | Nil
  add_method_definition :slice, [T(Integer), T(Integer)] => T(Array, T) | Nil
  add_method_definition :slice, [T(Range, Integer)] => T(Array, T) | Nil
  
  add_method_definition :[]=, [T(Integer), T] => T
  add_method_definition :[]=, [T(Integer), T(Integer), T | T(Array, T) | nil] => T | T(Array, T) | nil
  add_method_definition :[]=, [T(Range, Integer), T | T(Array, T) | nil] => T | T(Array, T) | nil

  add_method_definition :abbrev, !Pattern => T(Hash, String, String) # TODO: only works on arrays of strings?

  add_method_definition :any?, Bool
  add_method_definition :any?, Any => Bool
  add_method_definition :any?, Bool, T => Bool

  add_method_definition :append, +T => Self

  add_method_definition :assoc, Any => T # TODO: only works with arrays of arrays

  add_method_definition :at, T(Integer) => T | Nil

  add_method_definition :bsearch, T | Nil, T => Bool
  add_method_definition :bsearch_index , T(Integer) | Nil, T => Bool

  add_method_definition :clear, Self

  add_method_definition :collect, T(Array, G), T => G
  add_method_definition :collect, T(Enumerator, T)
  add_method_definition :collect!, Self, T => T
  add_method_definition :collect!, T(Enumerator, T)
  add_method_definition :map, T(Array, G), T => G
  add_method_definition :map, T(Enumerator, T)
  add_method_definition :map!, Self, T => T
  add_method_definition :map!, T(Enumerator, T)

  add_method_definition :combination, T(Integer) => T(Enumerator, T(Array, T))
  add_method_definition :combination, Self, T(Array, T) => Any

  add_method_definition :compact, T(Array, T) # TODO: allow for "T - Nil" type
  add_method_definition :compact!, Self | Nil

  add_method_definition :concat, [T(Array, A), +T(Array, B)] => T(Array, T | A | B) # TODO: somehow be able to union variadic types?

  add_method_definition :count, !T => T(Integer)
  add_method_definition :count, T(Integer), T => Bool

  add_method_definition :cycle, !T(Integer) => T(Enumerator, T)
  add_method_definition :cycle, { !T(Integer) => Nil }, !T => Any

  add_method_definition :dclone, Self

  add_method_definition :delete, T => T | Nil
  add_method_definition :delete, { T => T | B }, [] => B

  add_method_definition :delete_at, T(Integer) => T | Nil

  add_method_definition :delete_if Self, T => Bool
  add_method_definition :delete_if T(Enumerator, T)

  add_method_definition :dig, [T(Integer), +Any] => Any

  add_method_definition :drop, T(Integer) => T(Array, T)

  add_method_definition :drop_while , T(Array, T), T => Bool
  add_method_definition :drop_while , T(Enumerator, T)

  add_method_definition :each , Selft, T => Any
  add_method_definition :each , T(Enumerator, T)

  add_method_definition :each_index , Selft, Integer => Any
  add_method_definition :each_index , T(Enumerator, Integer)

  add_method_definition :empty?, Bool

  add_method_definition :eql?, T(Array) => Bool
  
  add_method_definition :fetch, T(Integer) => T
  add_method_definition :fetch, [T(Integer), D] => T | D
  add_method_definition :fetch, { T(Integer) => T | B }, T(Integer) => B
end