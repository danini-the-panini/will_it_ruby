module Ahiru
  class Duck
    attr_reader :name, :super_duck, :generics, :concretes
    attr_accessor :methods

    def initialize(super_duck = nil, name: nil, enclosing_module: nil, generics: [], concretes: [], methods: {}, constants: {}, free: false)
      @name       = name
      @super_duck = super_duck
      @module     = enclosing_module
      @methods    = methods
      @constants  = constants
      @generics   = generics
      @concretes  = concretes
      @free       = free
    end

    def self.define(name, super_duck = nil, generics = [], enclosing_module = nil, &block)
      Duck.new(super_duck, name: name, generics: generics, enclosing_module: enclosing_module).tap do |duck|
        duck.define(&block) if block_given?
      end
    end
    
    def class_type
      @_class_type ||= T_Class[self].tap do |c|
        c.super_duck = super_duck&.class_type || T_Class
      end
    end

    def define(&block)
      d = Definition.new(self)
      d.instance_exec(&block) if block_given?
      self
    end

    def |(other)
      # TODO: union duck type?
      self
    end

    def free?
      @free
    end

    def to_s
      return name unless name.nil?
      "Duck(#{methods.values.flatten.map(&:to_s).join(', ')})"
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

    def add_constant(name, type)
      @constants[name] = type
    end

    def constant_defined?(name)
      @constants.key?(name) ||
      class_type.constant_defined?(name) ||
      @super_duck&.constant_defined?(name) ||
      @enclosing_module&.constant_defined?(name)
    end
    
    def constant(name)
      @constants[name] ||
      class_type.constant(name) ||
      @super_duck&.constant(name) ||
      @enclosing_module&.constant(name)
    end

    def immediate_constant_defined?(name)
      @constants.key?(name) ||
      @super_duck&.immediate_constant_defined?(name)
    end

    def immediate_constant(name)
      @constants[name] ||
      @super_duck&.immediate_constant(name)
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