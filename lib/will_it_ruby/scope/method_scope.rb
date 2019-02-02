module WillItRuby
  class MethodScope < Scope
    include Returnable

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

    protected

    def process_yield_expression(*args)
      return super if !@block

      call = Call.new(args, self)
      call.process

      error = @block.check_args(args)
      # TODO: this is ridiculous. need to consolidate check_args and check_call
      if error
        register_issue @current_sexp&.line, error
        BrokenDefinition.new
      else
        error = @block.check_call(call)
        if error
          register_issue @current_sexp&.line, error
          BrokenDefinition.new
        else
          @block.make_call(self_type, self, call)
        end
      end
    end
  end
end