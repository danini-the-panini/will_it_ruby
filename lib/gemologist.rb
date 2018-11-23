require "gemologist/version"
require "ruby_parser"

module Gemologist
  class Type
    def |(other)
      case other
      when AnyType
        Any
      when UnionType
        other | self
      else
        UnionType.new(self, other)
      end
    end

    def matches?(_)
      false
    end

    protected

    def subclass?(a, b)
      return true if a == b
      return false if b.nil?
      return subclass?(a, b.superclass)
    end
  end

  class ClassType < Type
    attr_reader :base_class

    def initialize(base_class)
      @base_class = base_class
    end

    def matches?(other)
      subclass?(base_class, other.base_class)
    end

    def type
      T(base_class)
    end

    def type_matches?(other)
      type.matches?(other)
    end

    def ==(other)
      other.is_a?(ClassType) && other.base_class == self.base_class
    end
  end

  class UnionType < Type
    attr_reader :types

    def initialize(*types)
      @types = types.map { |t| T(t) }
    end

    def |(other)
      case other
      when AnyType
        Any
      when UnionType
        UnionType.new(*(self.types | other.types))
      else
        UnionTypes.new(*(self.types | [T(other)]))
      end
    end

    def matches?(other)
      case other
      when UnionType then other.types.all? { |t| self.types.any? { |t2| t2.matches?(t) } }
      else self.types.any? { |t| t.matches?(other) }
      end
    end

    def ==(other)
      return false unless other.is_a?(UnionType)
      other.types.all? { |t| self.types.any? { |t2| t == t2 }}
    end
  end

  class SingleType < Type
    attr_reader :type

    def initialize(native_type)
      raise ArgumentError.new("Only native types can be used in SingleType") if native_type.is_a?(Type)
      @type = case native_type
              when Class then native_type
              else native_type.class
              end
    end

    def matches?(other)
      case other
      when SingleType then subclass?(self.type, other.type)
      when GenericType then subclass?(self.type, pther.main_type)
      when UnionType then other.types.all? { |t| self.matches?(t) }
      else false
      end
    end
    
    def ==(other)
      other.is_a?(SingleType) && other.type == self.type
    end
  end

  class GenericType < Type
    attr_reader :main_type, :subtypes

    def initialize(main_type, *subtypes)
      @main_type = T(main_type)
      @subtypes = subtypes.map { |t| T(t) }
    end

    def matches?(other)
      return false unless other.is_a?(GenericType)
      return false unless self.main_type.matches?(other.main_type)
      return false unless other.subtypes.count == self.subtypes.count
      other.subtypes.zip(self.subtypes).all? { |ot, t| t.matches?(ot) }
    end

    def ==(other)
      return false unless other.is_a?(GenericType)
      return false unless other.main_type == self.main_type
      return false unless other.subtypes.count == self.subtypes.count
      other.subtypes.all? { |t| self.subtypes.any? { |t2| t == t2 }}
    end
  end

  class AnyType < Type
    Instance = AnyType.new

    def |(other)
      self
    end

    def matches?(_)
      true
    end

    def ==(other)
      other.is_a?(AnyType)
    end
  end

  class SelfType < Type
    Instance = SelfType.new
  end

  class SelfClassType < ClassType
    Instance = SelfClassType.new
    def initialize
      super(nil)
    end
  end

  class PlaceholderType < Type
  end

  Any = AnyType::Instance
  Self = SelfType::Instance
  SelfClass = SelfClassType::Instance
  Nil = SingleType.new(NilClass)
  Bool = T(TrueClass) | T(FalseClass)

  A = PlaceholderType.new
  B = PlaceholderType.new
  D = PlaceholderType.new
  E = PlaceholderType.new
  F = PlaceholderType.new
  G = PlaceholderType.new
  H = PlaceholderType.new
  I = PlaceholderType.new
  J = PlaceholderType.new
  K = PlaceholderType.new
  L = PlaceholderType.new
  M = PlaceholderType.new
  N = PlaceholderType.new
  O = PlaceholderType.new
  P = PlaceholderType.new
  Q = PlaceholderType.new
  R = PlaceholderType.new
  S = PlaceholderType.new
  U = PlaceholderType.new
  V = PlaceholderType.new
  W = PlaceholderType.new
  X = PlaceholderType.new
  Y = PlaceholderType.new
  Z = PlaceholderType.new

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

def T(type, *other_types)
  if other_types.empty?
    return type if type.is_a?(Gemologist::Type)
    Gemologist::SingleType.new(type)
  else
    Gemologist::GenericType.new(type, *other_types)
  end
end

def C(klass)
  Gemologist::ClassType.new(klass)
end