require "ahiru/standard_library/basic_object"
require "ahiru/standard_library/object"

require "ahiru/standard_library/nil_class"

require "ahiru/standard_library/numeric"
require "ahiru/standard_library/integer"

module Ahiru
  class StandardLibrary
    attr_reader :object_class, :basic_object_class, :v_nil, :v_true, :v_false, :v_bool

    def initialize(processor)
      @processor = processor
      @basic_object_class = ClassDefinition.new(:BasicObject, nil, nil, @processor)
      @object_class       = ClassDefinition.new(:Object, basic_object_class, nil, @processor)
      object_class.add_constant :BasicObject, basic_object_class
      object_class.add_constant :Object,      object_class

      module_class = defclass :Module
      defclass :Class, module_class

      defclass :String
      defclass :Symbol

      numeric = defclass :Numeric
      integer = defclass :Integer, :Numeric
      defclass :Complex,  :Numeric
      defclass :Rational, :Numeric
      defclass :Float,    :Numeric

      nil_class = SingletonClassDefinition.new(:NilClass, object_class, @processor, label: 'nil')
      object_class.add_constant :NilClass, nil_class

      true_class = SingletonClassDefinition.new(:TrueClass, object_class, @processor, label: 'true', value: true)
      object_class.add_constant :TrueClass, true_class
      false_class  = SingletonClassDefinition.new(:FalseClass, object_class, @processor, label: 'false', value: false)
      object_class.add_constant :FalseClass, false_class

      @v_nil   = nil_class.create_instance
      @v_true  = true_class.create_instance
      @v_false = false_class.create_instance
      @v_bool  = Maybe::Object.new(v_true, v_false)

      initialize_basic_object
      initialize_object
      initialize_nil_class(nil_class)
      initialize_numeric(numeric)
      initialize_integer(integer)
    end

    def defclass(name, super_class=object_class)
      ClassDefinition.new(name, super_class, nil, @processor).tap do |c|
        object_class.add_constant(name, c)
      end
    end
  end
end