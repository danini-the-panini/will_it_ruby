module Ahiru
  class Processor
    attr_reader :issues, :main_scope

    def initialize
      @issues = []
      @standard_library = StandardLibrary.new(self)
      @object_class = @standard_library.object_class
      @main_scope = MainScope.new(self, [])
    end

    def object_class
      @standard_library.object_class
    end

    def v_nil
      @standard_library.v_nil
    end

    def v_true
      @standard_library.v_true
    end

    def v_false
      @standard_library.v_false
    end

    def v_bool
      @standard_library.v_bool
    end

    def process_file(path)
      source = File.read(path)
      process_string(source, path)
    end

    def process_string(source, path='(unknown)')
      sexp = RubyParser.new.parse(source)
      @last_file = SourceFile.new(path, source, sexp_to_expressions(sexp), self)
      @last_file.process
    rescue Racc::ParseError => e
      register_issue issue_from_parse_error(e, path)
    end

    def register_issue(issue)
      @issues << issue
    end

    def last_evaluated_result
      @last_file.scope.last_evaluated_result
    end

    private

    def issue_from_parse_error(e, path)
      e.message =~ /\A\([^\)]+\):(\d+) :: (.+)\z/
      Issue.new(path, $1.to_i, $2)
    end

    def sexp_to_expressions(sexp)
      case sexp[0]
      when :block
        _, *expressions = sexp
        expressions
      when nil
        []
      else
        [sexp]
      end
    end
  end
end