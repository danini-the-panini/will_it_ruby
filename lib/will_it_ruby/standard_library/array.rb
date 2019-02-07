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

      d.def_instance_method(:<<, s(:args, :value)) do |v|
        if value_known?
          value << v
          update_element_type
        else
          self.element_type |= v
        end
        self
      end

      # TODO: <=>
      # TODO: ==

      # TODO: overload for (start, end) and (range)
      d.def_instance_method(:[], s(:args, :index), precheck: -> (index) {
        check_convert_to_int(index)
      }) do |index|
        if value_known? && index.value_known?
          value[index.value] || v_nil
        else
          Maybe::Object.from_possibilities(element_type, v_nil)
        end
      end

      # TODO: overload for (start, end) and (range)
      # TODO: when index is out of bounds, extend the array size and add nils where necessary
      d.def_instance_method(:[]=, s(:args, :index, :value), precheck: -> (index, v) {
        check_convert_to_int(index)
      }) do |index, v|
        if value_known? && index.value_known?
          value[index.value] = v
          update_element_type
        else
          add_element_type(v)
        end
      end

      # TODO: any?
      # TODO: append
      # TODO: assoc
      # TODO: at
      # TODO: bsearch
      # TODO: bsearch_index
      # TODO: clear
      # TODO: collect
      # TODO: collect!
      # TODO: combination
      
      d.def_instance_method(:compact, s(:args)) do |block|
        if value_known?
          if value.all?(&:definitely_nil?)
            object_class.get_constant(:Array).create_instance(value: [])
          else
            possibilities = [[]]
            value.each do |v|
              next if v.definitely_nil?
              if !v.maybe_nil?
                possibilities.each { |p| p << v }
              else
                possibilities += possibilities.map { |p| [*p, v.without_nils] }
              end
            end

            Maybe::Object.from_possibilities(*possibilities.map { |v|
              object_class.get_constant(:Array).create_instance(value: v)
            })
          end
        else
          new_element_type = element_type.without_nils
          object_class.get_constant(:Array).create_instance(element_type: new_element_type | v_nil)
        end
      end

      # TODO: compact!
      # TODO: concat
      # TODO: count
      # TODO: cycle
      # TODO: delete
      # TODO: delete_at
      # TODO: delete_if
      # TODO: dig
      # TODO: drop
      # TODO: drop_while
      # TODO: each
      # TODO: each_index
      # TODO: empty?
      # TODO: eql?
      # TODO: fetch
      # TODO: fill
      # TODO: find_index
      # TODO: first
      # TODO: flatten
      # TODO: flatten!
      # TODO: frozen?
      # TODO: hash
      # TODO: include?
      # TODO: index
      # TODO: insert
      # TODO: inspect
      # TODO: join
      # TODO: keep_if
      # TODO: last
      # TODO: length
      
      # TODO: return Enumerable if no block
      d.def_instance_method(:map, s(:args)) do |block|
        scope = create_scope([], block)
        if value_known?
          new_value = value.map do |v|
            call = PreprocessedCall.new([v])
            scope.process_yield(call)
          end
          object_class.get_constant(:Array).create_instance(value: new_value)
        else
          call = PreprocessedCall.new([element_type])
          new_element_type = scope.process_yield(call)
          object_class.get_constant(:Array).create_instance(element_type: new_element_type | v_nil)
        end
      end

      # TODO: map!
      # TODO: max
      # TODO: min
      # TODO: pack
      # TODO: permutation
      # TODO: pop
      # TODO: prepend
      # TODO: product
      # TODO: push
      # TODO: rassoc
      # TODO: reject
      # TODO: reject!
      # TODO: repeated_combination
      # TODO: repeated_permutation
      # TODO: replace
      # TODO: reverse
      # TODO: reverse!
      # TODO: reverse_each
      # TODO: rindex
      # TODO: rotate
      # TODO: rotate!
      # TODO: sample
      # TODO: select
      # TODO: select!
      # TODO: shift
      # TODO: shuffle
      # TODO: shuffle!
      # TODO: size
      # TODO: slice
      # TODO: slice!
      # TODO: sort
      # TODO: sort!
      # TODO: sort_by!
      # TODO: sum
      # TODO: take
      # TODO: take_while

      d.def_instance_method(:to_a, s(:args)) do
        self
      end

      # TODO: to_ary
      # TODO: to_h
      # TODO: to_s
      # TODO: transpose
      # TODO: uniq
      # TODO: uniq!
      # TODO: unshift
      # TODO: values_at
      # TODO: zip
    end
  end
end