require "will_it_ruby/standard_library/basic_object"
require "will_it_ruby/standard_library/object"
require "will_it_ruby/standard_library/class"

require "will_it_ruby/standard_library/nil_class"
require "will_it_ruby/standard_library/true_class"
require "will_it_ruby/standard_library/false_class"

require "will_it_ruby/standard_library/numeric"
require "will_it_ruby/standard_library/integer"

require "will_it_ruby/standard_library/string"
require "will_it_ruby/standard_library/array"

module WillItRuby
  class StandardLibrary
    attr_reader :object_class, :basic_object_class, :v_nil, :v_true, :v_false, :v_bool

    def initialize(processor)
      @processor = processor
      @basic_object_class = ClassDefinition.new(:BasicObject, nil, nil, @processor)
      @object_class       = ClassDefinition.new(:Object, basic_object_class, nil, @processor)
      object_class.add_constant :BasicObject, basic_object_class
      object_class.add_constant :Object,      object_class

      module_class = defclass :Module
      class_class  = defclass :Class, module_class

      string = defclass :String
      defclass :Symbol

      numeric = defclass :Numeric
      integer = defclass :Integer, numeric
      defclass :Complex,  numeric
      defclass :Rational, numeric
      defclass :Float,    numeric

      nil_class = SingletonClassDefinition.new(:NilClass, object_class, @processor, label: 'nil')
      object_class.add_constant :NilClass, nil_class

      true_class = SingletonClassDefinition.new(:TrueClass, object_class, @processor, label: 'true', value: true)
      object_class.add_constant :TrueClass, true_class
      false_class  = SingletonClassDefinition.new(:FalseClass, object_class, @processor, label: 'false', value: false)
      object_class.add_constant :FalseClass, false_class

      array = defclass :Array, definition_class: ArrayClassDefinition

      @v_nil   = nil_class.create_instance
      @v_true  = true_class.create_instance
      @v_false = false_class.create_instance
      @v_bool  = Maybe::Object.from_possibilities(v_true, v_false)

      initialize_basic_object
      initialize_object
      initialize_class(class_class)
      initialize_nil_class(nil_class)
      initialize_true_class(true_class)
      initialize_false_class(false_class)
      initialize_numeric(numeric)
      initialize_integer(integer)
      initialize_string(string)
      initialize_array(array)
    end

    private

    def defclass(name, super_class=object_class, definition_class: ClassDefinition)
      definition_class.new(name, super_class, @processor.main_scope, @processor).tap do |c|
        object_class.add_constant(name, c)
      end
    end
  end
end