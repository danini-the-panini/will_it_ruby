module Ahiru
  T_Object.define do
    m :===, T_Any => T_Bool
    m :=~, T_Any => T_Any
    m :eq?, T_Any => T_Bool
    
    m :class, C_Object
    m :singleton_class, C_Object

    m :clone, t_self
    m :dclone, t_self
    m :dup, t_self

    m :display, T_Nil
    m :display, T_IO => T_Nil

    m :extend, [T_Module, v(T_Any)] => t_self

    m :taint, t_self
    m :untaint, t_self
    m :trust, t_self
    m :untrust, t_self
    m :tainted?, T_Bool
    m :untrusted?, T_Bool

    m :freeze, t_self
    m :frozen?, T_Bool

    m :inspect, T_String

    m :instance_of?, T_Class => T_Bool
    m :is_a?, T_Class => T_Bool
    m :kind_of?, T_Class => T_Bool
    m :nil?, T_Bool

    m :instance_variable_defined?, [T_Symbol | T_String] => T_Bool
    m :instance_variable_get, [T_Symbol | T_String] => T_Any
    m :remove_instance_variable_get, T_Symbol => T_Any
    m :instance_variable_set, [T_Symbol | T_String, T] => T
    m :instance_variables, T_Array[T_Symbol]

    m :itself, t_self

    m :method, T_Symbol => T_Method
    m :singleton_method, T_Symbol => T_Method
    m :methods, o(T_Bool) => T_Array[T_Symbol]
    m :singleton_methods, o(T_Bool) => T_Array[T_Symbol]
    m :private_methods, o(T_Bool) => T_Array[T_Symbol]
    m :protected_methods, o(T_Bool) => T_Array[T_Symbol]
    m :public_methods, o(T_Bool) => T_Array[T_Symbol]

    m :public_send, [T_String | T_Symbol, v(T_Any)] => T_Any
    m :public_send, [T_String | T_Symbol, v(T_Any)] => T_Any do
      { v(T_Any) => T_Any }
    end

    m :respond_to?, [T_String | T_Symbol, o(T_Bool)] => T_Bool
    m :respond_to_missing?, [T_String | T_Symbol, o(T_Bool)] => T_Bool

    m :tap, t_self do
      { o(t_self) => T_Any }
    end

    m :enum_for, [o(T_Symbol), v(T_Any)] => T_Enumerator
    m :enum_for, [o(T_Symbol), v(T_Any)] => T_Enumerator do
      { v(T_Any) => T_Any }
    end
    m :to_enum, [o(T_Symbol), v(T_Any)] => T_Enumerator
    m :to_enum, { [o(T_Symbol), v(T_Any)] => T_Enumerator } do
      { v(T_Any) => T_Any }
    end

    m :to_s, T_String
    m :to_yaml, o(T_Hash[T_Symbol, T_Any]) => T_String
    m :yield_self, T_Enumerator[t_self]
    m :yield_self, T do
      { o(t_self) => T }
    end

    m :sysread, [T_IO, T_Integer] => T_Nil
    m :timeout, v(T_Any) => T_Any do
      { v(T_Any) => T_Any }
    end

    m :xmp, [T_String, o(T_Any)] => T_Any

    # add_constant_definition :ARGF, T_ARGF
    # add_constant_definition :ARGV, T_Array String)
    # add_constant_definition :Bignum, T_Class
    # add_constant_definition :CROSS_COMPILING, T_Any
    # add_constant_definition :DATA, T_File
    # add_constant_definition :ENV, T_Hash String, String)
    # add_constant_definition :FALSE, T_FalseClass
    # add_constant_definition :TRUE, T_TrueClass
    # add_constant_definition :Fixnum, T_Class
    # add_constant_definition :NIL, Nil
    # add_constant_definition :RUBY_COPYRIGHT, T_String
    # add_constant_definition :RUBY_DESCRIPTION, T_String
    # add_constant_definition :RUBY_ENGINE, T_String
    # add_constant_definition :RUBY_ENGINE_VERSION, T_String
    # add_constant_definition :RUBY_PATCHLEVEL, T_Integer
    # add_constant_definition :RUBY_PLATFORM, T_String
    # add_constant_definition :RUBY_RELEASE_DATE, T_String
    # add_constant_definition :RUBY_REVISION, T_Integer
    # add_constant_definition :STDERR, T_IO
    # add_constant_definition :STDIN, T_IO
    # add_constant_definition :STDOUT, T_IO
    # add_constant_definition :TOPLEVEL_BINDING, T_Binding
  end

  C_Object.define do
    m :yaml_tag, T_String => T_String
  end
end
