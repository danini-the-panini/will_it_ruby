module Ahiru
  class StandardLibrary
    attr_reader :object_class, :basic_object_class, :v_nil, :v_true, :v_false, :v_bool

    def initialize
      @basic_object_class = ClassDefinition.new(:BasicObject, nil, nil)
      @object_class       = ClassDefinition.new(:Object, basic_object_class, nil)
      object_class.add_constant :BasicObject, basic_object_class
      object_class.add_constant :Object,      object_class

      module_class = defclass :Module
      defclass :Class, module_class

      defclass :String
      defclass :Symbol

      defclass :Numeric
      defclass :Integer

      nil_class = SingletonClassDefinition.new(:NilClass, object_class, nil)
      object_class.add_constant :NilClass, nil_class

      true_class = SingletonClassDefinition.new(:TrueClass, object_class, nil)
      object_class.add_constant :TrueClass, true_class
      false_class  = SingletonClassDefinition.new(:FalseClass, object_class, nil)
      object_class.add_constant :FalseClass, false_class

      @v_nil   = nil_class.create_instance
      @v_true  = true_class.create_instance
      @v_false = false_class.create_instance
      @v_bool  = Maybe::Object.new(v_true, v_false)

      install_basic_object
      install_object
    end

    def defclass(name, super_class=object_class)
      ClassDefinition.new(name, super_class, nil).tap do |c|
        object_class.add_constant(name, c)
      end
    end
  end
end