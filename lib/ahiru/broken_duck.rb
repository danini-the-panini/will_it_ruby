module Ahiru
  class BrokenDuck < Duck
    def self.instance
      @_instance ||= BrokenDuck.new
    end

    def initialize(*)
    end

    def class_type
      self
    end

    def instance_type
      self
    end

    def class_type?
      false
    end

    def module_type?
      false
    end

    def instance_type?
      true
    end

    def instance_type
      self
    end

    def |(_)
      self
    end

    def free?
      false
    end

    def free_types
      []
    end

    def to_s
      '(Broken)'
    end

    def inspect
      to_s
    end

    def rewrite(_)
      self
    end

    def <=(_)
      true
    end

    def super_duck?(_)
      false
    end

    def add_method_definition(_)
    end

    def add_constant(_, __)
    end

    def const_defined?(_)
      true
    end

    def constant(name)
      T_Object.constant(name) || self
    end

    def find_method(om)
      om
    end

    def could_be_nil?
      false
    end

    def include_module
    end
  end
end