require "ruby_parser"

require "ahiru/version"

require "ahiru/processor"
require "ahiru/source_file"
require "ahiru/issue"

require "ahiru/scope/scope"
require "ahiru/scope/main_scope"
require "ahiru/scope/file_scope"
require "ahiru/scope/method_scope"
require "ahiru/scope/class_scope"

require "ahiru/definitions/class_definition"
require "ahiru/definitions/class_instance"
require "ahiru/definitions/method_definition"
require "ahiru/definitions/baked_method_definition"