module Ahiru
  A = Duck.new name: 'A', free: true
  B = Duck.new name: 'B', free: true
  C = Duck.new name: 'C', free: true
  D = Duck.new name: 'D', free: true
  E = Duck.new name: 'E', free: true
  F = Duck.new name: 'F', free: true
  G = Duck.new name: 'G', free: true
  H = Duck.new name: 'H', free: true
  I = Duck.new name: 'I', free: true
  J = Duck.new name: 'J', free: true
  K = Duck.new name: 'K', free: true
  L = Duck.new name: 'L', free: true
  M = Duck.new name: 'M', free: true
  N = Duck.new name: 'N', free: true
  O = Duck.new name: 'O', free: true
  P = Duck.new name: 'P', free: true
  Q = Duck.new name: 'Q', free: true
  R = Duck.new name: 'R', free: true
  S = Duck.new name: 'S', free: true
  T = Duck.new name: 'T', free: true
  U = Duck.new name: 'U', free: true
  V = Duck.new name: 'V', free: true
  W = Duck.new name: 'W', free: true
  X = Duck.new name: 'X', free: true
  Y = Duck.new name: 'Y', free: true
  Z = Duck.new name: 'Z', free: true

  T_Any         = Duck.new name: "Any"

  T_BasicObject = Duck.define "BasicObject", T_Any
  T_Object      = Duck.define "Object",      T_BasicObject

  T_Module = Duck.define "Module", T_Object, [M]

  T_Class = Duck.define "Class", T_Module, [C]
  C_Class = T_Class[T_Class]

  T_Method = Duck.define "Method", T_Object
  C_Method = T_Class[T_Method]

  C_BasicObject = Duck.define "Class(BasicObject)", T_Class[T_BasicObject]
  C_Object      = T_Class[T_Object]

  T_Nil = T_NilClass = Duck.define "NilClass", T_Object
  C_Nil = C_NilClass = T_Class[T_Nil]
  
  T_Kernel = Duck.define "Kernel"
  M_Kernel = T_Module[T_Kernel]

  T_Numeric  = Duck.define "Numeric",  T_Object
  C_Numeric  = T_Class[T_Numeric]
  T_Integer  = Duck.define "Integer",  T_Numeric
  C_Integer  = T_Class[T_Integer]
  T_Float    = Duck.define "Float",    T_Numeric
  C_Float    = T_Class[T_Float]
  T_Complex  = Duck.define "Complex",  T_Numeric
  C_Complex  = T_Class[T_Complex]
  T_Rational = Duck.define "Rational", T_Numeric
  C_Rational = T_Class[T_Rational]
  T_Real     = T_Integer | T_Float | T_Rational

  T_True  = T_TrueClass  = Duck.define "TrueClass",  T_Object
  C_True  = C_TrueClass  = T_Class[T_TrueClass]
  T_False = T_FalseClass = Duck.define "FalseClass", T_Object
  C_False = C_FalseClass = T_Class[T_FalseClass]
  T_Bool  = T_TrueClass | T_FalseClass

  T_Symbol = Duck.define "Symbol", T_Object
  C_Symbol = T_Class[T_Symbol]

  T_String  = Duck.define "String", T_Object
  C_String  = T_Class[T_String]
  T_Regexp  = Duck.define "Regexp", T_Object
  C_Regexp  = T_Class[T_Regexp]
  T_Pattern = T_String | T_Regexp
  
  T_Encoding = Duck.define "Encoding", T_Object
  C_Encoding = T_Class[T_Encoding]
  
  T_MatchData = Duck.define "MatchData", T_Object
  C_MatchData = T_Class[T_MatchData]

  T_IO = Duck.define "IO", T_Object
  C_IO = T_Class[T_IO]

  T_Exception = Duck.define "Exception", T_Object
  C_Exception = T_Class[T_Exception]

  T_Enumerator = Duck.define "Enumerator", T_Object, [E]
  C_Enumerator = T_Class[T_Enumerator]
  T_Array = Duck.define "Array", T_Object, [T]
  C_Array = T_Class[T_Array]
  T_Hash  = Duck.define "Hash", T_Object, [K, V]
  C_Hash  = T_Class[T_Hash]
  T_Range = Duck.define "Range", T_Object, [R]
  C_Range = T_Class[T_Range]

  T_Proc = Duck.define "Proc", T_Object, [R]
  C_Proc = T_Class[T_Proc]

  T_Binding = Duck.define "Binding", T_Object
  C_Binding = T_Class[T_Binding]

  T_Time = Duck.define "Time", T_Object
  C_Time = T_Class[T_Time]

  T_URI = Duck.define "URI", T_Object
  C_URI = T_Class[T_URI]
  T_URI_Generic = Duck.define "URI::Generic", T_Object
  C_URI_Generic = T_Class[T_URI_Generic]
end