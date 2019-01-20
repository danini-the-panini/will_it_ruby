module Ahiru
  class BakedMethodDefinition < MethodDefinition
    def initialize(name, self_type, args, proc)
      super(name, self_type, args, [], nil, nil)
      @name = name
      @proc = proc
    end

    def call_with_args(*)
      @proc.call
    end
  end
end