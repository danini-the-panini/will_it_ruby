module Ahiru
  class FileScope < Scope
    def initialize(processor, expressions, source_file)
      super(processor, expressions)
      @source_file = source_file
    end

    def register_issue(line, message)
      processor.register_issue Issue.new(@source_file.path, line, message)
    end

    # TODO: move this, as classes are not only defined on the file-level scope
    def process_class_expression(name, super_exp, *expressions)
      case name
      when Symbol
        super_type = super_exp ? process_expression(super_exp) : nil
        class_type = @parent.find_or_create_class(name, super_type, expressions, self)
      else
        # TODO: class names like A::B::C
      end
    end
  end
end