module Ahiru
  module Maybe
    class Object
      attr_reader :possiblities

      def initialize(*possiblities)
        @possiblities = flatten(possiblities).uniq
      end

      def get_method(name)
        methods = @possiblities.map do |p|
          Maybe::Method.new(p, p.get_method(name), name)
        end
        Maybe::MethodSet.new(*methods)
      end

      private

      def flatten(things)
        things.flat_map do |thing|
          case thing
          when Maybe::Object
            thing.possiblities
          else
            thing
          end
        end
      end
    end
  end
end