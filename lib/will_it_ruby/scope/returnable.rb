module WillItRuby
  module Returnable
    attr_reader :partial_return

    def return_value
      rt = @return_value || @last_evaluated_result
      if !@partial_return.nil?
        rt.nil? ? @partial_return : rt | @partial_return
      else
        rt
      end
    end

    def handle_return(processed_value)
      @return_value = processed_value
    end

    def handle_partial_return(processed_value)
      if @partial_return.nil?
        @partial_return = processed_value
      else
        @partial_return |= processed_value
      end
    end

    def did_return?
      !@return_value.nil?
    end

    def did_partially_return?
      !did_return? && !@partial_return.nil?
    end

    def did_not_return?
      !did_return? && !did_partially_return?
    end
  end
end