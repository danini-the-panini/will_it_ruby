module WillItRuby
  module Maybe
    class MethodSet
      attr_reader :possibilities

      def initialize(*possibilities)
        @possibilities = possibilities.uniq
      end

      def make_call(self_type, call, block=nil)
        return_values = @possibilities.map { |p| p.make_call(call, block) }
        Maybe::Object.from_possibilities(*return_values)
      end

      def check_args(args)
        errors = @possibilities.map { |p| p.check_args(args) }
        if errors.all?(&:nil?)
          nil
        else
          errors.compact.join(', ') # TODO: this is probably not the best thing to do
        end
      end

      def check_call(call)
        errors = @possibilities.map { |p| p.check_call(call) }
        if errors.all?(&:nil?)
          nil
        else
          errors.compact.join(', ') # TODO: this is probably not the best thing to do
        end
      end
    
      def resolve_for_scope(scope, self_type, truthy, receiver_sexp, call)
        @possibilities.map { |p| p.resolve_for_scope(scope, truthy, receiver_sexp, call) }
      end
    end
  end
end