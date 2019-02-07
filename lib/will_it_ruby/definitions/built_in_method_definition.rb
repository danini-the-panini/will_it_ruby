module WillItRuby
  class BuiltInMethodDefinition < MethodDefinition
    def initialize(name, args, precheck: nil, resolve_for_scope: nil, &block)
      super(name, args, [], nil,nil)
      @block = block
      @precheck = precheck
      @resolve_for_scope = resolve_for_scope
    end

    def make_call(self_type, call, block=nil)
      # TODO: handle splats/kwsplats
      # TODO: handle block
      pargs = call.pargs || []
      pargs << block if block
      kwargs = call.kwargs || {}
      self_type.instance_exec(*pargs, **kwargs, &@block)
    end

    def check_call(call)
      return nil if @precheck.nil?
      if @args.takes_kwargs?
        @precheck[*call.pargs, **call.kwargs]
      else
        @precheck[*call.pargs]
      end
    end

    def resolve_for_scope(scope, self_type, truthy, receiver_sexp, call)
      self_type.instance_exec(scope, truthy, receiver_sexp, *call.pargs, **call.kwargs, &@resolve_for_scope) if @resolve_for_scope
    end
  end
end