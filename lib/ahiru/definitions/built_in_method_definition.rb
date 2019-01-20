module Ahiru
  class BuiltInMethodDefinition < MethodDefinition
    def initialize(name, args, &block)
      super(name, args, [], nil,nil)
      @block = block
    end

    def make_call(self_type, call)
      # TODO: handle splats/kwsplats
      self_type.instance_exec(*call.pargs, **call.kwargs, &@block)
    end
  end
end