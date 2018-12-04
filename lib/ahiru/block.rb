module Ahiru
  class Block < Callable
    def to_s
      "{ |#{args_to_s}#{simple_block_to_s}| -> #{return_type.to_s} }"
    end

    def dup
      Block.new(return_type, pargs.map(&:dup), kwargs.transform_values(&:dup), block.dup, free_types)
    end

    private

    def simple_block_to_s
      return '' if block.nil?
      ", &block"
    end
  end
end