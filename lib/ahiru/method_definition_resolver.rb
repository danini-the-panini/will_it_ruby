module Ahiru
  class MethodDefinitionResolver
    attr_reader :malleable_ducks

    def initialize(name, args_exp, expressions, parent_scope)
      @name = name
      @args_exp = args_exp
      @expressions = expressions
      @parent_scope = parent_scope
      @malleable_ducks = []
      @scope = MethodScope.new(parent_scope.world, parent_scope.t_self.instance_type, parent_scope, parent_scope)
    end

    def resolve
      pargs, kwargs, block = process_definition_args(@args_exp[1..-1])

      pargs.each do |a|
        @scope.local_variables[a.name] = a.type
      end
      kwargs.each do |k,v|
        @scope.local_variables[k] = a.type
      end

      @expressions.each do |e|
        @scope.process_expression(e)
      end

      free_types = @malleable_ducks.reduce([]) { |a,b| a | b.free_types }

      final_return_type = @scope.return_type.to_duck
      final_pargs = pargs.map { |a| Callable::Argument.new(a.type.to_duck, name: a.name, optional: a.optional?, variadic: a.variadic?) }
      final_kwargs = kwargs.transform_values { |a| Callable::Argument.new(a.type.to_duck, name: a.name, optional: a.optional?, variadic: a.variadic?) }
      final_block = block&.to_block

      Method.new(@scope.t_self, @name, final_return_type, final_pargs, final_kwargs, final_block, free_types)
    end

    private

    def process_definition_args(args)
      pargs = []
      kwargs = {}
      block = nil

      args.each do |b|
        if b.is_a?(Symbol)
          case b.to_s
          when /\A&/
            n = b.to_s[0..-1]
            block = Block.new(T_Any, [Callable::Argument.new(T_Any, name: n.to_sym, variadic: true)])
          when /\A\*\*/
            # TODO: allow callables to have a kwsplat
          when /\A\*/
            n = b.to_s[0..-1]
            pargs << Callable::Argument.new(MalleableDuck.new(self, name: b.to_s[0..-1].upcase), name: n.to_sym, variadic: true)
          else
            pargs << Callable::Argument.new(MalleableDuck.new(self, name: b.to_s.upcase), name: b)
          end
        else
          n = b[1]
          case b[0]
          when :kwarg
            optional = b.length > 2
            kwargs[n] = Callable::Argument.new(MalleableDuck.new(self, name: n.to_s), name: n, optional: optional)
          when :lasgn
            pargs << Callable::Argument.new(MalleableDuck.new(self, name: n.to_s.upcase), name: n, optional: true)
          end
        end
      end

      [pargs, kwargs, block]
    end
  end

  class MalleableDuck < Duck
    def initialize(resolver, name:)
      super(name: name)
      @resolver = resolver
      @resolver.malleable_ducks << self
    end

    def to_duck
      @_duck ||= begin
        if free?
          Duck.new(name: name, free: true)
        else
          Duck.new(name: name, methods: methods.transform_values { |v| v.map(&:to_method) })
        end
      end
    end

    def free?
      methods.empty?
    end

    def free_types
      @_free_types ||= begin
        if free?
          [self.to_duck]
        else
          methods.values.flatten.reduce([]) { |a,b| a | b.free_types }
        end
      end
    end
    
    def find_method(om)
      m = super
      return m unless m.nil?

      m = MalleableMethod.new(self, om.name, MalleableDuck.new(@resolver, name: "#{om.name.upcase}_R"), om.pargs, om.kwargs, om.block)
      m.extend(MalleableCallable)
      @methods[om.name] ||= []
      @methods[om.name] << m
      m
    end

    def to_s
      "~#{super}"
    end

    def inspect
      "~#{super}"
    end
  end

  module MalleableCallable
    def new_pargs
      pargs.map { |a| Callable::Argument.new(a.type.to_duck, optional: a.optional?, variadic: a.variadic?) }
    end

    def new_kwargs
      kwargs.transform_values { |v| Callable::Argument.new(v.type.to_duck, optional: v.optional?) }
    end

    def new_return_type
      return_type.to_duck
    end

    def free_types
      pargs.map(&:type).flat_map(&:free_types) | kwargs.values.map(&:type).flat_map(&:free_types) | return_type.free_types | (block&.free_types || [])
    end

    def to_s
      "~#{super}"
    end

    def inspect
      "~#{super}"
    end
  end

  class MalleableBlock < Block
    include MalleableCallable

    def to_block
      Block.new(new_return_type, new_pargs, new_kwargs, block&.to_block)
    end
  end

  class MalleableMethod < Method
    include MalleableCallable

    def to_method
      Method.new(scope, name, new_return_type, new_pargs, new_kwargs, block&.to_block)
    end
  end

  class UnknownDuck < MalleableDuck
  end

  class UnknownMethod < MalleableMethod
  end
end