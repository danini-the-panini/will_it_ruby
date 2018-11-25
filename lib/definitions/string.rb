require 'gemologist/definition'

module Gemologist
  Definition.add_class_definition(Object) do
    add_method_definition :iseuc, Bool
    add_method_definition :isjis, Bool
    add_method_definition :issjis, Bool
    add_method_definition :isutf8, Bool
    add_method_definition :kconv, [T(Encoding), T(Encoding)] => T(String)
    add_method_definition :to_c, T(Complex)
    # add_method_definition :to_d, T(BigDecimal) # TODO: requires BigDecimal to be required
    add_method_definition :toeuc, T(String)
    add_method_definition :tojis, T(String)
    add_method_definition :tolocale, T(String)
    add_method_definition :tosjis, T(String)
    add_method_definition :toutf16, T(String)
    add_method_definition :toutf32, T(String)
    add_method_definition :toutf8, T(String)

    add_class_method_definition :new, [!T(String), encoding: !T(Encoding), capacity: !T(Integer)] => T(String)

    add_class_method_definition :try_convert, T(String) | Nil, Any

    add_method_definition :%, Any => T(String)
    add_method_definition :*, T(Integer) => T(String)
    add_method_definition :+, T(String) => T(String)
    add_method_definition :+, T(String)
    add_method_definition :-, T(String)
    add_method_definition :<<, [T(String) | T(Integer)] => T(String)
    add_method_definition :<=>, T(String) => T(Integer) | Nil
    add_method_definition :==, Bool, Any
    add_method_definition :===, Bool, Any
    add_method_definition :=~, T(Regexp) => T(Integer) | Nil # TODO: can pass numbers tho?
    add_method_definition :[], [T(Integer) | T(Range, Integer) | T(String)] => T(String) | Nil
    add_method_definition :[], [T(Integer), T(Integer)] => T(String) | Nil
    add_method_definition :[], [T(Regexp), !(T(Integer) | T(String))] => T(String) | Nil
    add_method_definition :[]=, [T(Integer) | T(Range, Integer) | T(String), T(String)] => T(String)
    add_method_definition :[]=, [T(Integer), T(Integer), T(String)] => T(String)
    add_method_definition :[]=, [T(Regexp), !(T(Integer) | T(String)), T(String)] => T(String)
    add_method_definition :ascii_only?, Bool
    add_method_definition :b, T(String)
    add_method_definition :block_scanf, T(Array)
    add_method_definition :block_scanf, T(Array), !T(Array) => Any
    add_method_definition :bytes, T(Array, Integer)
    add_method_definition :bytesize, T(Integer)
    add_method_definition :byteslice, [T(Integer) | T(Range, Integer)] => T(String) | Nil
    add_method_definition :byteslice, [T(Integer), T(Integer)] => T(String) | Nil
    add_method_definition :casecmp, T(String) => T(Integer) | Nil
    add_method_definition :casecmp?, T(String) => Bool | Nil
    add_method_definition :center, [T(Integer), !T(String)] => T(String)
    add_method_definition :chars, T(Array, String)
    add_method_definition :chomp, T(String)
    add_method_definition :chomp,  T(String) => T(String)
    add_method_definition :chomp!, !T(String) => T(String) | Nil
    add_method_definition :chop, T(String)
    add_method_definition :chop!, T(String) | Nil
    add_method_definition :chr, T(String)
    add_method_definition :clear, T(String)
    add_method_definition :codepoints , T(Array, Integer)
    add_method_definition :concat, +Any => T(String)
    add_method_definition :count, [T(String), +T(String)] => T(Integer)
    add_method_definition :crypt, T(String), T(String)
    add_method_definition :delete, [T(String), +T(String)] => T(String)
    add_method_definition :delete!, [T(String), +T(String)] => T(String) | Nil
    add_method_definition :delete_prefix, T(String), T(String)
    add_method_definition :delete_prefix!, T(String) | Nil, T(String)
    add_method_definition :delete_suffix, T(String), T(String)
    add_method_definition :delete_suffix!, T(String) | Nil, T(String)
    add_method_definition :dump, T(String)
    add_method_definition :each_byte, T(String), T(Integer) => Any
    add_method_definition :each_byte, T(Enumerator, Integer)
    add_method_definition :each_char, T(String), T(String) => Any
    add_method_definition :each_char, T(Enumerator, String)
    add_method_definition :each_codepoint, T(String), T(Integer) => Any
    add_method_definition :each_codepoint, T(Enumerator, Integer)
    add_method_definition :each_grapheme_cluster, T(String), T(String) => Any
    add_method_definition :each_grapheme_cluster, T(Enumerator, String)
    add_method_definition :each_line, { [!T(String), chomp: !T(String)] => T(String) }, T(String) => Any
    add_method_definition :each_line, [!T(String), chomp: !T(String)] => T(Enumerator, String)
    add_method_definition :empty?, Bool
    add_method_definition :encode, [!T(Encoding), !T(Encoding),
                                    invalid: !T(Symbol),
                                    undef: !T(Symbol),
                                    replace: !T(String),
                                    fallback: !(T(Hash, String, String) | T(Proc, String, String)),
                                    xml: !T(Symbol),
                                    cr_newline: !Bool,
                                    crl_newline: !Bool,
                                    universal_newline: !Bool] => T(String)
    add_method_definition :encoding, T(Encoding)
    add_method_definition :end_with?, [T(String), +T(String)] => Bool
    add_method_definition :eql?, Any => Bool
    add_method_definition :force_encoding, T(Encoding) => T(String)
    add_method_definition :freeze, Self
    add_method_definition :get_byte, T(Integer) => T(Integer)
    add_method_definition :grapheme_clusters, T(Array, String)


    add_method_definition :gsub, { Pattern => T(String) }, !T(String) => Any
    add_method_definition :gsub, Pattern => T(Enumerator, String)
    add_method_definition :gsub, [Pattern, T(String) | T(Hash, String, Any)] => T(String)
    add_method_definition :gsub!, { Pattern => T(String) | Nil }, !T(String) => Any
    add_method_definition :gsub!, Pattern => T(Enumerator, String)
    add_method_definition :gsub!, [Pattern, T(String) | T(Hash, String, Any)] => T(String) | Nil

    add_method_definition :hash, T(Integer)
    add_method_definition :hex, T(Integer)
    add_method_definition :include?, T(String) => Bool
    add_method_definition :index, [Pattern, !T(Integer)] => T(Integer) | Nil
    add_method_definition :replace, T(String) => T(String)
    add_method_definition :insert, [T(Integer), T(String)] => T(String)
    add_method_definition :inspect, T(String)
    add_method_definition :intern, T(Symbol)
    add_method_definition :length, T(Integer)
    add_method_definition :lines, { !T(String) => T(Array, String) }, !T(String) => Any
    add_method_definition :ljust, [T(Integer), !T(String)] => T(String)
    add_method_definition :lstrip, T(String)
    add_method_definition :lstrip!, Self | Nil
    add_method_definition :match, { [T(Regexp) | T(String), !T(Integer)] => T(MatchData) | Nil }, !T(MatchData) => Any
    add_method_definition :match?, [T(Regexp) | T(String), !T(Integer)] => Bool
    add_method_definition :next, T(String)
    add_method_definition :next!, T(String)
    add_method_definition :oct, T(String)
    add_method_definition :ord, T(Integer)
    add_method_definition :partition, Pattern => T(Array, String)
    add_method_definition :prepend, +T(String) => T(String)
    add_method_definition :reverse, T(String)
    add_method_definition :reverse!, T(String)
    add_method_definition :rindex, [Pattern, !T(Integer)] => T(Integer) | Nil
    add_method_definition :rjust, [T(Integer), !T(String)] => T(String)
    add_method_definition :rpartition, Pattern => T(Array, String)
    add_method_definition :rstrip, T(String)
    add_method_definition :rstrip!, Self | Nil
    add_method_definition :scan, Pattern => T(Array, Any)
    add_method_definition :scan, Pattern => T(Array)
    add_method_definition :scan, { Pattern => T(String) }, T(String) => Any
    add_method_definition :scanf, { T(String) => T(Array) }, !T(Array) => Any
    add_method_definition :scrub, !T(String) => T(String)
    add_method_definition :scrub, T(String), T(Array, Integer) => T(String)
    add_method_definition :scrub!, !T(String) => T(String)
    add_method_definition :scrub!, T(String), T(Array, Integer) => T(String)
    add_method_definition :setbyte, [T(Integer), T(Integer)] => T(Integer)
    add_method_definition :shellescape, T(String)
    add_method_definition :shellsplit, T(Array, String)
    add_method_definition :size, T(Integer)
    add_method_definition :slice, [T(Integer) | T(Range, Integer) | T(String)] => T(String) | Nil
    add_method_definition :slice, [T(Integer), T(Integer)] => T(String) | Nil
    add_method_definition :slice, [T(Regexp), !(T(Integer) | T(String))] => T(String) | Nil
    add_method_definition :slice!, [T(Integer) | T(Range, Integer) | T(String)] => T(String) | Nil
    add_method_definition :slice!, [T(Integer), T(Integer)] => T(String) | Nil
    add_method_definition :slice!, [T(Regexp), !(T(Integer) | T(String))] => T(String) | Nil
    add_method_definition :split, [!Pattern, !T(Integer)] => T(Array, String)
    add_method_definition :squeeze, +T(String) => T(String)
    add_method_definition :squeeze!, +T(String) => T(String) | Nil
    add_method_definition :start_with?, [T(String), +T(String)] => Bool
    add_method_definition :strip, T(String)
    add_method_definition :strip!, T(String) | Nil

    add_method_definition :sub, { Pattern => T(String) }, !T(String) => Any
    add_method_definition :sub, Pattern => T(Enumerator, String)
    add_method_definition :sub, [Pattern, T(String) | T(Hash, String, Any)] => T(String)
    add_method_definition :sub!, { Pattern => T(String) | Nil }, !T(String) => Any
    add_method_definition :sub!, Pattern => T(Enumerator, String)
    add_method_definition :sub!, [Pattern, T(String) | T(Hash, String, Any)] => T(String) | Nil

    add_method_definition :succ, T(String)
    add_method_definition :succ!, T(String)
    add_method_definition :sum, !T(Integer) => T(Integer)
    add_method_definition :to_f, T(Float)
    add_method_definition :to_i, !T(Integer) => T(Integer)
    add_method_definition :to_r, T(Rational)
    add_method_definition :to_s, T(String)
    add_method_definition :to_str, T(String)
    add_method_definition :to_sym, T(Symbol)
    add_method_definition :tr, [T(String), T(String)] => T(String)
    add_method_definition :tr!, [T(String), T(String)] => T(String) | Nil
    add_method_definition :tr_s, [T(String), T(String)] => T(String)
    add_method_definition :tr_s!, [T(String), T(String)] => T(String) | Nil
    add_method_definition :undump, T(String)
    add_method_definition :unicode_normalize, !T(Symbol) => T(String)
    add_method_definition :unicode_normalize!, !T(Symbol) => T(String)
    add_method_definition :unicode_normalized?, !T(Symbol) => Bool
    add_method_definition :unpack, T(String) => T(Array)
    add_method_definition :unpack1, T(String) => Any

    _downcase_options = [!T(Symbol), !T(Symbol), !T(Symbol), !T(Symbol)]
    add_method_definition :capitalize, _downcase_options => T(String)
    add_method_definition :capitalize!, _downcase_options => T(String) | Nil
    add_method_definition :downcase, _downcase_options => T(String)
    add_method_definition :downcase!, _downcase_options => T(String) | Nil
    add_method_definition :upcase, _downcase_options => T(String)
    add_method_definition :upcase!, _downcase_options => T(String) | Nil
    add_method_definition :swapcase, _downcase_options => T(String)
    add_method_definition :swapcase!, _downcase_options => T(String) | Nil

    add_method_definition :upto, { [T(String), !Bool] => T(String) }, T(String) => Any
    add_method_definition :upto, [T(String), !Bool] => T(Enumerator, String)
    
    add_method_definition :valid_encoding?, Bool
  end
end