module Ahiru
  T_Array.define do
    m :&, T_Array[G] => T_Array[T] # TODO: do an intersection of types?
    m :|, T_Array[G] => T_Array[T | G]
    m :*, T_Integer => t_self
    m :*, T_String => T_String
    m :+, T_Array[G] => T_Array[G | T]
    m :-, T_Array[G | T] => t_self
    m :<<, T => t_self
    m :<=>, T_Array => T_Integer | T_Nil
    m :==, T_Array => T_Bool

    m :[], T_Integer => T | T_Nil
    m :[], [T_Integer, T_Integer] => t_self | T_Nil
    m :[], [T_Range[T_Integer]] => t_self | T_Nil
    m :slice, T_Integer => T | T_Nil
    m :slice, [T_Integer, T_Integer] => t_self | T_Nil
    m :slice, [T_Range[T_Integer]] => t_self | T_Nil
    
    m :[]=, [T_Integer, T] => T
    m :[]=, [T_Integer, T_Integer, T | t_self | T_Nil] => T | t_self | T_Nil
    m :[]=, [T_Range[T_Integer], T | t_self | T_Nil] => T | t_self | T_Nil

    m :abbrev, o(T_Pattern) => T_Hash[T_String, T_String] # TODO: only works on arrays of strings?

    m :any?, T_Bool
    m :any?, T_Any => T_Bool
    m :any?, T_Bool do
      { o(T) => T_Bool }
    end

    m :append, v(T) => t_self

    m :assoc, T_Any => T # TODO: only works with arrays of arrays

    m :at, T_Integer => T | T_Nil

    m :bsearch, T | T_Nil do
      { o(T) => T_Bool }
    end
    m :bsearch_index, T_Integer | T_Nil do 
      { o(T) => T_Bool }
    end

    m :clear, t_self

    m :collect, T_Array[G] do
      { o(T) => G }
    end
    m :collect, T_Enumerator[T]
    m :collect!, t_self do
      { o(T) => T }
    end
    m :collect!, T_Enumerator[T]
    m :map, T_Array[G] do
      { o(T) => G }
    end
    m :map, T_Enumerator[T]
    m :map!, t_self do
      { o(T) => T }
    end
    m :map!, T_Enumerator[T]

    m :combination, T_Integer => T_Enumerator[t_self]
    m :combination, t_self do
      { o(t_self) => T_Any }
    end

    m :compact, t_self # TODO: allow for "T - T_Nil" type
    m :compact!, t_self | T_Nil

    m :concat, [T_Array[A], v(T_Array[B])] => T_Array[T | A | B] # TODO: somehow be able to union variadic types?

    m :count, o(T) => T_Integer
    m :count, T_Integer do
      { o(T) => T_Bool }
    end

    m :cycle, o(T_Integer) => T_Enumerator[T]
    m :cycle, o(T_Integer) => T_Nil do
      { o(T) => T_Any }
    end

    m :dclone, t_self

    m :delete, T => T | T_Nil
    m :delete, T => T | B do
      B
    end

    m :delete_at, T_Integer => T | T_Nil

    m :delete_if, t_self do
      { o(T) => T_Bool }
    end
    m :delete_if, T_Enumerator[T]

    m :dig, [T_Integer, v(T_Any)] => T_Any

    m :drop, T_Integer => t_self

    m :drop_while, t_self do
      { o(T) => T_Bool }
    end
    m :drop_while, T_Enumerator[T]

    m :each, t_self do
      { o(T) => T_Any }
    end
    m :each, T_Enumerator[T]

    m :each_index, t_self do
      { o(T_Integer) => T_Any }
    end
    m :each_index, T_Enumerator[T_Integer]

    m :empty?, T_Bool

    m :eql?, T_Array => T_Bool
    
    m :fetch, T_Integer => T
    m :fetch, [T_Integer, D] => T | D
    m :fetch, T_Integer => T | B do
      { o(T_Integer) => B }
    end

    m :fill, [T, o(T_Integer), o(T_Integer)] => t_self
    m :fill, [T, T_Range[T_Integer]] => t_self
    m :fill, [o(T_Integer), o(T_Integer)] => t_self do
      { o(T_Integer) => T }
    end
    m :fill, T_Range[T_Integer] => t_self do
      { o(T_Integer) => T }
    end

    m :find_index, T => T_Integer | T_Nil
    m :find_index, T_Integer | T_Nil do
      { o(T) => T_Bool }
    end
    m :find_index, T_Enumerator[T]
    m :index, T => T_Integer | T_Nil
    m :index, T_Integer | T_Nil do
      { o(T) => T_Bool }
    end
    m :index, T_Enumerator[T]

    m :first, T | T_Nil
    m :first, T_Integer => t_self

    m :flatten, o(T_Integer) => T_Array
    m :flatten!, o(T_Integer) => T_Array | T_Nil

    m :frozen?, T_Bool

    m :hash, T_Integer

    m :include?, T => T_Bool

    m :initialize_copy, t_self => t_self
    m :replace, t_self => t_self

    m :insert, [T_Integer, T, v(T)] => t_self

    m :inspect, T_String
    m :to_s, T_String

    m :join, o(T_String) => T_String

    m :keep_if, t_self do
      { o(T) => T_Bool }
    end
    m :keeo_if, T_Enumerator[T]

    m :last, T | T_Nil
    m :last, T_Integer => t_self

    m :length, T_Integer

    m :max, o(T_Integer) => T
    m :max, o(T_Integer) => T do
      { [o(T), o(T)] => T_Integer | T_Nil }
    end

    m :min, o(T_Integer) => T
    m :min, o(T_Integer) => T do
      { [o(T), o(T)] => T_Integer | T_Nil }
    end

    m :pack, [T_String, buffer: o(T_String)] => T_String

    m :permutation, o(T_Integer) => T_Array[t_self] do
      { o(t_self) => T_Any }
    end
    m :permutation, o(T_Integer) => T_Enumerator[t_self]

    m :pop, T | T_Nil
    m :pop, T_Integer => t_self

    m :product, [T_Array[A], v(T_Array[B])] => T_Array[T | A | B]
    m :product, [T_Array[A], v(T_Array[B])] => t_self do
      { o(T_Array[T | A | B]) => T_Any }
    end

    m :push, [T, v(T)] => t_self

    m :rassoc, T_Any => T # TODO: only works with arrays of arrays

    m :reject, t_self do
      { o(T) => T_Bool }
    end
    m :reject, T_Enumerator[T]
    m :reject!, t_self | T_Nil do
      { o(T) => T_Bool }
    end
    m :reject!, T_Enumerator[T]

    m :repeated_combination, T_Integer => t_self do
      { o(t_self) => T_Any }
    end
    m :repeated_combination, T_Integer => T_Enumerator[T]

    m :repeated_permutation, T_Integer => t_self do
      { o(t_self) => T_Any  }
    end
    m :repeated_permutation, T_Integer => T_Enumerator[T]

    m :reverse, t_self
    m :reverse!, t_self

    m :reverse_each, t_self do
      { o(T) => T_Any }
    end
    m :reverse_each, T_Enumerator[T]

    m :rindex, T => T_Integer | T_Nil
    m :rindex, T_Integer | T_Nil do
      { o(T) => T_Bool }
    end
    m :rindex, T_Enumerator[T]

    m :rotate, o(T_Integer) => t_self
    m :rotate!, o(T_Integer) => t_self

    m :sample, [random: o(T_Any)] => T
    m :sample, [T_Integer, random: o(T_Any)] => t_self

    m :select, t_self do
      { o(T) => T_Bool }
    end
    m :select, T_Enumerator[T]
    m :select!, t_self | T_Nil do
      { o(T) => T_Bool }
    end
    m :select!, T_Enumerator[T]

    m :shelljoin, T_String

    m :shift, T | T_Nil
    m :shift, T_Integer => t_self

    m :shuffle, [random: o(T_Any)] => t_self
    m :shuffle!, [random: o(T_Any)] => t_self

    m :size, T_Integer

    m :slice, T_Integer => T | T_Nil
    m :slice, [T_Integer, T_Integer] => t_self | T_Nil
    m :slice, [T_Range[T_Integer]] => t_self | T_Nil
    m :slice!, T_Integer => T | T_Nil
    m :slice!, [T_Integer, T_Integer] => t_self | T_Nil
    m :slice!, [T_Range[T_Integer]] => t_self | T_Nil

    m :sort, t_self
    m :sort, t_self do
      { [o(T), o(T)] => T_Integer | T_Nil }
    end
    m :sort!, t_self
    m :sort!, t_self do
      { [o(T), o(T)] => T_Integer | T_Nil }
    end

    m :sort_by!, t_self do
      { o(T) => T_Any }
    end
    m :sort_by!, T_Enumerator[T]

    m :sum, o(T) => T
    m :sum, o(T) => T do
      { o(T) => T }
    end

    m :take, T_Integer => t_self

    m :take_while, t_self do
      { o(T) => T_Bool }
    end
    m :take_while, T_Enumerator[T]

    m :to_a, t_self
    m :to_ary, t_self

    m :to_h, T_Hash[T, T]

    m :transpose, t_self

    m :uniq, t_self
    m :uniq, t_self do
      { o(T) => T_Any }
    end

    m :uniq!, t_self | T_Nil
    m :uniq!, t_self | T_Nil do
      { o(T) => T_Any }
    end

    m :unshift, [T, v(T)] => t_self
    m :prepend, [T, v(T)] => t_self

    m :values_at, [T_Integer | T_Range[T_Integer], v(T_Integer | T_Range[T_Integer])] => t_self

    m :zip, [T_Array[A], T_Array[B]] => T_Array[T_Array[T | A | B]]
    m :zip, [T_Array[A], T_Array[B]] => T_Nil do
      { T_Array[T | A | B] => T_Any }
    end
  end

  C_Array.define do
    m :[], v(G) => T_Array[G]
    m :new, [o(T_Integer)] => T_Array
    m :new, [T_Integer, G] => T_Array[G]
    m :new, T_Array[G] => T_Array[G]
    m :new, T_Integer => T_Array[G] do
      { o(T_Integer) => G }
    end
    m :try_convert, T_Any => T_Array | T_Nil
  end
end