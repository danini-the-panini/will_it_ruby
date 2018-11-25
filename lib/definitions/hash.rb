require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Hash, K, V) do
  add_class_method_definition :[], +T => T(Hash, T, T)
  add_class_method_definition :[], T(Array, T => T(Hash, T, T)
  add_class_method_definition :[], Any => T(Hash)

  add_class_method_definition :new, T(Hash)
  add_class_method_definition :new, V => T(Hash, K, V)
  add_class_method_definition :new, T(Hash, K, V), [!T(Hash, K, V), K] => V

  add_class_method_definition :try_convert, Any => T(Hash)

  add_method_definition :<, T(Hash) => Bool
  add_method_definition :<=, T(Hash) => Bool
  add_method_definition :==, T(Hash) => Bool
  add_method_definition :>, T(Hash) => Bool
  add_method_definition :>=, T(Hash) => Bool

  add_method_definition :[], K => V | Nil
  add_method_definition :[]=, [K, V] => V

  add_method_definition :any?, !Any => Bool
  add_method_definition :any?, Bool, [!K, !V] => Bool

  add_method_definition :assoc, [K | V] => T(Array, K | T(Array, V)) | Nil

  add_method_definition :clear, Self
  
  add_method_definition :compact, T(Hash, K, V)
  add_method_definition :compac!t, T(Hash, K, V) | Nil

  add_method_definition :compare_by_identity, Self
  add_method_definition :compare_by_identity?, Bool

  add_method_definition :default, !K => V | Nil
  add_method_definition :default=, V => V

  add_method_definition :default_proc, T(Proc, V, !T(Hash, K, V), K)
  add_method_definition :default_proc=, T(Proc, V, !T(Hash, K, V), K) => T(Proc, V, !T(Hash, K, V), K)

  add_method_definition :delete, K => V | Nil
  add_method_definition :delete, { K => V | T }, !K => T

  add_method_definition :delete_if, Self, [!K, !V] => Bool
  add_method_definition :delete_if, T(Enumerator, T(Array, K | V))

  add_method_definition :dig, [K, +T] => Any

  add_method_definition :each, Self, [!K, !V] => Any
  add_method_definition :each_pair, Self, [!K, !V] => Any
  add_method_definition :each, T(Enumerator, T(Array, K | V))
  add_method_definition :each_pair, T(Enumerator, T(Array, K | V))

  add_method_definition :each_key, Self, !K => Any
  add_method_definition :each_key, T(Enumerator, K)

  add_method_definition :each_value, Self, !V => Any
  add_method_definition :each_value, T(Enumerator, V)

  add_method_definition :empty?, Bool

  add_method_definition :fetch, [K, !T] => V | T
  add_method_definition :fetch, { K => V | T }, !K => T

  add_method_definition :fetch_values, [K, +K] => T(Array, V)
  add_method_definition :fetch_values, { [K, +K] => T(Array, V | T) }, !K => T

  add_method_definition :flatten, !T(Integer) => T(Array)

  add_method_definition :has_key?, K => Bool
  add_method_definition :include? K => Bool
  add_method_definition :key?, K => Bool
  add_method_definition :member? K => Bool

  add_method_definition :has_value?, V => Bool

  add_method_definition :to_s, T(String)
  add_method_definition :inspect, T(String)

  add_method_definition :invert, T(Hash, V, K)

  add_method_definition :keep_if, Self, [!K, !V] => Bool
  add_method_definition :keep_if, T(Enumerator, T(Array, K | V))

  add_method_definition :key, V => K

  add_method_definition :keys, T(Array, K)

  add_method_definition :length, T(Integer)

  add_method_definition :merge, T(Hash, A, B) => T(Hash, A | K, B | V)
  add_method_definition :merge, { T(Hash, A, B) => T(Hash, A | K, B | V | C) }, [!(A | K), !V, !B] => C
  add_method_definition :update, T(Hash, A, B) => T(Hash, A | K, B | V)
  add_method_definition :update, { T(Hash, A, B) => T(Hash, A | K, B | V | C) }, [!(A | K), !V, !B] => C
  add_method_definition :merge!, T(Hash, K, V) => Self
  add_method_definition :merge!, { T(Hash, K, V) => Self }, [!K, !V, !V] => V

  add_method_definition :rassoc, T(Array, K | V) | Nil

  add_method_definition :rehash, Self

  add_method_definition :reject, T(Hash, K, V), [!K, !V] => Bool
  add_method_definition :reject, T(Enumerator, T(Array, K | V))
  add_method_definition :reject!, T(Hash, K, V) | Nil, [!K, !V] => Bool
  add_method_definition :reject!, T(Enumerator, T(Array, K | V))

  add_method_definition :replace, T(Hash, K, V) => Self

  add_method_definition :select, T(Hash, K, V), [!K, !V] => Bool
  add_method_definition :select, T(Enumerator, T(Array, K | V))
  add_method_definition :select!, T(Hash, K, V) | Nil, [!K, !V] => Bool
  add_method_definition :select!, T(Enumerator, T(Array, K | V))

  add_method_definition :shift, T(Array, K | V) | V

  add_method_definition :size, T(Integer)

  add_method_definition :store, [K, V] => V

  add_method_definition :to_a, T(Array, T(Array, K | V))
  
  add_method_definition :to_h, T(Hash, K, V)

  add_method_definition :to_hash, Self

  add_method_definition :to_proc, T(Proc, V | Nil, K)

  add_method_definition :transform_keys, T(Hash, T, V), !K => T
  add_method_definition :transform_keys, T(Enumerator, K)
  add_method_definition :transform_keys!, T(Hash, T, V), !K => T
  add_method_definition :transform_keys!, T(Enumerator, K)

  add_method_definition :transform_values, T(Hash, K, T), !V => T
  add_method_definition :transform_values, T(Enumerator, V)
  add_method_definition :transform_values!, T(Hash, K, T), !V => T
  add_method_definition :transform_values!, T(Enumerator, V)

  add_method_definition :value?, V => Bool

  add_method_definition :values, T(Array, V)

  add_method_definition :values_at, [K, +K] => T(Array, V | Nil)
end