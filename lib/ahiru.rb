require "ruby_parser"

require "ahiru/version"

require "ahiru/processor"
require "ahiru/processor_delegate_methods"
require "ahiru/source_file"
require "ahiru/issue"

require "ahiru/scope/scope"
require "ahiru/scope/main_scope"
require "ahiru/scope/file_scope"
require "ahiru/scope/method_scope"
require "ahiru/scope/class_scope"

require "ahiru/definitions/class_definition"
require "ahiru/definitions/singleton_class_definition"
require "ahiru/definitions/class_instance"
require "ahiru/definitions/method_definition"
require "ahiru/definitions/new_method_definition"
require "ahiru/definitions/built_in_method_definition"
require "ahiru/definitions/broken_definition"
require "ahiru/definitions/arguments"

require "ahiru/maybe/object"
require "ahiru/maybe/method"
require "ahiru/maybe/method_set"

require "ahiru/standard_library"