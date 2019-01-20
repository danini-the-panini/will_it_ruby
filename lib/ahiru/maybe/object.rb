module Ahiru
  module Maybe
    class Object
      def initialize(*possiblities)
        @possiblities = possiblities.uniq
      end

      def get_method(name)
        methods = @possiblities.map { |p| p.get_method(name) }
        if methods.any?(&:nil?)
          # TODO: check which one(s) do not have the method?
          nil
        end
        Maybe::Method.new(*methods)
      end
    end
  end
end