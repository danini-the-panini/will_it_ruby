module Ahiru
  module Maybe
    class Method
      def initialize(*possiblities)
        @possiblities = possiblities.uniq
      end

      def call_with_args(self_type, args)
        return_values = @possiblities.map { |p| p.call_with_args(self_type, args) }
        Maybe::Object.new(*return_values)
      end

      def check_call_with_args(args)
        @possiblities.map { |p| p.check_call_with_args(args) }
        if @possiblities.all?(&:nil?)
          nil
        else
          @possiblities.compact.join(', ') # TODO: this is probably not the best thing to do
        end
      end
    end
  end
end