module WillItRuby
  class BlockScope < MethodScope
    def initialize(processor, expressions, parent, yielding, self_type, block=nil)
      super(processor, expressions, parent, self_type, block)
      @yielding = yielding
    end
  end
end