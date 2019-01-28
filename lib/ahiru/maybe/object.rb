module Ahiru
  module Maybe
    class Object
      attr_reader :possibilities

      def self.from_possibilities(*possibilities)
        uniq_possibilities = flatten(possibilities).uniq
        if uniq_possibilities.count == 1
          uniq_possibilities.first
        else
          new(*uniq_possibilities)
        end
      end

      def initialize(*possibilities)
        @possibilities = possibilities
      end

      def get_method(name)
        methods = @possibilities.map do |p|
          Maybe::Method.new(p, p.get_method(name), name)
        end
        Maybe::MethodSet.new(*methods)
      end

      def check_is_a(other)
        results = @possibilities.map(&:check_is_a)
        return true if results.all? { |x| x == true }
        return false if results.all? { |x| x == false }
        nil
      end

      def maybe_truthy?
        @possibilities.any?(&:maybe_truthy?)
      end

      def maybe_falsey?
        @possibilities.any?(&:maybe_falsey?)
      end

      def definitely_truthy?
        @possibilities.all?(&:definitely_truthy?)
      end

      def definitely_falsey?
        @possibilities.all?(&:definitely_falsey?)
      end

      private

      def self.flatten(things)
        things.flat_map do |thing|
          case thing
          when Maybe::Object
            thing.possibilities
          else
            thing
          end
        end
      end
    end
  end
end