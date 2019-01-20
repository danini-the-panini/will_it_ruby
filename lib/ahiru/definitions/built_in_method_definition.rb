module Ahiru
  class BuiltInMethodDefinition < MethodDefinition
    def initialize(name, args, precheck: nil, &block)
      super(name, args, [], nil,nil)
      @block = block
      @precheck = precheck
    end

    def make_call(self_type, call)
      # TODO: handle splats/kwsplats
      self_type.instance_exec(*call.pargs, **call.kwargs, &@block)
    end

    def check_call(call)
      return nil if @precheck.nil?
      if @args.takes_kwargs?
        @precheck[*call.pargs, **call.kwargs]
      else
        @precheck[*call.pargs]
      end
    end
  end
end