module Ahiru
  module Maybe
    class Object
      attr_reader :possiblities

      def initialize(*possiblities)
        @possiblities = possiblities.uniq
      end

      def get_method(name)
        methods = @possiblities.map do |p|
          Maybe::Method.new(p, p.get_method(name), name)
        end
        Maybe::MethodSet.new(*methods)
      end
    end
  end
end