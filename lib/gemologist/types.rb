require "ruby_parser"

def T(type, *other_types)
  if other_types.empty?
    return type if type.is_a?(Gemologist::Type)
    Gemologist::SingleType.new(type)
  else
    Gemologist::GenericType.new(type, *other_types)
  end
end

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

    def variadic?
      !!@variadic
    end

    def optional?
      !!@optional
    end

    def +@
      @variadic = true
      self
    end

    def !
      @optional = true
      self
    end

    protected

    def subclass?(a, b)
      return true if a == b
      return false if b.nil?
      return subclass?(a, b.superclass)
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
        UnionType.new(*(self.types | [T(other)]))
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

  class PlaceholderType < Type
  end

  Any = AnyType::Instance
  Self = SelfType::Instance
  SelfClass = T(Class, Self)
  Nil = SingleType.new(NilClass)
  Bool = T(TrueClass) | T(FalseClass)
  Pattern = T(String) | T(Regexp)
  Real = T(Integer) | T(Float) | T(Rational)

  A = PlaceholderType.new
  B = PlaceholderType.new
  C = PlaceholderType.new
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
  T = PlaceholderType.new
  U = PlaceholderType.new
  V = PlaceholderType.new
  W = PlaceholderType.new
  Y = PlaceholderType.new
  Z = PlaceholderType.new
end