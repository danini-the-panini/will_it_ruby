module Ahiru
  class FileScope < Scope
    def initialize(processor, expressions, source_file)
      super(processor, expressions)
      @source_file = source_file
    end

    def register_issue(line, message)
      processor.register_issue Issue.new(@source_file.path, line, message)
    end

    def process_class_expression(name, super_exp, *expressions)
      case name
      when Symbol
        class_type = @parent.find_or_create_class(name, super_exp, expressions, self)
      else
        # TODO: class names like A::B::C
      end
    end

    def process_const_expression(name)
      @parent.process_const_expression(name)
    end
  end
end