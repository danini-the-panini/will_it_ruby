require "bundler/setup"
require "will_it_ruby"
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
    processor = WillItRuby::Processor.new
    processor.process_string(request.body.read, '(editor)')
    processor.issues.map do |i|
      {
        file: i.file,
        line: i.line,
        message: i.message,
        full_message: ERB::Util.html_escape(i.to_s)
      }
    end.to_json
  rescue StandardError => e
    $stderr.puts e.full_message
    [{
      file: '(unknown)',
      line: 1,
      message: 'INTERNAL SERVER ERROR',
      full_message: "INTERNAL SERVER ERROR"
    }].to_json
  end
end