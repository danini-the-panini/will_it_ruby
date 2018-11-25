require 'gemologist/definition'

module Gemologist
  Definition.add_class_definition(Object) do
    add_method_definition :===, Any => Bool
    add_method_definition :=~, Any => Any
    add_method_definition :eq?, Any => Bool
    
    add_method_definition :class, SelfClass
    add_method_definition :singleton_class, SelfClass

    add_method_definition :clone, Self
    add_method_definition :dclone, Self
    add_method_definition :dup, Self

    add_method_definition :display, T(NilClass)
    add_method_definition :display, T(IO) => T(NilClass)

    add_method_definition :extend, [T(Module), +Any] => Self

    add_method_definition :taint, Self
    add_method_definition :untaint, Self
    add_method_definition :trust, Self
    add_method_definition :untrust, Self
    add_method_definition :tainted?, Bool
    add_method_definition :untrusted?, Bool

    add_method_definition :freeze, Self
    add_method_definition :frozen?, Bool

    add_method_definition :inspect, T(String)

    add_method_definition :instance_of?, T(Class) => Bool
    add_method_definition :is_a?, T(Class) => Bool
    add_method_definition :kind_of?, T(Class) => Bool
    add_method_definition :nil?, Bool

    add_method_definition :instance_variable_defined?, [T(Symbol) | T(String)] => Bool
    add_method_definition :instance_variable_get, [T(Symbol) | T(String)] => Any
    add_method_definition :remove_instance_variable_get, T(Symbol) => Any
    add_method_definition :instance_variable_set, [T(Symbol) | T(String), T] => T
    add_method_definition :instance_variables, T(Array, Symbol)

    add_method_definition :itself, Self

    add_method_definition :method, T(Symbol) => T(::Method)
    add_method_definition :singleton_method, T(Symbol) => T(::Method)
    add_method_definition :methods, !Bool => T(Array, Symbol)
    add_method_definition :singleton_methods, !Bool => T(Array, Symbol)
    add_method_definition :private_methods, !Bool => T(Array, Symbol)
    add_method_definition :protected_methods, !Bool => T(Array, Symbol)
    add_method_definition :public_methods, !Bool => T(Array, Symbol)

    add_method_definition :public_send, [T(String) | T(Symbol), +Any] => Any
    add_method_definition :public_send, { [T(String) | T(Symbol), +Any] => Any }, +Any => Any

    add_method_definition :respond_to?, [T(String) | T(Symbol), !Bool] => Bool
    add_method_definition :respond_to_missing?, [T(String) | T(Symbol), !Bool] => Bool

    add_method_definition :tap, Self, !Self => Any

    add_method_definition :enum_for, [!T(Symbol), +Any] => T(Enumerator)
    add_method_definition :enum_for, { [!T(Symbol), +Any] => T(Enumerator) }, +Any => Any
    add_method_definition :to_enum, [!T(Symbol), +Any] => T(Enumerator)
    add_method_definition :to_enum, { [!T(Symbol), +Any] => T(Enumerator) }, +Any => Any

    add_method_definition :to_s, T(String)
    add_method_definition :to_yaml, !T(Hash, Symbol, Any) => T(String)
    add_method_definition :yield_self, T(Enumerator, Self)
    add_method_definition :yield_self, T, !Self => T

    add_method_definition :sysread, [T(IO), T(Integer)] => Nil
    add_method_definition :timeout, { +Any => Any }, +Any => Any

    add_method_definition :xmp, [T(String), !Any] => Any

    add_class_method_definition :yaml_tag, T(String) => T(String)

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
end