module WillItRuby
  class MethodScope < Scope
    include Returnable

    def initialize(processor, expressions, parent, self_type)
      super(processor, expressions, parent)
      @self_type = self_type
    end

    def process
      super do
        did_return?
      end
      return_value
    end
  end
end