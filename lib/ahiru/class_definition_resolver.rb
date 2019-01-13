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

      init_method = @instance_type.methods.dig(:initialize, 0) || create_init_method
      new_method = init_method.dup
      new_method.name = :new
      if new_method.return_type.free? && new_method.free_types.include?(new_method.return_type)
        new_method.free_types.delete(new_method.return_type)
      end
      new_method.return_type = @instance_type
      @instance_type.methods[:initialize] = [init_method]
      @class_type.methods[:new] = [new_method]

      @class_type
    end

    private

    def create_init_method
      Method.new(@instance_type, :initialize)
    end
  end
end