module Ahiru
  class FileScope < Scope
    def initialize(processor, sexp, source_file)
      super(processor, sexp, nil)
      @source_file = source_file
    end

    def register_issue(line, message)
      processor.register_issue Issue.new(@source_fle, line, message)
    end
  end
end