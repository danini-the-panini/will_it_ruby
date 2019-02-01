module WillItRuby
  class Call
    attr_reader :args, :pargs, :kwargs, :splats, :kwsplats

    def initialize(args, scope)
      @scope = scope
      @args = args
    end

    def process
      args = @args
      kwarg_exp = s(:hash)
      if args.last&.first == :hash
        *args, kwarg_exp = @args
      end

      @pargs, @splats = pargs_and_splats(args)
      _, *kwarg_entries = kwarg_exp
      kwsplats, kwarg_pairs = kwarg_entries.partition { |x| x.first == :kwsplat }
      @kwargs = kwarg_pairs.each_slice(2).to_h
        .transform_keys{ |k| k[1] }
        .transform_values { |v| @scope.process_expression(v) }
      @kwsplats = kwsplats.map { |x| @scope.process_expression(x[1]) }
    end

    private

    def pargs_and_splats(args)
      splats, not_splats = args.partition { |a| a.first == :splat }
      pargs = not_splats.map { |x| @scope.process_expression(x) }
      splats = splats.map { |x| @scope.process_expression(x[1]) }
      return pargs, splats
    end
  end
end