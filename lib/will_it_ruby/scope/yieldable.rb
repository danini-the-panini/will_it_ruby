module WillItRuby
  module Yieldable
    def process_yield_expression(*args)
      return super if !block
      check_and_process_yield(args)
    end

    def check_and_process_yield(args)
      call = Call.new(args, self)
      call.process

      error = block.check_call(call)
      if error
        register_issue @current_sexp&.line, error
        BrokenDefinition.new
      else
        process_yield(call)
      end
    end

    def process_yield(call)
      result = call_block(call)

      if block.last_scope.did_return?
        @return_value = v_nil
      end

      result
    end

    def call_block(call)
      block.make_call(self, call, maybe: maybe)
    end
  end
end