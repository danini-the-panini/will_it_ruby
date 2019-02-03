module WillItRuby
  module Maybe
    class Object
      attr_reader :possibilities

      def self.from_possibilities(*possibilities)
        uniq_possibilities = normalize(possibilities)
        case uniq_possibilities.count 
        when 0
          ImpossibleDefinition.new
        when 1
          uniq_possibilities.first
        else
          new(*uniq_possibilities)
        end
      end

      def processor
        possibilities.first.processor
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

      def has_method?(name)
        @possibilities.all? { |p| p.has_method?(name) }
      end

      def check_is_a(other)
        results = @possibilities.map { |p| p.check_is_a(other) }
        return true if results.all? { |x| x == true }
        return false if results.all? { |x| x == false }
        nil
      end

      def value_known?
        false
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

      def resolve_truthy
        truthy_possibilities = @possibilities.select(&:maybe_truthy?)
        return nil if truthy_possibilities.count == @possibilities.count
        Maybe::Object.from_possibilities(*truthy_possibilities)
      end

      def resolve_falsey
        falsey_possibilities = @possibilities.select(&:maybe_falsey?)
        return nil if falsey_possibilities.count == @possibilities.count
        Maybe::Object.from_possibilities(*falsey_possibilities)
      end

      def for_scope(scope)
        Maybe::Object.from_possibilities(*@possibilities.map { |k| scope.q(k) })
      end

      def to_s
        "(#{@possibilities.map(&:to_s).join(' | ')})"
      end

      def inspect
        "#<#{self.class.name} @possibilities=#{@possibilities.inspect}>"
      end

      def |(other)
        Maybe::Object.from_possibilities(self, other)
      end

      private

      def self.normalize(things)
        things.flat_map do |thing|
          case thing
          when Maybe::Object
            thing.possibilities
          else
            thing
          end
        end.uniq.reject { |p| p.is_a?(ImpossibleDefinition) }
      end
    end
  end
end