require "ruby_parser"

require "will_it_ruby/version"

require "will_it_ruby/processor"
require "will_it_ruby/processor_delegate_methods"
require "will_it_ruby/source_file"
require "will_it_ruby/issue"

require "will_it_ruby/scope/returnable"
require "will_it_ruby/scope/scope"
require "will_it_ruby/scope/main_scope"
require "will_it_ruby/scope/file_scope"
require "will_it_ruby/scope/method_scope"
require "will_it_ruby/scope/class_scope"
require "will_it_ruby/scope/maybe_scope"
require "will_it_ruby/scope/block_scope"

require "will_it_ruby/definitions/class_definition"
require "will_it_ruby/definitions/singleton_class_definition"
require "will_it_ruby/definitions/class_instance"
require "will_it_ruby/definitions/main_object_instance"
require "will_it_ruby/definitions/method_definition"
require "will_it_ruby/definitions/new_method_definition"
require "will_it_ruby/definitions/built_in_method_definition"
require "will_it_ruby/definitions/broken_definition"
require "will_it_ruby/definitions/impossible_definition"
require "will_it_ruby/definitions/arguments"

require "will_it_ruby/maybe/object"
require "will_it_ruby/maybe/method"
require "will_it_ruby/maybe/method_set"

require "will_it_ruby/standard_library"

require "will_it_ruby/quantum/resolver"