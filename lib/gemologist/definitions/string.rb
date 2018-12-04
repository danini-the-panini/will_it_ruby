module Gemologist
  T_String.define do
    m :iseuc, T_Bool
    m :isjis, T_Bool
    m :issjis, T_Bool
    m :isutf8, T_Bool
    m :kconv, [T_Encoding, T_Encoding] => T_String
    m :to_c, T_Complex
    # m :to_d, T_BigDecimal # TODO: requires BigDecimal to be required
    m :toeuc, T_String
    m :tojis, T_String
    m :tolocale, T_String
    m :tosjis, T_String
    m :toutf16, T_String
    m :toutf32, T_String
    m :toutf8, T_String

    m :%, T_Any => T_String
    m :*, T_Integer => T_String
    m :+, T_String => T_String
    m :+, T_String
    m :-, T_String
    m :<<, [T_String | T_Integer] => T_String
    m :<=>, T_String => T_Integer | T_Nil
    m :==, T_Any => T_Bool
    m :===, T_Any => T_Bool
    m :=~, T_Regexp => T_Integer | T_Nil # TODO: can pass numbers tho?
    m :[], [T_Integer | T_Range[T_Integer] | T_String] => T_String | T_Nil
    m :[], [T_Integer, T_Integer] => T_String | T_Nil
    m :[], [T_Regexp, o(T_Integer | T_String)] => T_String | T_Nil
    m :[]=, [T_Integer | T_Range[T_Integer] | T_String, T_String] => T_String
    m :[]=, [T_Integer, T_Integer, T_String] => T_String
    m :[]=, [T_Regexp, o(T_Integer | T_String), T_String] => T_String
    m :ascii_only?, T_Bool
    m :b, T_String
    m :block_scanf, T_Array[T_Any]
    m :block_scanf, T_Array[T_Any] do
      { o(T_Array[T_Any]) => T_Any }
    end
    m :bytes, T_Array[T_Integer]
    m :bytesize, T_Integer
    m :byteslice, [T_Integer | T_Range[T_Integer]] => T_String | T_Nil
    m :byteslice, [T_Integer, T_Integer] => T_String | T_Nil
    m :casecmp, T_String => T_Integer | T_Nil
    m :casecmp?, T_String => T_Bool | T_Nil
    m :center, [T_Integer, o(T_String)] => T_String
    m :chars, T_Array[T_String]
    m :chomp, T_String
    m :chomp,  T_String => T_String
    m :chomp!, o(T_String) => T_String | T_Nil
    m :chop, T_String
    m :chop!, T_String | T_Nil
    m :chr, T_String
    m :clear, T_String
    m :codepoints , T_Array[T_Integer]
    m :concat, v(T_Any) => T_String
    m :count, [T_String, v(T_String)] => T_Integer
    m :crypt, T_String => T_String
    m :delete, [T_String, v(T_String)] => T_String
    m :delete!, [T_String, v(T_String)] => T_String | T_Nil
    m :delete_prefix, T_String => T_String
    m :delete_prefix!, T_String => T_String | T_Nil
    m :delete_suffix, T_String => T_String
    m :delete_suffix!, T_String => T_String | T_Nil
    m :dump, T_String
    m :each_byte, T_String do
      { o(T_Integer) => T_Any }
    end
    m :each_byte, T_Enumerator[T_Integer]
    m :each_char, T_String do
      { o(T_String) => T_Any }
    end
    m :each_char, T_Enumerator[T_String]
    m :each_codepoint, T_String do
      { o(T_Integer) => T_Any }
    end
    m :each_codepoint, T_Enumerator[T_Integer]
    m :each_grapheme_cluster, T_String do
      { o(T_String) => T_Any }
    end
    m :each_grapheme_cluster, T_Enumerator[T_String]
    m :each_line, [o(T_String), chomp: o(T_String)] => T_String do
      { o(T_String) => T_Any }
    end
    m :each_line, [o(T_String), chomp: o(T_String)] => T_Enumerator[T_String]
    m :empty?, T_Bool
    m :encode, [o(T_Encoding), o(T_Encoding), invalid: o(T_Symbol),
                                              undef: o(T_Symbol),
                                              replace: o(T_String),
                                              fallback: o(T_Hash[T_String, T_String] | T_Proc[T_String]),
                                              xml: o(T_Symbol),
                                              cr_newline: o(T_Bool),
                                              crl_newline: o(T_Bool),
                                              universal_newline: o(T_Bool)] => T_String
    m :encoding, T_Encoding
    m :end_with?, [T_String, v(T_String)] => T_Bool
    m :eql?, T_Any => T_Bool
    m :force_encoding, T_Encoding => T_String
    m :freeze, t_self
    m :get_byte, T_Integer => T_Integer
    m :grapheme_clusters, T_Array[T_String]


    m :gsub, T_Pattern => T_String do
      { o(T_String) => T_Any }
    end
    m :gsub, T_Pattern => T_Enumerator[T_String]
    m :gsub, [T_Pattern, T_String | T_Hash[T_String, T_Any]] => T_String
    m :gsub!, T_Pattern => T_String | T_Nil do
      { o(T_String) => T_Any }
    end
    m :gsub!, T_Pattern => T_Enumerator[T_String]
    m :gsub!, [T_Pattern, T_String | T_Hash[T_String, T_Any]] => T_String | T_Nil

    m :hash, T_Integer
    m :hex, T_Integer
    m :include?, T_String => T_Bool
    m :index, [T_Pattern, o(T_Integer)] => T_Integer | T_Nil
    m :replace, T_String => T_String
    m :insert, [T_Integer, T_String] => T_String
    m :inspect, T_String
    m :intern, T_Symbol
    m :length, T_Integer
    m :lines, o(T_String) => T_Array[T_String] do
      { o(T_String) => T_Any }
    end
    m :ljust, [T_Integer, o(T_String)] => T_String
    m :lstrip, T_String
    m :lstrip!, t_self | T_Nil
    m :match, [T_Regexp | T_String, o(T_Integer)] => T_MatchData | T_Nil do
      { o(T_MatchData) => T_Any }
    end
    m :match?, [T_Regexp | T_String, o(T_Integer)] => T_Bool
    m :next, T_String
    m :next!, T_String
    m :oct, T_String
    m :ord, T_Integer
    m :partition, T_Pattern => T_Array[T_String]
    m :prepend, v(T_String) => T_String
    m :reverse, T_String
    m :reverse!, T_String
    m :rindex, [T_Pattern, o(T_Integer)] => T_Integer | T_Nil
    m :rjust, [T_Integer, o(T_String)] => T_String
    m :rpartition, T_Pattern => T_Array[T_String]
    m :rstrip, T_String
    m :rstrip!, t_self | T_Nil
    m :scan, T_Pattern => T_Array[T_Any]
    m :scan, T_Pattern => T_String do
      { o(T_String) => T_Any }
    end
    m :scanf, T_String => T_Array[T_Any] do
      { o(T_Array[T_Any]) => T_Any }
    end
    m :scrub, o(T_String) => T_String
    m :scrub, T_String do
      { o(T_Array[T_Integer]) => T_String }
    end
    m :scrub!, o(T_String) => T_String
    m :scrub!, T_String do
      { o(T_Array[T_Integer]) => T_String }
    end
    m :setbyte, [T_Integer, T_Integer] => T_Integer
    m :shellescape, T_String
    m :shellsplit, T_Array[T_String]
    m :size, T_Integer
    m :slice, [T_Integer | T_Range[T_Integer] | T_String] => T_String | T_Nil
    m :slice, [T_Integer, T_Integer] => T_String | T_Nil
    m :slice, [T_Regexp, o(T_Integer | T_String)] => T_String | T_Nil
    m :slice!, [T_Integer | T_Range[T_Integer] | T_String] => T_String | T_Nil
    m :slice!, [T_Integer, T_Integer] => T_String | T_Nil
    m :slice!, [T_Regexp, o(T_Integer | T_String)] => T_String | T_Nil
    m :split, [o(T_Pattern), o(T_Integer)] => T_Array[T_String]
    m :squeeze, v(T_String) => T_String
    m :squeeze!, v(T_String) => T_String | T_Nil
    m :start_with?, [T_String, v(T_String)] => T_Bool
    m :strip, T_String
    m :strip!, T_String | T_Nil

    m :sub, T_Pattern => T_String do
      { T_String => T_Any }
    end
    m :sub, T_Pattern => T_Enumerator[T_String]
    m :sub, [T_Pattern, T_String | T_Hash[T_String, T_Any]] => T_String
    m :sub!, T_Pattern => T_String | T_Nil do
      { o(T_String) => T_Any }
    end
    m :sub!, T_Pattern => T_Enumerator[T_String]
    m :sub!, [T_Pattern, T_String | T_Hash[T_String, T_Any]] => T_String | T_Nil

    m :succ, T_String
    m :succ!, T_String
    m :sum, o(T_Integer) => T_Integer
    m :to_f, T_Float
    m :to_i, o(T_Integer) => T_Integer
    m :to_r, T_Rational
    m :to_s, T_String
    m :to_str, T_String
    m :to_sym, T_Symbol
    m :tr, [T_String, T_String] => T_String
    m :tr!, [T_String, T_String] => T_String | T_Nil
    m :tr_s, [T_String, T_String] => T_String
    m :tr_s!, [T_String, T_String] => T_String | T_Nil
    m :undump, T_String
    m :unicode_normalize, o(T_Symbol) => T_String
    m :unicode_normalize!, o(T_Symbol) => T_String
    m :unicode_normalized?, o(T_Symbol) => T_Bool
    m :unpack, T_String => T_Array
    m :unpack1, T_String => T_Any

    _downcase_options = [o(T_Symbol), o(T_Symbol), o(T_Symbol), o(T_Symbol)]
    m :capitalize, _downcase_options => T_String
    m :capitalize!, _downcase_options => T_String | T_Nil
    m :downcase, _downcase_options => T_String
    m :downcase!, _downcase_options => T_String | T_Nil
    m :upcase, _downcase_options => T_String
    m :upcase!, _downcase_options => T_String | T_Nil
    m :swapcase, _downcase_options => T_String
    m :swapcase!, _downcase_options => T_String | T_Nil

    m :upto, [T_String, o(T_Bool)] => T_String do
      { o(T_String) => T_Any }
    end
    m :upto, [T_String, o(T_Bool)] => T_Enumerator[T_String]
    
    m :valid_encoding?, T_Bool
  end

  C_String.define do
    m :new, [o(T_String), encoding: o(T_Encoding), capacity: o(T_Integer)] => T_String

    m :try_convert, T_Any => T_String | T_Nil
  end
end