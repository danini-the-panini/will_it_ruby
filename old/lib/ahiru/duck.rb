module Ahiru
  class Duck
    attr_reader :name, :super_duck, :generics, :concretes
    attr_accessor :methods

    def initialize(super_duck = nil, name: nil, enclosing_module: nil, generics: [], concretes: [], methods: {}, constants: {}, included_modules: [], free: false)
      @name             = name
      @super_duck       = super_duck
      @methods          = methods
      @constants        = constants
      @generics         = generics
      @concretes        = concretes
      @enclosing_module = enclosing_module
      @included_modules = included_modules
      @free             = free
    end

    def self.define(name, super_duck = nil, generics = [], enclosing_module = nil, &block)
      Duck.new(super_duck, name: name, generics: generics, enclosing_module: enclosing_module).tap do |duck|
        duck.define(&block) if block_given?
      end
    end
    
    def class_type
      return T_Class if class_type? || module_type?
      @_class_type ||= T_Class[self].tap do |c|
        c.super_duck = super_duck&.class_type || T_Class
      end
    end

    def instance_type
      return unless class_type?
      self.concretes.first
    end

    def class_type?
      self == T_Class || super_duck&.class_type?
    end

    def module_type?
      (self == T_Module || super_duck&.module_type?) && !class_type?
    end

    def instance_type?
      !class_type? && !module_type?
    end

    def define(&block)
      d = Definition.new(self)
      d.instance_exec(&block) if block_given?
      self
    end

    def |(other)
      case other
      when Duck
        return self if other == self
        return self if self <= other
        return other if other <= self
        Union.new([self, other])
      when Union
        other | self
      when BrokenDuck
        other
      end
    end

    def free?
      @free
    end

    def free_types
      if free?
        [self]
      else
        generics.zip(concretes).flat_map do |g,c|
          if c.nil?
            g
          else
            g.free_types
          end
        end.compact
      end
    end

    def to_s
      return name unless name.nil?
      "🦆(#{methods.values.flatten.map(&:to_s).join(', ')})"
    end

    def inspect
      "#{name}(#{methods.values.flatten.map(&:to_s).join(', ')})"
    end

    def rewrite(free_type_values)
      @_rewrites ||= {}
      return @_rewrites[free_type_values] if @_rewrites[free_type_values]

      new_generics = generics.reject { |t|
        ft = free_type_values[t]
        ft && !ft.free?
      }

      new_concretes = [*concretes, *generics.map { |t| free_type_values[t] }].compact.uniq

      Duck.new(self, name: "#{name}<#{free_type_values.values.map(&:to_s).join(', ')}>", generics: new_generics, concretes: new_concretes).tap do |new_duck|
        @_rewrites[free_type_values] = new_duck
        new_duck.methods = methods.transform_values { |ms| ms.map { |m| m.rewrite(free_type_values) } }
      end
    end

    def [](*gen_types)
      rewrite(generics.zip(gen_types).to_h.compact)
    end

    def <=(other)
      return false if other.nil?

      if other.is_a?(Union)
        return other.types.all? { |t| self <= t }
      end

      return true if other == self 
      return true if self <= other.super_duck
      return false if super_duck?(other)

      return false unless methods.keys.all? { |m| other.methods.key?(m) }

      methods.each do |name, signatures|
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

    def add_constant(name, type)
      if instance_type?
        class_type.add_constant(name, type)
      else
        @constants[name] = type
      end
    end

    def constant_defined?(name)
      if instance_type?
        return class_type.constant_defined?(name) || @super_duck&.constant_defined?(name)
      end
      @constants.key?(name) || @enclosing_module&.constant_defined?(name)
    end
    
    def constant(name)
      if instance_type?
        return class_type.constant(name) || @super_duck&.constant(name)
      end
      @constants[name] || @enclosing_module&.constant(name)
    end

    def immediate_constant_defined?(name)
      return false if instance_type?
      @constants.key?(name) || @super_duck&.immediate_constant_defined?(name)
    end

    def immediate_constant(name)
      return if instance_type?
      @constants[name] || @super_duck&.immediate_constant(name)
    end

    def find_method(om)
      ms = @methods[om.name]
      if ms.nil? || ms.empty?
        @included_modules.each do |mod|
          m = mod.find_method(om)
          return m if m
        end
        return nil if super_duck.nil?
        return super_duck.find_method(om)
      end
      ms.find { |m| om <= m }
    end

    def find_method_by_call(name, pargs = [], kwargs = {}, block = nil)
      om = Method.new(self, name, T_Any, pargs.map { |a| Callable::Argument.new(a) }, kwargs.transform_values { |v| Callable::Argument.new(v) }, block)
      find_method(om)
    end

    def normalize
      self
    end

    def to_duck
      self
    end

    def could_be_nil?
      return true if self == T_Nil
      return true if free?
      false
    end

    def include_module(module_duck)
      # TODO: check if all methods are compatible with this object?
      @included_modules << module_duck
    end

    protected
    attr_writer :super_duck

    class Definition
      def initialize(duck)
        @duck = duck
      end

      def t_self
        @duck
      end

      def m(name, sig = { [] => Nil })
        @duck.add_method_definition(method_from_sig(name, sig, (yield if block_given?)))
      end

      def c(name, type)
        @duck.add_constant(name, type)
      end

      def a(type)
        Callable::Argument.new(type)
      end

      def o(type)
        Callable::Argument.new(type, optional: true)
      end

      def v(type)
        Callable::Argument.new(type, variadic: true)
      end

      private

      def method_from_sig(name, sig, block_sig = nil)
        args, kwargs, return_type = args_from_sig(sig)
        
        free_types = args.map(&:type).select(&:free?)
        free_types += kwargs.values.map(&:type).select(&:free?)
        free_types << return_type if return_type.free?

        block = if block_sig
                  blargs, blkwargs, blreturn = args_from_sig(block_sig)

                  free_types = blargs.map(&:type).select(&:free?)
                  free_types += blkwargs.values.map(&:type).select(&:free?)
                  free_types << blreturn if blreturn.free?

                  Block.new(blreturn, blargs, blkwargs)
                end

        Method.new(@duck, name, return_type, args, kwargs, block, free_types.uniq)
      end

      def args_from_sig(sig)
        return [nil, nil, nil] if sig.nil?

        case sig
        when Hash
          args, return_type = sig.first
          pargs, kwargs = kwargs_from_args(args)
          [pargs.map { |a| as_arg(a) }, kwargs.transform_values { |a| as_arg(a) }, return_type]
        when Array
          pargs, kwargs = kwargs_from_args(sig)
          [pargs.map { |a| as_arg(a) }, kwargs.transform_values { |a| as_arg(a) }, Nil]
        else
          [[], {}, sig]
        end
      end

      def kwargs_from_args(args)
        case args
        when Array
          pargs = args
          kwargs = {}
          if args.last.is_a?(Hash)
            *pargs, kwargs = args
          end
          [pargs, kwargs]
        when Hash
          [[], args]
        else
          [[args], {}]
        end
      end

      def as_arg(type)
        case type
        when Callable::Argument
          type
        else
          Callable::Argument.new(type)
        end
      end
    end
  end
end