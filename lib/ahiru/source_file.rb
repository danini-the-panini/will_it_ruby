module Ahiru
  class SourceFile
    attr_reader :path, :source, :sexp, :processor, :scope

    def initialize(path, source, sexp, processor)
      @path = path
      @source = source
      @sexp = sexp
      @processor = processor
      @scope = FileScope.new(processor, sexp, self)
    end

    def process
      @scope.process
    end
  end
end