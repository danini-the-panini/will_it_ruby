module Ahiru
  class ClassDefinitionResolver
    def initialize(name, super_exp, expressions, parent_scope)
      @name = name
      @super_exp = super_exp
      @expressions = expressions
      @parent_scope = parent_scope
    end

    def resolve
      @super_class = if @super_exp.nil?
                       C_Object
                     else
                       @parent_scope.process_expression(@super_exp)
                     end

      @instance_type = Duck.new(@super_class.instance_type, name: @name, enclosing_module: @parent_scope.t_self)
      @class_type = T_Class[@instance_type]
      @parent_scope.t_self.add_constant @name, @class_type

      @class_scope = ClassScope.new(@parent_scope.world, @class_type, @parent_scope)

      @expressions.each do |exp|
        @class_scope.process_expression(exp)
      end

      @class_type
    end
  end
end