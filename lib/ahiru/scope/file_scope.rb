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

        error = @parent.check_create_class(name, super_type)

        if error
          register_issue @current_sexp.line, error
        else
          @parent.find_or_create_class(name, super_type, expressions, self)
        end
      else
        # TODO: class names like A::B::C
      end
    end

    def process_defn_expression(*args)
      @parent.process_defn_expression(*args)
    end

    def process_self_expression
      @parent.process_self_expression
    end
  end
end