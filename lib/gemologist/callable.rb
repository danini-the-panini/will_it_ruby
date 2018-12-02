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
      pargs_match?(other) && kwargs_match?(other) && block_match?(other)
    end

    def resolve(ps = [], ks = {}, block = nil, ft = [], ftv = {})
      call = Call.new(ps, ks, block)
      Resolution.new(self, call, [*free_types, *ft], ftv).perform
    end

    def free_type?(t)
      free_types.include?(t)
    end

    def to_s
      "(#{args_to_s}) #{block ? "#{block.to_s} " : ''}-> #{return_type.to_s}"
    end

    def dup
      Callable.new(return_type, pargs.map(&:dup), kwargs.transform_values(&:dup), block.dup, free_types)
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
      [pargs_to_s, kwargs_to_s].compact.join(", ")
    end

    class Argument
      attr_accessor :type

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

      def to_s
        "#{variadic? ? '*' : ''}#{type.to_s}#{optional? ? '?' : ''}"
      end

      def dup
        Argument.new(type, optional: optional?, variadic: variadic?)
      end
    end

    class Call
      attr_reader :pargs, :kwargs, :block

      def initialize(pargs = [], kwargs = {}, block = nil)
        @pargs = pargs
        @kwargs = kwargs
        @block = block
      end
    end

    class Resolution
      attr_reader :callable, :call, :free_types, :free_type_values

      def initialize(callable, call, free_types = callable.free_types, free_type_values = {})
        @callable = callable
        @call = call
        @free_types = free_types
        @last_free_type_values = free_type_values
        @free_type_values = free_type_values
      end

      def perform
        resolve_pargs_until_finished
        if free_type?(callable.return_type)
          @free_type_values[callable.return_type]
        else
          callable.return_type
        end
      end

      def resolve_pargs_until_finished
        @last_free_type_values = @free_type_values
        resolve_pargs(callable.pargs, call.pargs)
        resolve_block unless callable.block.nil?

        # puts
        # puts callable.to_s
        # puts ">>> values = #{@free_type_values.transform_keys(&:to_s).transform_values(&:to_s)}"
        # puts

        if @free_type_values.count < free_types.count && @last_free_type_values.count < @free_type_values.count
          resolve_pargs_until_finished
        end
      end

      def resolve_pargs(m_pargs, c_pargs)
        # puts
        # puts callable.to_s
        # puts "> resolve_pargs(#{m_pargs.map(&:to_s)}, #{c_pargs.map(&:to_s)})"
        # puts

        return if m_pargs.empty? || c_pargs.empty?

        m, *m_rest = m_pargs
        c, *c_rest = c_pargs

        new_values = resolve(m.type, c, free_types, @free_type_values)
        @free_type_values = new_values

        resolve_pargs(m_rest, c_rest)
      end

      def resolve_block
        # puts
        # puts callable.to_s
        # puts "> resolve_block #{callable.block} --- #{call.block}, #{free_types.map(&:to_s)}, #{free_type_values.transform_keys(&:to_s).transform_values(&:to_s)}"
        # puts
        block_return = call.block.resolve(callable.block.pargs.map(&:type), callable.kwargs.transform_values(&:type), callable.block.block, free_types, free_type_values)

        if free_type?(callable.block.return_type)
          @free_type_values.merge!(callable.block.return_type => block_return)
        end
      end

      def resolve(generic_type, concrete_type, free_types, free_type_values)
        # puts
        # puts callable.to_s
        # puts "> resolve(#{generic_type.to_s}, #{concrete_type.to_s}, #{free_types.map(&:to_s)}, #{free_type_values.transform_keys(&:to_s).transform_values(&:to_s)})"
        # puts

        if free_types.include?(generic_type)
          return free_type_values.merge({ generic_type => value_for_free_type(concrete_type) })
        end

        generic_type.methods.values.flatten.each do |method|
          gm = rewrite_method_free_variables(method)
          matching_method = concrete_type.methods[method.name].find { |cm|
            gm <= cm
          }

          next if matching_method.nil?

          free_type_values = resolve(method.return_type, matching_method.return_type, free_types, free_type_values)
        end

        free_type_values
      end

      def rewrite_method_free_variables(method)
        return nil if method.nil?

        method.dup.tap do |m|
          m.return_type = value_for_free_type(m.return_type)

          m.pargs.each { |a| a.type = value_for_free_type(a.type) }
          m.kwargs.each { |_,a| a.type = value_for_free_type(a.type) }
          m.block = rewrite_method_free_variables(m.block)
        end
      end

      def value_for_free_type(t)
        @free_type_values[t] || t
      end

      def free_type?(t)
        free_types.include?(t)
      end
    end
  end
end