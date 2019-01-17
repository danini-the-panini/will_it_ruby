module Ahiru
  class World
    attr_reader :scope, :files, :issues

    def initialize
      @scope = MainScope.new self
      @files = []
      @issues = []
    end

    def process_expression(sexp)
      scope.process_expression(sexp)
    end

    def process_file(path)
      source = File.read(path)
      sexp = RubyParser.new.parse(source)
      file = SourceFile.new(path, source, sexp, self)
      files << file
      file.process
    rescue Racc::ParseError => e
      register_issue issue_from_parse_error(e, file)
    end

    def register_issue(issue)
      issues << issue
    end

    def all_issues
      issues + files.flat_map(&:issues)
    end

    def to_s
      '(world)'
    end

    private

    def issue_from_parse_error(e, file)
      e.message =~ /\A\([^\)]+\):(\d+) :: (.+)\z/
      Issue.new($2, $1.to_i, self, file)
    end
  end
end