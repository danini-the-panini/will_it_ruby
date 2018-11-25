require 'gemologist/definition'

module Gemologist
  Definition.add_class_definition(Array, T) do
    add_class_method_definition :[], +G => T(Array, G)
    add_class_method_definition :new, [!T(Integer), !G] => T(Array, G)
    add_class_method_definition :new, T(Array, G) => T(Array, G)
    add_class_method_definition :new, { T(Integer) => T(Array, G) }, !T(Integer) => G
    add_class_method_definition :try_convert, Any => T(Array) | Nil

    add_method_definition :&, T(Array, G | T) => T(Array, T) # TODO: do an intersection of types?
    add_method_definition :|, T(Array, G) => T(Array, T | G)
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
    add_method_definition :bsearch_index, T(Integer) | Nil, T => Bool

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

    add_method_definition :delete_if, Self, T => Bool
    add_method_definition :delete_if, T(Enumerator, T)

    add_method_definition :dig, [T(Integer), +Any] => Any

    add_method_definition :drop, T(Integer) => T(Array, T)

    add_method_definition :drop_while, T(Array, T), T => Bool
    add_method_definition :drop_while, T(Enumerator, T)

    add_method_definition :each, Self, T => Any
    add_method_definition :each, T(Enumerator, T)

    add_method_definition :each_index, Self, Integer => Any
    add_method_definition :each_index, T(Enumerator, Integer)

    add_method_definition :empty?, Bool

    add_method_definition :eql?, T(Array) => Bool
    
    add_method_definition :fetch, T(Integer) => T
    add_method_definition :fetch, [T(Integer), D] => T | D
    add_method_definition :fetch, { T(Integer) => T | B }, !T(Integer) => B

    add_method_definition :fill, [T, !T(Integer), !T(Integer)] => Self
    add_method_definition :fill, [T, T(Range, Integer)] => Self
    add_method_definition :fill, { [!T(Integer), !T(Integer)] => Self }, !T(Integer) => T
    add_method_definition :fill, { T(Range, Integer) => Self }, !T(Integer) => T

    add_method_definition :find_index, T => T(Integer) | Nil
    add_method_definition :find_index, T(Integer) | Nil, !T => Bool
    add_method_definition :find_index, T(Enumerator, T)
    add_method_definition :index, T => T(Integer) | Nil
    add_method_definition :index, T(Integer) | Nil, !T => Bool
    add_method_definition :index, T(Enumerator, T)

    add_method_definition :first, T | Nil
    add_method_definition :first, T(Integer) => T(Array, T)

    add_method_definition :flatten, !T(Integer) => T(Array)
    add_method_definition :flatten!, !T(Integer) => T(Array) || Nil

    add_method_definition :frozen?, Bool

    add_method_definition :hash, T(Integer)

    add_method_definition :include?, T => Bool

    add_method_definition :initialize_copy, T(Array, T) => Self
    add_method_definition :replace, T(Array, T) => Self

    add_method_definition :insert, [T(Integer), T, +T] => Self

    add_method_definition :inspect, T(String)
    add_method_definition :to_s, T(String)

    add_method_definition :join, !T(String) => T(String)

    add_method_definition :keep_if, T(Array, T), !T => Bool
    add_method_definition :keeo_if, T(Enumerator, T)

    add_method_definition :last, T | Nil
    add_method_definition :last, T(Integer) => T(Array, T)

    add_method_definition :length, T(Integer)

    add_method_definition :max, !T(Integer) => T
    add_method_definition :max, { !T(Integer) => T }, [!T, !T] => (T(Integer) | Nil)

    add_method_definition :min, !T(Integer) => T
    add_method_definition :min, { !T(Integer) => T }, [!T, !T] => (T(Integer) | Nil)

    add_method_definition :pack, [T(String), buffer: !T(String)] => T(String)

    add_method_definition :permutation, { [!T(Integer)] => T(Array, T(Array, T)) }, !T(Array, T) => Any
    add_method_definition :permutation, [!T(Integer)] => T(Enumerator, T(Array, T))

    add_method_definition :pop, T | Nil
    add_method_definition :pop, T(Integer) => T(Array, T)

    add_method_definition :product, [T(Array, A), +T(Array, B)] => T(Array, T | A | B)
    add_method_definition :product, { [T(Array, A), +T(Array, B)] => Self }, !T(Array, T | A | B) => Any

    add_method_definition :push, [T, +T] => Self

    add_method_definition :rassoc, Any => T # TODO: only works with arrays of arrays

    add_method_definition :reject, T(Array, T), !T => Bool
    add_method_definition :reject, T(Enumerator, T)
    add_method_definition :reject!, !T(Array, T), !T => Bool
    add_method_definition :reject!, T(Enumerator, T)

    add_method_definition :repeated_combination, { T(Integer) => Self }, !T(Array, T) => Any 
    add_method_definition :repeated_combination, T(Integer) => T(Enumerator, T)

    add_method_definition :repeated_permutation, { T(Integer) => Self }, !T(Array, T) => Any 
    add_method_definition :repeated_permutation, T(Integer) => T(Enumerator, T)

    add_method_definition :reverse, T(Array, T)
    add_method_definition :reverse!, T(Array, T)

    add_method_definition :reverse_each, Self, !T => Any
    add_method_definition :reverse_each, T(Enumerator, T)

    add_method_definition :rindex, T => T(Integer) | Nil
    add_method_definition :rindex, T(Integer) | Nil, !T => Bool
    add_method_definition :rindex, T(Enumerator, T)

    add_method_definition :rotate, !T(Integer) => T(Array, T)
    add_method_definition :rotate!, !T(Integer) => T(Array, T)

    add_method_definition :sample, [random: !Any] => T
    add_method_definition :sample, [T(Integer), random: !Any] => T(Array, T)

    add_method_definition :select, T(Array, T), !T => Bool
    add_method_definition :select, T(Enumerator, T)
    add_method_definition :select!, !T(Array, T), !T => Bool
    add_method_definition :select!, T(Enumerator, T)

    add_method_definition :shelljoin, T(String)

    add_method_definition :shift, T | Nil
    add_method_definition :shift, T(Integer) => T(Array, T)

    add_method_definition :shuffle, [random: !Any] => T(Array, T)
    add_method_definition :shuffle!, [random: !Any] => T(Array, T)

    add_method_definition :size, T(Integer)

    add_method_definition :slice, T(Integer) => T | Nil
    add_method_definition :slice, [T(Integer), T(Integer)] => T(Array, T) | Nil
    add_method_definition :slice, [T(Range, Integer)] => T(Array, T) | Nil
    add_method_definition :slice!, T(Integer) => T | Nil
    add_method_definition :slice!, [T(Integer), T(Integer)] => T(Array, T) | Nil
    add_method_definition :slice!, [T(Range, Integer)] => T(Array, T) | Nil

    add_method_definition :sort, T(Array, T)
    add_method_definition :sort, T(Array, T), [!T, !T] => (T(Integer) | Nil)
    add_method_definition :sort!, T(Array, T)
    add_method_definition :sort!, T(Array, T), [!T, !T] => (T(Integer) | Nil)

    add_method_definition :sort_by!, T(Array, T), !T => Any
    add_method_definition :sort_by!, T(Enumerator, T)

    add_method_definition :sum, !T(T) => T(T)
    add_method_definition :sum, { !T(T) => T(T) }, !T => T

    add_method_definition :take, T(Integer) => T(Array, T)

    add_method_definition :take_while, T(Array, T), !T => Bool
    add_method_definition :take_while, T(Enumerator, T)

    add_method_definition :to_a, Self
    add_method_definition :to_ary, T(Array, T)

    add_method_definition :to_h, T(Hash)

    add_method_definition :transpose, T(Array, T)

    add_method_definition :uniq, T(Array, T)
    add_method_definition :uniq, T(Array, T), !T => Any

    add_method_definition :uniq!, T(Array, T) | Nil
    add_method_definition :uniq!, T(Array, T) | Nil, !T => Any

    add_method_definition :unshift, [T, +T] => Self
    add_method_definition :prepend, [T, +T] => Self

    add_method_definition :values_at, [T(Integer) | T(Range, Integer), +(T(Integer) | T(Range, Integer))] => T(Array, T)
    add_method_definition :zip, [T(Array, A), T(Array, B)] => T(Array, T(Array, T | A | B))
    add_method_definition :zip, [T(Array, A), T(Array, B)] => Nil, T(Array, T | A | B) => Any
  end
end