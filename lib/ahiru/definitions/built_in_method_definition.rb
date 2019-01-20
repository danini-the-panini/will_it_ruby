module Ahiru
  class BuiltInMethodDefinition < MethodDefinition
    def initialize(name, args, &block)
      super(name, args, [], nil,nil)
      @block = block
    end

    def call_with_args(self_type, args)
      self_type.instance_exec(*args, &@block)
    end
  end
end