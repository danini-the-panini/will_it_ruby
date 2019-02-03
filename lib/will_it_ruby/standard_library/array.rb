module WillItRuby
  class StandardLibrary
    def initialize_array(d)
      d.def_instance_method(:&, s(:args, :other), precheck: -> (other) { check_convert_to_ary(other) }) do |other|
        if !other.is_a?(ArrayInstance)
          other = other.get_method(:to_ary).make_call(other, Call.new([], nil).tap(&:process))
        end

        # TODO: handle known-value case
        
        object_class.get_constant(:Array).create_instance(value: nil, element_type: element_type)
      end

      d.def_instance_method(:|, s(:args, :other), precheck: -> (other) { check_convert_to_ary(other) }) do |other|
        if !other.is_a?(ArrayInstance)
          other = other.get_method(:to_ary).make_call(other, Call.new([], nil).tap(&:process))
        end

        new_element_type = if element_type_known? && other.element_type_known?
                             self.element_type | other.element_type
                           end

        # TODO: handle known-value case
          
        object_class.get_constant(:Array).create_instance(value: nil, element_type: new_element_type)
      end

      d.def_instance_method(:+, s(:args, :other), precheck: -> (other) { check_convert_to_ary(other) }) do |other|
        if !other.is_a?(ArrayInstance)
          other = other.get_method(:to_ary).make_call(other, Call.new([], nil).tap(&:process))
        end

        new_element_type = if element_type_known? && other.element_type_known?
                             self.element_type | other.element_type
                           end

        new_value = if value_known? && other.value_known?
                      self.value + other.value
                    end
          
        object_class.get_constant(:Array).create_instance(value: new_value, element_type: new_element_type)
      end

      d.def_instance_method(:-, s(:args, :other), precheck: -> (other) { check_convert_to_ary(other) }) do |other|
        if !other.is_a?(ArrayInstance)
          other = other.get_method(:to_ary).make_call(other, Call.new([], nil).tap(&:process))
        end

        # TODO: handle known-value case
          
        object_class.get_constant(:Array).create_instance(value: nil, element_type: element_type)
      end

      d.def_instance_method(:*, s(:args, :other), precheck: -> (other) {
        if other.class_definition != object_class.get_constant(:Integer) && other.class_definition != object_class.get_constant(:String)
          if other.has_method?(:to_str)
            check_convert_to_str(other)
          else
            check_convert_to_int(other)
          end
        end
      }) do |other|
        other_conv = if other.class_definition != object_class.get_constant(:Integer) && other.class_definition != object_class.get_constant(:String)
                       if other.has_method?(:to_str)
                         other.get_method(:to_str).make_call(other, Call.new([], nil).tap(&:process))
                       else
                         other.get_method(:to_int).make_call(other, Call.new([], nil).tap(&:process))
                       end
                     else
                       other
                     end

        if other_conv.class_definition == object_class.get_constant(:Integer)
          if other_conv.value_known? && self.value_known?
            new_value = self.value * other.value
            object_class.get_constant(:Array).create_instance(value: new_value, element_type: element_type)
          else
            object_class.get_constant(:Array).create_instance(element_type: element_type)
          end
        else
          # TODO: call #join
          object_class.get_constant(:String).create_instance
        end
      end

      d.def_instance_method(:to_a, s(:args)) do
        self
      end
    end
  end
end