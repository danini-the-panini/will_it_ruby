module Gemologist
  class Block < Callable
    def to_s
      "{ |#{args_to_s}#{simple_block_to_s}| -> #{return_type.to_s} }"
    end

    private

    def simple_block_to_s
      return '' if block.nil?
      ", &block"
    end
  end
end