module Ahiru
  module Maybe
    class Method
      def initialize(*possiblities)
        @possiblities = possiblities.uniq
      end

      def make_call(self_type, call)
        return_values = @possiblities.map { |p| p.make_call(self_type, call) }
        Maybe::Object.new(*return_values)
      end

      def check_args(args)
        @possiblities.map { |p| p.check_args(args) }
        if @possiblities.all?(&:nil?)
          nil
        else
          @possiblities.compact.join(', ') # TODO: this is probably not the best thing to do
        end
      end

      def check_call(args)
        @possiblities.map { |p| p.check_call(args) }
        if @possiblities.all?(&:nil?)
          nil
        else
          @possiblities.compact.join(', ') # TODO: this is probably not the best thing to do
        end
      end
    end
  end
end