module Gemologist
  class Duck
    attr_reader :name, :super_duck, :methods

    def initialize(super_duck = nil, name: nil, methods: {})
      @name = name
      @super_duck = super_duck
      @methods = methods
    end

    def to_s
      return name unless name.nil?
      "Duck(#{methods.map(&:to_s).join(', ')})"
    end

    def <=(other)
      return false if other.nil?
      return true if other == self 
      return true if self <= other.super_duck
      return false if super_duck?(other)

      @methods.each do |name, signatures|
        return false unless signatures.all? { |signature|
          other.methods.key?(name) && other.methods[name].any? { |other_signature|
            signature <= other_signature
          }
        }
      end
      true
    end

    def super_duck?(other)
      return false if super_duck.nil?
      return false if other.nil?
      return true if super_duck == other
      super_duck.super_duck?(other)
    end

    def add_method_definition(method)
      methods[method.name] ||= []
      methods[method.name] << method
    end
  end
end