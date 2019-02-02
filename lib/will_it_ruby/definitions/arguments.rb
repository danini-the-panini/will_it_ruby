require "will_it_ruby/definitions/arguments/argument"
require "will_it_ruby/definitions/arguments/call"
require "will_it_ruby/definitions/arguments/block"

module WillItRuby
  class Arguments
    def initialize(args_sexp)
      @pargs = []
      @kwargs = {}
      @vparg = nil
      @vkwarg = nil

      _, *args = args_sexp
      symbols, sexps = args.partition { |a| a.is_a?(Symbol) }
      lasgs, kwargs = sexps.partition { |a| a.first == :lasgn }
      required_pargs = symbols.select { |s| s.to_s[0] != '*' }
      required_pargs.each do |p|
        @pargs << Argument.new(p)
      end
      lasgs.each do |l|
        @pargs << Argument.new(l[1], l[2])
      end
      kwargs.each do |k|
        @kwargs[k[1]] = Argument.new(k[1], k[2])
      end

      @vparg  = make_varg(symbols.find { |s| s.to_s =~ /\A\*([^\*]|\z)/ }, s(:array))
      @vkwarg = make_varg(symbols.find { |s| s.to_s =~ /\A\*\*/    }, s(:hash))
    end

    def check_call(in_args)
      pargs = in_args
      in_kwargs = s(:hash)
      if in_args.last&.first == :hash && takes_kwargs?
        *pargs, in_kwargs = in_args
      end
      _, *kwarg_entries = in_kwargs
      splats, nargs = pargs.partition { |p| p.first == :splat }

      errors = []

      if splats.empty? && !(min_count..max_count).cover?(nargs.count)
        errors << "given #{nargs.count}, expected #{count_string}"
      end

      if takes_kwargs?
        kwsplats, kwarg_pairs = kwarg_entries.partition { |k| k.first == :kwsplat }
        # TODO: check that all the keys are symbols
        kwarg_hash = kwarg_pairs.each_slice(2).to_h.transform_keys { |k| k[1] }

        if kwsplats.empty?
          missing_keys = required_keywords - kwarg_hash.keys
          if !missing_keys.empty?
            errors << "missing required keywords: #{missing_keys.join(', ')}"
          end
        end

        extra_keys = kwarg_hash.keys - allowed_keywords
        if !extra_keys.empty?
          errors << "unknown keywords: #{extra_keys.join(', ')}"
        end
      end

      return nil if errors.empty?
      "Wrong number of arguments (#{errors.join "; "})"
    end

    def evaluate_call(call, method_scope)
      result = {}

      # TODO: handle splats, both incoming and outgoing

      @pargs.zip(call.pargs).each do |(l,r)|
        result[l.name] = r || method_scope.process_expression(l.default)
      end

      @kwargs.each do |k,v|
        result[k] = call.kwargs[k] || method_scope.process_expression(v.default)
      end

      result
    end

    def assign_arguments_to_scope(call, method_scope)
      evaluate_call(call, method_scope).each do |k, v|
        method_scope.local_variable_set(k, v)
      end
    end

    def min_count
      @pargs.count(&:required?)
    end

    def max_count
      variadic? ? Float::INFINITY : @pargs.count
    end

    def required_keywords
      @kwargs.select { |k, v| v.required? }.keys
    end

    def allowed_keywords
      @kwargs.keys
    end

    def count_string
      if !variadic?
        if min_count == max_count
          "#{min_count}"
        else
          "#{min_count}..#{max_count}"
        end
      else
        "#{min_count}+"
      end
    end

    def takes_kwargs?
      !@kwargs.empty? || varikwardic?
    end

    def variadic?
      !@vparg.nil?
    end

    def varikwardic?
      !@vkwarg.nil?
    end

    private

    def remove_asterisks(sym)
      return nil if sym.nil?
      sym.to_s.gsub('*', '').to_sym
    end

    def make_varg(arg, default)
      return nil if arg.nil?
      name = remove_asterisks(arg)
      Argument.new(name.empty? ? nil : name, default)
    end
  end
end