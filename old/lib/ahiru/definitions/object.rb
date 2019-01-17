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
  end

  C_Object.define do
    m :yaml_tag, T_String => T_String

    c :ARGF, T_ARGF
    c :ARGV, T_Array[T_String]
    c :Bignum, C_Integer
    c :CROSS_COMPILING, T_Any
    c :DATA, T_File
    c :ENV, T_Hash[T_String, T_String]
    c :FALSE, T_FalseClass
    c :TRUE, T_TrueClass
    c :Fixnum, C_Integer
    c :NIL, T_Nil
    c :RUBY_COPYRIGHT, T_String
    c :RUBY_DESCRIPTION, T_String
    c :RUBY_ENGINE, T_String
    c :RUBY_ENGINE_VERSION, T_String
    c :RUBY_PATCHLEVEL, T_Integer
    c :RUBY_PLATFORM, T_String
    c :RUBY_RELEASE_DATE, T_String
    c :RUBY_REVISION, T_Integer
    c :STDERR, T_IO
    c :STDIN, T_IO
    c :STDOUT, T_IO
    c :TOPLEVEL_BINDING, T_Binding

    c :BasicObject, C_BasicObject
    c :Object, C_Object
    c :Class, C_Class
  end
end
