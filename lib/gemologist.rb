require "ruby_parser"

require "gemologist/version"
require "gemologist/types"
require "gemologist/definition"

require "definitions/kernel"
require "definitions/basic_object"
require "definitions/object"
require "definitions/class"
require "definitions/string"
require "definitions/numeric"
require "definitions/array"
require "definitions/hash"

require "gemologist/scope"

module Gemologist
  def determine_types(sexps)
    sexps.map { |x| determine_type(x) }.reduce { |a, b| a | b }
  end

  def determine_type(sexp)
    case sexp[0]
    when :lit then T(sexp[1].class)
    when :str, :dstr then T(String)
    when :if
      if_type = s[2].nil? ? T(NilClass) : determine_type(s[2])
      else_type = s[3].nil? ? T(NilClass) : determine_type(s[3])
      if_type | else_type
    when :case
      when_types = determine_types(s[2..-2].map { |w| w[2] })
      else_type = s[-1].nil? ? T(NilClass) : determine_type(s[-1])
      when_types | else_type
    when :array
      return T(Array, Any) if s.length == 1
      array_type = determine_types(s[1..-1])
      T(Array, array_type)
    when :hash
      return T(Hash, Any, Any) if s.length == 1
      entries = s[1..-1]
      keys, values = [:even?, :odd?].map { |x| entries.values_at(*entries.each_index.select(&x)) }
      key_types = determine_types(keys)
      value_types = determine_types(values)
      T(Hash, key_types, value_types)
    end
  end
end