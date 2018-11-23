require 'gemologist'

module Gemologist
  class Definition
    def self.add_class_definition(base_class, &block)
      @classes ||= {}
      c = @classes[base_class] = Class.new
      c.intance_eval(&block) if block_given?
      c
    end

    class Class
      attr_reader :base_class

      def initialize(base_class)
        @base_class = base_class
        @instance_methods = {}
        @class_methods = {}
        @contants = {}
      end

      def add_method_definition(name, return_type, argument_types)
        m = (@methods[name] ||= [])
        m << Method.new(self, return_type, argument_types)
      end

      def add_class_method_definition(name, return_type, argument_types)
        m = (@methods[name] ||= [])
        m << Method.new(self, return_type, argument_types)
      end

      def add_constant_definition(name, type)
        @contants[name] ||= type
      end
    end

    class Method
      attr_reader :class_definition, :return_type, :argument_types

      def initialize(class_definition, return_type, argument_types)
        @class_definition = class_definition
        @return_type = return_type
        @argument_types = argument_types
      end

      def match_call?(rt, at)
        return_type.matches?(rt) && at.count == argument_types.count && argument_types.zip(at).all? { |a, b| a.matches?(b)}
      end
    end
  end
end