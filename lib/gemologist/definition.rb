require 'gemologist'

module Gemologist
  class Definition
    def self.add_class_definition(base_class, *generics, &block)
      @classes ||= {}
      c = @classes[base_class] = Class.new(base_class, *generics)
      c.intance_eval(&block) if block_given?
      c
    end

    class Class
      attr_reader :base_class, :generics, :instance_methods, :class_methods, :constants

      def initialize(base_class, *generics)
        @base_class = base_class
        @generics = generics
        @instance_methods = {}
        @class_methods = {}
        @constants = {}
      end

      def add_method_definition(name, sig = [] => Nil, block_sig = nil)
        m = (@methods[name] ||= [])
        m << method_from_sig(sig, block_sig)
      end

      def add_class_method_definition(name, return_type, argument_types)
        m = (@class_methods[name] ||= [])
        m << method_from_sig(sig, block_sig)
      end

      def add_constant_definition(name, type)
        @constants[name] ||= type
      end

      private

      def method_from_sig(sig, block_sig = nil)
        args, kwargs, return_type = args_from_sig(sig)

        args, return_type = sig.first
        kwargs = {}
        if args.last.is_a?(Hash)
          kwargs = args.last
          args = args.take(args.size - 1)
        end
        block_args, _, block_return_type = args_from_sig(block_sig)
        Method.new(self, return_type, args, kargs, block_args, block_return_type)
      end

      def args_from_sig(sig)
        return nil, nil, nil if sig.nil?

        case sig
        when Hash
          args, return_type = sig.first
          pargs, kwargs = kwargs_from_args(args)
          args, kwargs, return_type
        when Array
          pargs, kwargs =  kwargs_from_args(sig)
          pargs, kwargs, Nil
        else
          [], {}, sig
        end
      end

      def kwargs_from_args(args)
        case args
        when Array
          pargs = args
          kwargs = {}
          if args.last.is_a?(Hash)
            kwargs = args.last
            pargs = args.take(args.size - 1)
          end
          pargs, kwargs
        when Hash
          [], args
        else
          [args], {}
        end
      end
    end

    class Method
      attr_reader :class_definition, :return_type, :argument_list, :kwarg_types, :block_type

      def initialize(class_definition, return_type, argument_types = [], kwarg_types = {}, block_argument_types = nil, block_return_type = nil)
        @class_definition = class_definition
        @return_type = return_type
        @argument_list = ArgumentList.new(argument_types)
        @kwarg_types = kwarg_types
        if !block_argument_types.nil?
          @block_type = Block.new(block_argument_types, block_return_type)
        end
      end

      def match_call?(at, kt = {}, bat = nil, brt = nil)
        return false unless argument_list.match?(at)
        if requires_block?
          return false if bat.nil? || brt.nil?
          return false unless block_type.match?(bat, brt)
        else
          return false unless bat.nil? && brt.nil?
        end
        return true
      end

      def requires_block?
        !block_type.nil?
      end
    end

    class Block
      attr_reader :return_type, :argument_list
      def initialize(return_type, argument_types = [])
        @return_type = return_type
        @argument_list = ArgumentList.new(argument_types)
      end

      def match?(at, rt)
        return false unless return_type.matches?(rt)
        argument_list.match?(at)
      end
    end

    class ArgumentList
      def initialize(types)
        @types = types
      end

      def matches_count?(args)
        at.count >= minimum_count_required || at <= maximum_count_allowed
      end

      def matches?(args)
        return false unless matches_count?(args)
        return true if args.empty? && minimum_count_required.zero?

        rest = self.consume(args)
        return false if rest.nil?

        rest.matches?(args.drop(1))
      end

      def minimum_count_required
        argument_types.reject(&:optional).reject(&:variadic).count
      end

      def maximum_count_allowed
        argument_types.any?(&:variadic) ? Float::INFINITY : argument_types.count
      end

      def consume(arg)
        type = types.first

        return nil unless type.matches?(arg)

        if type.variadic?
          return self
        else
          return ArgumentList.new(types.drop(1))
        end
      end
    end
  end
end