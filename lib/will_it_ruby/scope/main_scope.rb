module WillItRuby
  class MainScope < Scope
    def initialize(processor, expressions)
      super(processor, expressions, nil)
      @self_type = MainObjectInstance.new(processor)
    end

    def register_issue(line, message)
      processor.register_issue Issue.new('(main)', line, message)
    end

    def ivar_hash
      self_type.ivar_hash
    end
  end
end