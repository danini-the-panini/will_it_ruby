module Ahiru
  class World
    def initialize
      @listeners = {}
      @root_scope = MainScope.new self
    end

    def process_expression(sexp)
      @root_scope.process_expression(sexp)
    end

    def fire_event(event, data = {})
      blocks = @listeners[event]
      return if blocks.nil?
      blocks.each do |block|
        block.call(data)
      end
    end

    def add_listener(event, &block)
      @listeners[event] ||= []
      @listeners[event] << block
      block
    end

    def remove_listener(event, block)
      @listeners[event]&.delete(block)
    end
  end
end

# events
# class defined
# module defined
# method defined
# constant defined
# ivar/cvar/lvar/gvar defined