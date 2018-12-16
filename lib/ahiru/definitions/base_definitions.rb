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

  Self      = Duck.new name: 'Self',      free: true
  SelfClass = Duck.new name: 'SelfClass', free: true

  T_Any         = Duck.new name: "Any"

  T_BasicObject = Duck.define "BasicObject", T_Any
  T_Object      = Duck.define "Object",      T_BasicObject

  T_Module = Duck.define "Module", T_Object, [M]

  T_Class = Duck.define "Class", T_Module, [C]
  C_Class = T_Class[T_Class]

  C_BasicObject = T_Class[T_BasicObject]
  C_Object      = T_Class[T_Object]

  def self.define_class(name, super_type = T_Object, generics = [], enclosing_module = nil)
    normal_name = name.gsub('::', '_')
    type = Duck.define name, super_type, generics, enclosing_module
    c_type = type.class_type
    const_set :"T_#{normal_name}", type
    const_set :"C_#{normal_name}", c_type
    (enclosing_module || T_Object).add_constant name.split('::').last.to_sym, c_type
  end

  def self.define_module(name, enclosing_module = nil)
    normal_name = name.gsub('::', '_')
    type = Duck.define name, nil, [], enclosing_module
    m_type = T_Module[type]
    const_set :"T_#{normal_name}", type
    const_set :"M_#{normal_name}", m_type
    (enclosing_module || T_Object).add_constant name.split('::').last.to_sym, m_type
  end

  define_module "Kernel"

  define_class "Method"
  define_class "NilClass"
  T_Nil = T_NilClass
  C_Nil = C_NilClass

  define_class "Numeric"
  define_class "Integer", T_Numeric
  define_class "Float", T_Numeric
  define_class "Complex", T_Numeric
  define_class "Rational", T_Numeric
  T_Real = T_Integer | T_Float | T_Rational

  define_class "TrueClass"
  T_True = T_TrueClass
  C_True = C_TrueClass
  define_class "FalseClass"
  T_False = T_FalseClass
  C_False = C_FalseClass
  T_Bool  = T_TrueClass | T_FalseClass

  define_class "Symbol"

  define_class "String"
  define_class "Regexp"
  T_Pattern = T_String | T_Regexp
  
  define_class "Encoding"
  
  define_class "MatchData"

  define_class "IO"
  define_class "File", T_IO

  define_class "ARGF"

  define_class "Exception"

  define_class "Enumerator", T_Object, [E]
  define_class "Array", T_Object, [T]
  define_class "Hash", T_Object, [K, V]
  define_class "Range", T_Object, [R]

  define_class "Proc", T_Object, [R]

  define_class "Binding"

  define_class "Time"

  define_module "URI"
  define_class "URI::Generic", T_Object, [], M_URI
end