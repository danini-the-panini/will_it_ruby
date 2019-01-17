require 'set'

module Ahiru
  class Union
    attr_reader :types

    def initialize(types)
      @types = types.to_set
    end

    def |(other)
      case other
      when Duck
        return self if types.any? { |t| t <= other }
        Union.new(types.reject { |t| other <= t } | [other]).normalize
      when Union
        other.types.reduce(self) { |a,b| a | b }.normalize
      end
    end

    # TODO
    def &(other)
      case other
      when Duck
      when Union
      end
      self
    end

    # TODO
    def -(other)
      case other
      when Duck
      when Union
      end
      self
    end

    def <=(other)
      types.any? { |t| t <= other}
    end

    def rewrite(free_type_values)
      Union.new(types.map { |t| t.rewrite(free_type_values) })
    end

    def to_s
      "(#{types.map(&:to_s).join(' | ')})"
    end

    def inspect
      to_s
    end

    def free?
      false
    end

    def ==(other)
      return false unless other.is_a?(Union)
      types == other.types
    end

    def could_be_nil?
      types.any?(&:could_be_nil?)
    end

    protected
    

    def normalize
      return types.first if types.length == 1
      self
    end
  end
end