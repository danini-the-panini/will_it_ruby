puts "STARTING THE THING"

require "bundler/setup"
require "ahiru"
require "json"

set :root, File.dirname(__FILE__)
set :public_folder, settings.root + '/static'

get '/' do
  initial_code = <<~RUBY
    class Foo
      def foo
        42
      end
    end

    Foo.new.foo + 8
  RUBY
  erb :index, locals: { initial_code: initial_code }
end

post '/check' do
  begin
    processor = Ahiru::Processor.new
    processor.process_string(request.body.read, '(editor)')
    processor.issues.map do |i|
      {
        file: i.file,
        line: i.line,
        message: i.message,
        full_message: i.to_s
      }
    end.to_json
  rescue StandardError => e
    $stderr.puts e.full_message
    [{
      file: '',
      line: '',
      message: '',
      full_message: "SOMETHING BROKE :("
    }].to_json
  end
end