module WillItRuby
  class OverloadedMethodDefinition < MethodDefinition
    def initialize(name, overloads)
      super(name, s(:args), [], nil,nil)
      @overloads = overloads
    end

    def make_call(self_type, call)
      find_matching_call.make_call(self_type, call)
    end

    def check_args(args)
      calls = @overloads.map { |o| o.check_args(args) }
      if calls.any?
        calls.compact.last
      else
        nil
      end
    end

    def check_call(call)
      calls = @overloads.map { |o| o.check_call(call) }
      if calls.any?
        calls.compact.last
      else
        nil
      end
    end
    
    def resolve_for_scope(scope, self_type, truthy, receiver_sexp, call)
      # TODO
    end

    private

    def find_matching_call(call)
      @overloads.find { |o| check_args(call.args).nil? && check_call(call).nil? }
    end
  end
end