module WillItRuby
  class MethodScope < Scope
    attr_reader :block
    include Returnable
    include Yieldable

    def initialize(processor, expressions, parent, self_type, block=nil)
      super(processor, expressions, parent)
      @self_type = self_type
      @block = block
    end

    def process
      super do
        did_return?
      end
      return_value
    end
  end
end