module Gemologist
  class Callable
    attr_accessor :return_type, :pargs, :kwargs, :block, :free_types

    def initialize(return_type = Duck.new(), pargs = [], kwargs = {}, block = nil, free_types = [])
      @return_type = return_type
      @pargs = pargs
      @kwargs = kwargs
      @block = block
      @free_types = free_types
    end

    def <=(other)
      # puts "pargs_match?(other) -- #{pargs_match?(other)}"
      # puts "kwargs_match?(other) -- #{kwargs_match?(other)}"
      # puts "block_match?(other) -- #{block_match?(other)}"
      pargs_match?(other) && kwargs_match?(other) && block_match?(other)
    end

    protected

    def minimum_required_arguments
      pargs.reject(&:optional?).reject(&:variadic?).count
    end

    def maximum_allowed_arguments
      return Float::INFINITY if pargs.any?(&:variadic?)
      return pargs.count
    end

    private

    def pargs_match?(other)
      return false unless minimum_required_arguments >= other.minimum_required_arguments
      return false unless maximum_allowed_arguments <= other.maximum_allowed_arguments

      match_pargs(pargs, other.pargs)
    end

    def match_pargs(a_pargs, b_pargs)
      return true if a_pargs.empty?
      return false if b_pargs.empty?

      a, *a_rest = a_pargs
      b, *b_rest = b_pargs

      return false unless b <= a

      if a.variadic? && b.variadic?
        true
      elsif b.variadic?
        match_pargs(a_rest, b_pargs)
      elsif a.variadic?
        false
      else
        match_pargs(a_rest, b_rest)
      end
    end

    def kwargs_match?(other)
      return false unless kwargs.keys.all? { |k| other.kwargs.key?(k) }
      return false unless (other.kwargs.keys - kwargs.keys).all? { |k| other.kwargs[k].optional? }

      kwargs.all? { |k,v| other.kwargs[k] <= v }
    end

    def block_match?(other)
      return true if block.nil? && other.block.nil?
      return false if block.nil? || other.block.nil?
      other.block <= block
    end

    def pargs_to_s
      return nil if pargs.empty?
      pargs.map(&:to_s).join(', ')
    end

    def kwargs_to_s
      return nil if kwargs.empty?
      kwargs.map { |k,v| "#{k}: #{v}" }.join(", ")
    end

    def args_to_s
      [pargs, kwargs].compact.join(", ")
    end

    class Argument
      attr_reader :type

      def initialize(type, optional: false, variadic: false)
        @type = type
        @optional = optional
        @variadic = variadic
      end

      def <=(other)
        case other
        when Argument then type <= other.type
        else type <= other
        end
      end

      def optional?
        @optional
      end

      def variadic?
        @variadic
      end
    end
  end
end