module Ahiru
  class BakedMethodDefinition < MethodDefinition
    def initialize(name, args, proc)
      super(name, args, [], nil, nil)
      @name = name
      @proc = proc
    end

    def call_with_args(*)
      @proc.call
    end
  end
end