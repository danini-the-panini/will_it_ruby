module Gemologist
  T_Hash.define do
    m :<, T_Hash => T_Bool
    m :<=, T_Hash => T_Bool
    m :==, T_Hash => T_Bool
    m :>, T_Hash => T_Bool
    m :>=, T_Hash => T_Bool

    m :[], K => V | T_Nil
    m :[]=, [K, V] => V

    m :any?, o(T_Any) => T_Bool
    m :any?, T_Bool do
      { [o(K), o(V)] => T_Bool }
    end

    m :assoc, [K | V] => T_Array[K | T_Array[V]] | T_Nil

    m :clear, t_self
    
    m :compact, T_Hash[K, V]
    m :compact!, T_Hash[K, V] | T_Nil

    m :compare_by_identity, t_self
    m :compare_by_identity?, T_Bool

    m :default, o(K) => V | T_Nil
    m :default=, V => V

    m :default_proc, T_Proc[V]
    m :default_proc=, T_Proc[V] => T_Proc[V]

    m :delete, K => V | T_Nil
    m :delete, K => V | T do
      { o(K) => T }
    end

    m :delete_if, t_self do
      { [o(K), o(V)] => T_Bool }
    end
    m :delete_if, T_Enumerator[T_Array[K | V]]

    m :dig, [K, v(T)] => T_Any

    m :each, t_self do
      { [o(K), o(V)] => T_Any }
    end
    m :each_pair, t_self do
      { [o(K), o(V)] => T_Any}
    end
    m :each, T_Enumerator[T_Array[K | V]]
    m :each_pair, T_Enumerator[T_Array[K | V]]

    m :each_key, t_self do
      { o(K) => T_Any }
    end
    m :each_key, T_Enumerator[K]

    m :each_value, t_self do
      { o(V) => T_Any }
    end
    m :each_value, T_Enumerator[V]

    m :empty?, T_Bool

    m :fetch, [K, o(T)] => V | T
    m :fetch, K => V | T do
      { o(K) => T }
    end

    m :fetch_values, [K, v(K)] => T_Array[V]
    m :fetch_values, [K, v(K)] => T_Array[V | T] do
      { o(K) => T }
    end

    m :flatten, o(T_Integer) => T_Array

    m :has_key?, K => T_Bool
    m :include?, K => T_Bool
    m :key?, K => T_Bool
    m :member?, K => T_Bool

    m :has_value?, V => T_Bool

    m :to_s, T_String
    m :inspect, T_String

    m :invert, T_Hash[V, K]

    m :keep_if, t_self do
      { [o(K), o(V)] => T_Bool }
    end
    m :keep_if, T_Enumerator[T_Array[K | V]]

    m :key, V => K

    m :keys, T_Array[K]

    m :length, T_Integer

    m :merge, T_Hash[A, B] => T_Hash[A | K, B | V]
    m :merge, T_Hash[A, B] => T_Hash[A | K, B | V | C] do
      { [o(A | K), o(V), o(B)] => C }
    end
    m :update, T_Hash[A, B] => T_Hash[A | K, B | V]
    m :update, T_Hash[A, B] => T_Hash[A | K, B | V | C] do
      { [o(A | K), o(V), o(B)] => C }
    end
    m :merge!, T_Hash[K, V] => t_self
    m :merge!, T_Hash[K, V] => t_self do
      { [o(K), o(V), o(V)] => V }
    end

    m :rassoc, T_Array[K | V] | T_Nil

    m :rehash, t_self

    m :reject, T_Hash[K, V] do
      { [o(K), o(V)] => T_Bool }
    end
    m :reject, T_Enumerator[T_Array[K | V]]
    m :reject!, T_Hash[K, V] | T_Nil do
      { [o(K), o(V)] => T_Bool }
    end
    m :reject!, T_Enumerator[T_Array[K | V]]

    m :replace, T_Hash[K, V] => t_self

    m :select, T_Hash[K, V] do
      { [o(K), o(V)] => T_Bool }
    end
    m :select, T_Enumerator[T_Array[K | V]]
    m :select!, T_Hash[K, V] | T_Nil do
      { [o(K), o(V)] => T_Bool }
    end
    m :select!, T_Enumerator[T_Array[K | V]]

    m :shift, T_Array[K | V] | V

    m :size, T_Integer

    m :store, [K, V] => V

    m :to_a, T_Array[T_Array[K | V]]
    
    m :to_h, T_Hash[K, V]

    m :to_hash, t_self

    m :to_proc, T_Proc[V]

    m :transform_keys, T_Hash[T, V] do
      { o(K) => T }
    end
    m :transform_keys, T_Enumerator[K]
    m :transform_keys!, T_Hash[T, V] do
      { o(K) => T }
    end
    m :transform_keys!, T_Enumerator[K]

    m :transform_values, T_Hash[K, T] do
      { o(V) => T }
    end
    m :transform_values, T_Enumerator[V]
    m :transform_values!, T_Hash[K, T] do
      { o(V) => T }
    end
    m :transform_values!, T_Enumerator[V]

    m :value?, V => T_Bool

    m :values, T_Array[V]

    m :values_at, [K, v(K)] => T_Array[V | T_Nil]
  end

  C_Hash.define do
    m :[], v(T) => T_Hash[T, T]
    m :[], T_Array[T] => T_Hash[T, T]
    m :[], T_Any => T_Hash

    m :new, T_Hash[T_Any, T_Any]
    m :new, V => T_Hash[T_Any, V]
    m :new, T_Hash[T_Any, V] do
      { [o(T_Hash[T_Any, V]), o(T_Any)] => V }
    end

    m :try_convert, T_Any => T_Hash
  end
end