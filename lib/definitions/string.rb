require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Object) do
  add_method_definition :iseuc, Bool
  add_method_definition :isjis, Bool
  add_method_definition :issjis, Bool
  add_method_definition :isutf8, Bool
  add_method_definition :kconv, T(String), T(Encoding), T(Encoding)
  add_method_definition :to_c, T(Complex)
  add_method_definition :to_d, T(BigDecimal)
  add_method_definition :toeuc, T(String)
  add_method_definition :tojis, T(String)
  add_method_definition :tolocale, T(String)
  add_method_definition :tosjis, T(String)
  add_method_definition :toutf16, T(String)
  add_method_definition :toutf32, T(String)
  add_method_definition :toutf8, T(String)

  add_class_method_definition :new, T(String)
  add_class_method_definition :new, T(String), T(String) # TODO: takes kwargs

  add_class_method_definition :try_convert, T(String) | Nil, Any

  add_method_definition :%, T(String), Any
  add_method_definition :*, T(String), T(Integer)
  add_method_definition :+, T(String), T(String)
  add_method_definition :+, T(String)
  add_method_definition :-, T(String)
  add_method_definition :<<, T(String), T(String) | T(Integer)
  add_method_definition :<=>, T(Integer) | Nil, T(String)
  add_method_definition :==, Bool, Any
  add_method_definition :===, Bool, Any
  add_method_definition :=~, T(Integer) | Nil, T(Regexp) # TODO: can pass numbers tho?
  add_method_definition :[], T(String) | Nil, T(Integer) | T(Range, Integer) | T(Regexp) | T(String)
  add_method_definition :[], T(String) | Nil, T(Integer), T(Integer)
  add_method_definition :[], T(String) | Nil, T(Regexp), T(Integer) | T(String)
  add_method_definition :[]=, T(String), T(Integer) | T(Range, Integer) | T(Regexp) | T(String), T(String)
  add_method_definition :[]=, T(String), T(Integer), T(Integer), T(String)
  add_method_definition :[]=, T(String), T(Regexp), T(Integer) | T(String), T(String)
  add_method_definition :ascii_only?, Bool
  add_method_definition :b, T(String)
  add_method_definition :block_scan, T(Array) # TODO: can take a block
  add_method_definition :bytes, T(Array, Integer)
  add_method_definition :bytesize, T(Integer)
  add_method_definition :byteslice, T(String) | Nil, T(Integer) | T(Range, Integer)
  add_method_definition :byteslice, T(String) | Nil, T(Integer), T(Integer)
  add_method_definition :capitalize, T(String) # TODO: takes variadic options
  add_method_definition :capitalize!, T(String) | Nil # TODO: takes variadic options
  add_method_definition :casecmp, T(Integer) | Nil, T(String)
  add_method_definition :casecmp?, Bool | Nil, T(String)
  add_method_definition :center, T(String), T(Integer)
  add_method_definition :center, T(String), T(Integer), T(String)
  add_method_definition :chars, T(Array, String)
  add_method_definition :chomp, T(String)
  add_method_definition :chomp, T(String), T(String)
  add_method_definition :chomp!, T(String) | Nil
  add_method_definition :chomp!, T(String) | Nil, T(String)
  add_method_definition :chop, T(String)
  add_method_definition :chop!, T(String) | Nil
  add_method_definition :chr, T(String)
  add_method_definition :clear, T(String)
  add_method_definition :codepoints , T(Array, Integer)
  add_method_definition :concat , T(String) # TODO: variadic
  add_method_definition :count, T(Integer) # TODO: variadic
  add_method_definition :crypt, T(String), T(String)
  add_method_definition :delete, T(String) # TODO: variadic
  add_method_definition :delete!, T(String) | Nil # TODO: variadic
  add_method_definition :delete_prefix, T(String), T(String)
  add_method_definition :delete_prefix!, T(String) | Nil, T(String)
  add_method_definition :delete_suffix, T(String), T(String)
  add_method_definition :delete_suffix!, T(String) | Nil, T(String)
  add_method_definition :downcase, T(String) # TODO: takes variadic options
  add_method_definition :downcase!, T(String) | Nil # TODO: takes variadic options
  add_method_definition :dump, T(String)
  add_method_definition :each_byte, T(String) # TODO: Takes a block
  add_method_definition :each_byte, T(Enumerator, Integer)
  add_method_definition :each_char, T(String) # TODO: Takes a block
  add_method_definition :each_char, T(Enumerator, String)
  add_method_definition :each_codepoint, T(String) # TODO: Takes a block
  add_method_definition :each_codepoint, T(Enumerator, Integer)
  add_method_definition :each_grapheme_cluster , T(String) # TODO: Takes a block
  add_method_definition :each_grapheme_cluster , T(Enumerator, String)
  add_method_definition :each_line, T(String) # TODO: Takes a block, and a kwarg
  add_method_definition :each_line, T(String), T(String) # TODO: Takes a block, and a kwarg
  add_method_definition :each_line, T(Enumerator, String) # TODO: takes a kwarg
  add_method_definition :each_line, T(Enumerator, String), T(String) # TODO: takes a kwarg
  add_method_definition :empty?, Bool
  add_method_definition :encode, T(String) # TODO: takes kwargs
  add_method_definition :encode, T(String), T(Encoding) # TODO: takes kwargs
  add_method_definition :encode, T(String), T(Encoding), T(Encoding) # TODO: takes kwargs
  add_method_definition :encode!, T(String), T(Encoding) # TODO: takes kwargs
  add_method_definition :encode!, T(String), T(Encoding), T(Encoding) # TODO: takes kwargs
  add_method_definition :encoding, T(Encoding)
  add_method_definition :end_with?, Bool # TODO: variadic
  add_method_definition :eql?, Bool, Any
  add_method_definition :force_encoding, T(String), T(Encoding)
  add_method_definition :freeze, Self
  add_method_definition :get_byte, T(Integer), T(Integer)
  add_method_definition :grapheme_clusters ,T(Array, String)
  add_method_definition :gsub, T(String), T(Regexp) | T(String), T(String) | T(Hash, String, Any)
  add_method_definition :gsub, T(String), T(Regexp) | T(String) # TODO: takes a block
  add_method_definition :gsub, T(Enumerator), T(Regexp) | T(String)
  add_method_definition :gsub!, T(String) | Nil, T(Regexp) | T(String), T(String) | T(Hash, String, Any)
  add_method_definition :gsub!, T(String) | Nil, T(Regexp) | T(String) # TODO: takes a block
  add_method_definition :gsub!, T(Enumerator), T(Regexp) | T(String)
  add_method_definition :hash, T(Integer)
  add_method_definition :hex, T(Integer)
  add_method_definition :include?, Bool, T(String)
  add_method_definition :index, T(Integer) | Nil, T(String) | T(Regexp)
  add_method_definition :index, T(Integer) | Nil, T(String) | T(Regexp), T(Integer)
  add_method_definition :replace, T(String), T(String)
  add_method_definition :insert, T(String), T(Integer), T(String)
  add_method_definition :inspect, T(String)
  add_method_definition :intern, T(Symbol)
  add_method_definition :length, T(Integer)
  add_method_definition :lines, T(Array, String) # TODO: can take a block
  add_method_definition :lines, T(Array, String), T(String) # TODO: can take a block?
  add_method_definition :ljust, T(String), T(Integer)
  add_method_definition :ljust, T(String), T(Integer), T(String)
  add_method_definition :lstrip, T(String)
  add_method_definition :lstrip!, Self | Nil
  add_method_definition :match, T(MatchData) | Nil, T(Regexp) | T(String) # TODO: can take a block
  add_method_definition :match, T(MatchData) | Nil, T(Regexp) | T(String), T(Integer) # TODO: can take a block
  add_method_definition :match?, Bool, T(Regexp) | T(String)
  add_method_definition :match?, Bool, T(Regexp) | T(String), T(Integer)
  add_method_definition :next, T(String)
  add_method_definition :next!, T(String)
  add_method_definition :oct, T(String)
  add_method_definition :ord, T(Integer)
  add_method_definition :partition, T(Array, String), T(String) | T(Regexp)
  add_method_definition :prepend, T(String) # TODO: variadic
  add_method_definition :reverse, T(String)
  add_method_definition :reverse!, T(String)
  add_method_definition :rindex, T(Integer) | Nil, T(String) | T(Regexp)
  add_method_definition :rindex, T(Integer) | Nil, T(String) | T(Regexp), T(Integer)
  add_method_definition :rjust, T(String), T(Integer)
  add_method_definition :rjust, T(String), T(Integer), T(String)
  add_method_definition :rpartition, T(Array, String), T(String) | T(Regexp)
  add_method_definition :rstrip, T(String)
  add_method_definition :rstrip!, Self | Nil
  add_method_definition :scan!, T(Array, Any), T(String) | T(Regexp)
  add_method_definition :scan!, T(String), T(String) | T(Regexp) # TODO: takes a block
  add_method_definition :scanf, T(Array, Any), T(String) # TODO: takes a block
  add_method_definition :scrub, T(String) # TODO: takes a block
  add_method_definition :scrub, T(String), T(String)
  add_method_definition :scrub!, T(String) # TODO: takes a block
  add_method_definition :scrub!, T(String), T(String)
  add_method_definition :setbyte, T(Integer), T(Integer), T(Integer)
  add_method_definition :shellescape, T(String)
  add_method_definition :shellsplit, T(Array, String)
  add_method_definition :size, T(Integer)
  add_method_definition :slice, T(String) | Nil, T(Integer) | T(Range, Integer) | T(Regexp) | T(String)
  add_method_definition :slice, T(String) | Nil, T(Integer), T(Integer)
  add_method_definition :slice, T(String) | Nil, T(Regexp), T(Integer) | T(String)
  add_method_definition :slice!, T(String) | Nil, T(Integer) | T(Range, Integer) | T(Regexp) | T(String)
  add_method_definition :slice!, T(String) | Nil, T(Integer), T(Integer)
  add_method_definition :slice!, T(String) | Nil, T(Regexp), T(Integer) | T(String)
  add_method_definition :split, T(Array, String)
  add_method_definition :split, T(Array, String), T(String) | T(Regexp)
  add_method_definition :split, T(Array, String), T(String) | T(Regexp), T(Integer)
  add_method_definition :squeeze, T(String) # TODO: variadic
  add_method_definition :squeeze!, T(String) | Nil # TODO: variadic
  add_method_definition :start_with?, Bool, T(String) # TODO: variadic
  add_method_definition :strip, T(String)
  add_method_definition :strip!, T(String) | Nil
  add_method_definition :sub, T(String), T(String) | T(Regexp), T(String) | T(Hash, String, Any)
  add_method_definition :sub, T(String), T(String) | T(Regexp) # TODO: takes a block
  add_method_definition :sub!, T(String) | Nil, T(String) | T(Regexp), T(String) | T(Hash, String, Any)
  add_method_definition :sub!, T(String) | Nil, T(String) | T(Regexp) # TODO: takes a block
  add_method_definition :succ, T(String)
  add_method_definition :succ!, T(String)
  add_method_definition :sum, T(Integer)
  add_method_definition :sum, T(Integer), T(Integer)
  add_method_definition :swapcase, T(String)
  add_method_definition :swapcase!, T(String) | Nil # TODO: takes options
  add_method_definition :to_f, T(Float)
  add_method_definition :to_i, T(Integer)
  add_method_definition :to_i, T(Integer), T(Integer)
  add_method_definition :to_r, T(Rational)
  add_method_definition :to_s, T(String)
  add_method_definition :to_str, T(String)
  add_method_definition :to_sym, T(Symbol)
  add_method_definition :tr, T(String), T(String), T(String)
  add_method_definition :tr!, T(String) | Nil, T(String), T(String)
  add_method_definition :tr_s, T(String), T(String), T(String)
  add_method_definition :tr_s!, T(String) | Nil, T(String), T(String)
  add_method_definition :undump, T(String)
  add_method_definition :unicode_normalize, T(String)
  add_method_definition :unicode_normalize, T(String), T(Symbol)
  add_method_definition :unicode_normalize!, T(String)
  add_method_definition :unicode_normalize!, T(String), T(Symbol)
  add_method_definition :unicode_normalized?, Bool
  add_method_definition :unicode_normalized?, Bool, T(Symbol)
  add_method_definition :unpack, T(Array), T(String)
  add_method_definition :unpack1, Any, T(String)
  add_method_definition :upcase, T(String) # TODO: takes variadic options
  add_method_definition :upcase!, T(String) | Nil # TODO: takes variadic options
  add_method_definition :upto, T(String), T(String) # TODO: takes block
  add_method_definition :upto, T(String), T(String), Bool # TODO: takes block
  add_method_definition :upto, T(Enumerator, String), T(String), Bool
  add_method_definition :valid_encoding?, Bool
end