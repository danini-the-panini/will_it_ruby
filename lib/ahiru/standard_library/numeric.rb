module Ahiru
  class StandardLibrary
    NUMERIC_TYPES = %i(Complex Rational Float Integer)
    REAL_NUMERIC_TYPES = NUMERIC_TYPES - %i(Complex)
    PRIMITIVE_NUMERIC_TYPES = %i(Float Integer)
    COMPOSITE_NUMERIC_TYPES = NUMERIC_TYPES - PRIMITIVE_NUMERIC_TYPES

    BASIC_NUMERIC_OPERATOR_MATRIX = {
      Complex: {
        Complex:  :Complex,
        Rational: :Complex,
        Float:    :Complex,
        Integer:  :Complex
      },
      Rational: {
        Complex:  :Complex,
        Rational: :Rational,
        Float:    :Float,
        Integer:  :Rational
      },
      Float: {
        Complex:  :Complex,
        Rational: :Float,
        Float:    :Float,
        Integer:  :Float
      },
      Integer: {
        Complex:  :Complex,
        Rational: :Rational,
        Float:    :Float,
        Integer:  :Integer
      }
    }

    BITWISE_OPERATOR_MATRIX = {
      Complex:  nil,
      Rational: nil,
      Float:    nil,
      Integer: {
        Complex:  nil,
        Rational: nil,
        Float:    nil,
        Integer:  :Integer
      }
    }

    BIT_SHIFT_OPERATOR_MATRIX = {
      Complex:  nil,
      Rational: nil,
      Float:    nil,
      Integer: {
        Complex:  nil,
        Rational: :Integer,
        Float:    :Integer,
        Integer:  :Integer
      }
    }

    NUMERIC_OPERATOR_MATRIX = {
      :'+' => BASIC_NUMERIC_OPERATOR_MATRIX,
      :'-' => BASIC_NUMERIC_OPERATOR_MATRIX,
      :'*' => BASIC_NUMERIC_OPERATOR_MATRIX,
      :'/' => BASIC_NUMERIC_OPERATOR_MATRIX,
      :'%' => {
        Complex:  nil,
        Rational: {
          Complex:  nil,
          Rational: :Rational,
          Float:    :Float,
          Integer:  :Rational
        },
        Float:    {
          Complex:  nil,
          Rational: :Float,
          Float:    :Float,
          Integer:  :Float
        },
        Integer:  {
          Complex:  nil,
          Rational: :Rational,
          Float:    :Float,
          Integer:  :Integer
        }
      },
      :'**' => {
        Complex: {
          Complex:  :Complex,
          Rational: :Complex,
          Float:    :Complex,
          Integer:  :Complex
        },
        Rational: {
          Complex:  :Complex,
          Rational: :Float,
          Float:    :Float,
          Integer:  :Rational
        },
        Float: {
          Complex:  :Complex,
          Rational: :Float,
          Float:    :Float,
          Integer:  :Float
        },
        Integer: {
          Complex:  :Complex,
          Rational: :Float,
          Float:    :Float,
          Integer:  :Integer
        }
      },
      :'&'  => BITWISE_OPERATOR_MATRIX,
      :'|'  => BITWISE_OPERATOR_MATRIX,
      :'^'  => BITWISE_OPERATOR_MATRIX,
      :'<<' => BIT_SHIFT_OPERATOR_MATRIX,
      :'>>' => BIT_SHIFT_OPERATOR_MATRIX
    }

    def initialize_numeric(numeric_class)
      NUMERIC_OPERATOR_MATRIX.each do |operator, types|
        types.compact.each do |type_name, mapping|
          type = object_class.get_constant(type_name)
          type.def_instance_method(operator, s(:args, :other), precheck: -> (other) {
            other_type_name = other.class_definition.name
            if mapping[other_type_name].nil?
              "#{other} can't be coerced into #{type_name}"
            end
          }) do |other|
            result = if self.value_known? && other.value_known?
                     self.value.send(operator, other.value)
                   else
                     nil
                   end
            other_type = other.class_definition
            other_type_name = other_type.name
            object_class.get_constant(mapping[other_type_name]).create_instance(value: result)
          end
        end
      end

      PRIMITIVE_NUMERIC_TYPES.each do |type_name|
        type = object_class.get_constant(type_name)
        type.def_instance_method(:equal?, s(:args, :other)) do |other|
          return v_false unless other.class_definition.is_or_sublass_of?(self.class_definition)
          if self.value_known? && other.value_known?
            self.value.equal?(other_value) ? v_true : v_false
          else
            v_bool
          end
        end
      end

      COMPOSITE_NUMERIC_TYPES.each do |type_name|
        type = object_class.get_constant(type_name)
        type.def_instance_method(:equal?, s(:args, :other)) do |other|
          other == self ? v_true : v_bool
        end
      end

      REAL_NUMERIC_TYPES.each do |type_name|
        type = object_class.get_constant(type_name)
        %i(< > <= >= <=>).each do |operator|
          type.def_instance_method(operator, s(:args, :other), precheck: -> (other) {
            if !REAL_NUMERIC_TYPES.map{ |n| object_class.get_constant(n) }.include?(other.class_definition)
              "comparison of #{other.class_definition.to_s} with #{type_name} failed"
            end
          }) do |other|
            if self.value_known? && other.value_known?
              self.value.send(operator, other.value) ? v_true : v_false
            else
              v_bool
            end
          end
        end
      end

      numeric_class.def_instance_method(:==, s(:args, :other)) do |other|
        return v_false unless other.class_definition.is_or_sublass_of?(numeric_class)
        if self.value_known? && other.value_known?
          self.value == other_value ? v_true : v_false
        else
          v_bool
        end
      end

      numeric_class.def_instance_method(:!=, s(:args, :other)) do |other|
        return v_true unless other.class_definition.is_or_sublass_of?(numeric_class)
        if self.value_known? && other.value_known?
          self.value != other_value ? v_true : v_false
        else
          v_bool
        end
      end

      numeric_class.def_instance_method(:eql?, s(:args, :other)) do |other|
        return v_false unless other.class_definition.is_or_sublass_of?(self.class_definition)
        if self.value_known? && other.value_known?
          self.value.eql?(other_value) ? v_true : v_false
        else
          v_bool
        end
      end

      numeric_class.def_instance_method(:+@, s(:args)) do
        self
      end

      %i(-@ abs abs2).each do |m|
        numeric_class.def_instance_method(m, s(:args)) do
          result = if self.value_known?
                     self.value.send(m)
                   else
                     nil
                   end
          self.class_definition.create_instance(value: result)
        end
      end

      # TODO: override these for Complex to always return Float
      %i(angle arg).each do |m|
        numeric_class.def_instance_method(m, s(:args)) do
          if self.value_known?
            result = self.value.send(m)
            result_type = result.class.name.to_sym
            object_class.get_constant(result_type).create_instance(value: result)
          else
            Maybe::Object.from_possibilities(
              object_class.get_constant(:Integer).create_instance(value: 0),
              object_class.get_constant(:Float).create_instance(value: Float::PI)
            )
          end
        end
      end

      %i(ceil floor).each do |m|
        REAL_NUMERIC_TYPES.each do |type_name|
          type = object_class.get_constant(type_name)

          type.def_instance_method(:ceil, s(:args, s(:lasgn, :ndigits, s(:lit, 0))), precheck: -> (ndigits) {
            # TODO: allow other types that implements #to_int that returns an integer
            if !REAL_NUMERIC_TYPES.map { |t| object_class.get_constant(t) }.include?(ndigits.class_definition)
              "can't convert #{ndigits.to_s} to Integer"
            end
          }) do |ndigits|
            if self.value_known? && ndigits.value_known?
              result = self.value.send(m, ndigits.value)
              result_type = result.class.name.to_sym
              object_class.get_constant(result_type).create_instance(value: result)
            else
              Maybe::Object.from_possibilities(
                object_class.get_constant(:Integer).create_instance,
                object_class.get_constant(:Float).create_instance
              )
            end
          end
        end
      end

      # TODO: :clone, :coerce, :conj, :conjugate, :denominator, :div, :divmod, :dup, fdiv, :finite?, :i, :imag, :imaginary, :infinite?, :integer?, :magnitude, :modulo, :negative?, :nonzero?, :numerator, :phase, :polar, :positive?, :quo, :real, :real?, :rect, :rectangular, :remainder, :round, :singleton_method_added, :step, :to_c, :to_int, :truncate, :zero?
    end
  end
end