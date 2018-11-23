require 'gemologist/definition'

Geomologist::Definition.add_class_definition(Object) do
  add_method_definition :===, Bool, Any
  add_method_definition :=~, Any, Any
  add_method_definition :eq?, Bool, Any
  
  add_method_definition :class, T(SelfClass)
  add_method_definition :singleton_class, T(SelfClass)

  add_method_definition :clone, Self
  add_method_definition :dclone, Self
  add_method_definition :dup, Self

  add_method_definition :display, T(NilClass)
  add_method_definition :display, T(NilClass), T(IO)

  add_method_definition :extend, Self, T(Module) # TODO: technically variadic, don't know why tho...

  add_method_definition :taint, Self
  add_method_definition :untaint, Self
  add_method_definition :trust, Self
  add_method_definition :untrust, Self
  add_method_definition :tainted?, Bool
  add_method_definition :untrusted?, Bool

  add_method_definition :freeze, Self
  add_method_definition :frozen?, Bool

  add_method_definition :inspect, T(String)

  add_method_definition :instance_of?, Bool, T(Class)
  add_method_definition :is_a?, Bool, T(Class)
  add_method_definition :kind_of?, Bool, T(Class)
  add_method_definition :nil?, Bool

  add_method_definition :instance_variable_defined?, Bool, T(Symbol) | T(String)
  add_method_definition :instance_variable_get, Any, T(Symbol) | T(String)
  add_method_definition :remove_instance_variable_get, Any, T(Symbol)
  add_method_definition :instance_variable_set, X, T(Symbol) | T(String), X
  add_method_definition :instance_variables, T(Array, Symbol)

  add_method_definition :itself, Self

  add_method_definition :method, T(::Method), T(Symbol)
  add_method_definition :singleton_method, T(::Method), T(Symbol)
  add_method_definition :methods, T(Array, Symbol)
  add_method_definition :methods, T(Array, Symbol), Bool
  add_method_definition :singleton_methods, T(Array, Symbol)
  add_method_definition :singleton_methods, T(Array, Symbol), Bool
  add_method_definition :private_methods, T(Array, Symbol)
  add_method_definition :private_methods, T(Array, Symbol), Bool
  add_method_definition :protected_methods, T(Array, Symbol)
  add_method_definition :protected_methods, T(Array, Symbol), Bool
  add_method_definition :public_methods, T(Array, Symbol)
  add_method_definition :public_methods, T(Array, Symbol), Bool

  add_method_definition :public_send, Any, T(String) | T(Symbol) # TODO: Variadic... with block and kwargs and all

  add_method_definition :respond_to?, Bool, T(String) | T(Symbol)
  add_method_definition :respond_to?, Bool, T(String) | T(Symbol), Bool
  add_method_definition :respond_to_missing?, Bool, T(String) | T(Symbol)
  add_method_definition :respond_to_missing?, Bool, T(String) | T(Symbol), Bool

  add_method_definition :tap, Self # TODO: block

  add_method_definition :enum_for, T(Enumerator), T(Symbol) # TODO: variadic...
  add_method_definition :to_enum, T(Enumerator) # TODO: block, variadic...
  add_method_definition :to_enum, T(Enumerator), T(Symbol)

  add_method_definition :to_s, T(String)
  add_method_definition :to_yaml, T(String)
  add_method_definition :to_yaml, T(String), T(Hash, Symbol, Any)
  add_method_definition :yield_self, Any # TODO: block

  add_method_definition :sysread, Nil, T(IO), T(Integer)
  add_method_definition :timeout, Nil  # TODO: block, variadic...

  add_method_definition :xmp, Any, T(String)
  add_method_definition :xmp, Any, T(String), Any

  add_class_method_definition :yaml_tag, T(String, T(String)

  add_constant_definition :ARGF, T(ARGF)
  add_constant_definition :ARGV, T(Array, String)
  add_constant_definition :Bignum, T(Class)
  add_constant_definition :CROSS_COMPILING, Any
  add_constant_definition :DATA, T(File)
  add_constant_definition :ENV, T(Hash, String, String)
  add_constant_definition :FALSE, T(FalseClass)
  add_constant_definition :TRUE, T(TrueClass)
  add_constant_definition :Fixnum, T(Class)
  add_constant_definition :NIL, Nil
  add_constant_definition :RUBY_COPYRIGHT, T(String)
  add_constant_definition :RUBY_DESCRIPTION, T(String)
  add_constant_definition :RUBY_ENGINE, T(String)
  add_constant_definition :RUBY_ENGINE_VERSION, T(String)
  add_constant_definition :RUBY_PATCHLEVEL, T(Integer)
  add_constant_definition :RUBY_PLATFORM, T(String)
  add_constant_definition :RUBY_RELEASE_DATE, T(String)
  add_constant_definition :RUBY_REVISION, T(Integer)
  add_constant_definition :STDERR, T(IO)
  add_constant_definition :STDIN, T(IO)
  add_constant_definition :STDOUT, T(IO)
  add_constant_definition :TOPLEVEL_BINDING, T(Binding)
end