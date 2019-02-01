module WillItRuby
  module Maybe
    class Method
      attr_reader :receiver_type, :method, :name

      def initialize(receiver_type, method, name)
        @receiver_type = receiver_type
        @method = method
        @name = name
      end

      def make_call(call)
        method.make_call(receiver_type, call)
      end

      def check_args(args)
        return no_method_error if method.nil?
        method.check_args(args)
      end

      def check_call(call)
        return no_method_error if method.nil?
        method.check_call(call)
      end
    
      def resolve_for_scope(scope, truthy, receiver_sexp, call)
        @method.resolve_for_scope(scope, @receiver_type, truthy, receiver_sexp, call)
      end

      private

      def no_method_error
        "Undefined method `#{name}' for #{receiver_type.to_s}"
      end
    end
  end
end