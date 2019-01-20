module Ahiru
  class StandardLibrary
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

    def initialize_numeric(d)
      NUMERIC_OPERATOR_MATRIX.each do |operator, types|
        types.compact.each do |type_name, mapping|
          type = object_class.get_constant(type_name)
          type.add_instance_method(operator, BuiltInMethodDefinition.new(operator, s(:args, :other), precheck: -> (other) {
            other_type_name = other.class_definition.name
            if mapping[other_type_name].nil?
              "#{other} can't be coerced into #{type_name}"
            end
          }) { |other|
            other_type_name = other.class_definition.name
            object_class.get_constant(mapping[other_type_name]).create_instance
          })
        end
      end
    end
  end
end