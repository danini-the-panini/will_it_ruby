require 'gemologist/definition'

Geomologist::Definition.add_class_definition(BasicObject) do
  add_class_method_definition :URI, [T(URI::Generic) | T(String)] => T(URI)
  add_class_method_definition :open, [T(String), !T(Integer), !T(Hash, Symbol, Any)] => T(IO) | Nil
  add_class_method_definition :open, [T(String), !T(Integer), !T(Hash, Symbol, Any)] => T, T(IO) => T

  add_class_method_definition :pp, T => T
  add_class_method_definition :pp, [T, +T] => T(Array, T)

  add_method_definition :Array, Nil => T(Array, Any)
  add_method_definition :Array, T(Hash, T, Y) => T(Array, T | Y)
  add_method_definition :Array, T(Array, T) => T(Array, T)
  add_method_definition :Array, T(Range, T) => T(Array, T)
  add_method_definition :Array, T => T(Array, T)

  add_method_definition :BigDecimal, [Real | T(String), !T(Integer)] => T(BigDecimal)

  add_method_definition :Complex, [T(Numeric), T(Numeric)] => T(Complex), 
  add_method_definition :Complex, T(String) => T(Complex)

  add_method_definition :Float, Any => T(Float)

  add_method_definition :Hash, T(Hash, T, Y) => T(Hash, T, Y)
  add_method_definition :Hash, T(Array, T) => T(Hash, T, T)
  add_method_definition :Hash, Nil => T(Hash, Any, Any)

  add_method_definition :Integer, [Any, !T(Integer)] => T(Integer)

  add_method_definition :Pathname, T(String) => T(Pathname)

  add_method_definition :Rational, [T(Integer), T(Integer)] = >T(Rational)
  add_method_definition :Rational, [T(String) | T(Float)] => T(Rational)

  add_method_definition :String, Any => T(String)

  add_method_definition :__callee__, T(Symbol)
  add_method_definition :__dir__, T(String)
  add_method_definition :__method__, T(Symbol)
  add_method_definition :`, T(String) => T(String) # TODO: what does `cmd` look like in sexp?

  add_method_definition :abort, !T(String) => Nil

  add_method_definition :at_exit, T(Proc, Any), [] => Any

  add_method_definition :autoload, [T(String) | T(Symbol), T(String)] => Nil, 
  add_method_definition :autoload?, [T(String) | T(Symbol)] => T(String) | Nil

  add_method_definition :binding, T(Binding)

  add_method_definition :block_given?, Bool
  add_method_definition :iterator?, Bool

  add_method_definition :callcc, T, T(Continuation) => T

  add_method_definition :caller, [!T(Integer), !T(Integer)] => T(Array, String) | Nil
  add_method_definition :caller, T(Range, Integer) => T(Array, String) | Nil

  add_method_definition :caller_locations, [!T(Integer), !T(Integer)] => T(Array, String) | Nil
  add_method_definition :caller_locations, T(Range, Integer) => T(Array, String) | Nil

  add_method_definition :catch, !T => E, T => E
  add_method_definition :throw, [Any, !Any] => Nil

  add_method_definition :chomp, !T(String) => T(String)

  add_method_definition :chop, T(String)

  add_method_definition :eval, [T(String), !T(Binding), !T(String), !T(Integer)] => Any

  add_method_definition :exec, T(String) => Nil
  add_method_definition :exec, [T(String), T(String), +T(String)] => Nil
  add_method_definition :exec, [T(Array, String), T(String), +T(String)] => Nil

  add_method_definition :exit, !Bool => Nil
  add_method_definition :exit!,!Bool =>  Nil

  add_method_definition :fail, !T(String) => Nil
  add_method_definition :fail, [T(Exception), !T(String), !T(Array, String)] => Nil, T(Exception)

  add_method_definition :fork, Nil
  add_method_definition :fork, Nil, +Any => Any

  add_method_definition :format, [T(String), +T(String)] => T(String)

  add_method_definition :gem_original_require, T(String) => Bool

  add_method_definition :gets, [!T(String), !T(Integer), chomp: !T(String)] => T(String) | Nil
  add_method_definition :gets, [T(Integer), chomp: !T(String)] => T(String) | Nil

  add_method_definition :global_variables, T(Array, Symbol)

  add_method_definition :gsub, Pattern => T(String), !T(String) => Any
  add_method_definition :gsub, [Pattern, T(String)] => T(String)

  add_method_definition :lambda, T(Proc, R, +T), +T => R
  add_method_definition :proc, T(Proc, R, +T), +T => R

  add_method_definition :load, [T(String), !Bool] => T(TrueClass)

  add_method_definition :local_variables, T(Array, Symbol)

  add_method_definition :loop, Any, [] => Any
  add_method_definition :loop, Enumerator

  add_method_definition :p, Nil
  add_method_definition :p, T => T
  add_method_definition :p, [T, +T] => T(Array, T)
  add_method_definition :pretty_inspect, T(String)
  add_method_definition :print, [Any, +Any] => Nil
  add_method_definition :puts, [Any, +Any] => Nil
  add_method_definition :printf, [T(IO), T(String), +Any] => Nil
  add_method_definition :printf, [T(String), +Any] => Nil
  add_method_definition :putc, T(Integer), T(Integer)

  add_method_definition :raise, !T(String) => Nil
  add_method_definition :raise, [T(Exception), !T(String), !T(Array, String)] => Nil, T(Exception)

  add_method_definition :rand, T(Float)
  add_method_definition :rand, T(Numeric), T(Numeric)

  add_method_definition :readline, [!(T(String) | T(Integer))] => T(String)
  add_method_definition :readline, [T(String), T(Integer)] => T(String)
  add_method_definition :readlines, [!(T(String) | T(Integer))] => T(String)
  add_method_definition :readlines, [T(String), T(Integer)] => T(String)

  add_method_definition :require_relative, Bool, T(String)

  add_method_definition :select, T(Array, IO) => T(Array, String) | Nil
  add_method_definition :select, [T(Array, IO) | Nil, !(T(Array, IO) | Nil), !T(Array, IO), !T(Numeric)] => T(Array, String) | Nil

  _set_trace_func_proc_signature = T(Proc, Any, !T(String), !T(String), !T(Integer), !T(Integer), !T(Binding), !T(String))
  add_method_definition :set_trace_func, _set_trace_func_proc_signature => _set_trace_func_proc_signature
  add_method_definition :set_trace_func, Nil => Nil

  add_method_definition :sleep, T(Integer), T(Numeric)

  add_method_definition :spawn, [T(String), !T(Hash, Symbol, Any)] => Nil
  add_method_definition :spawn, [T(String), T(String), +T(String), !T(Hash, Symbol, Any)] => Nil
  add_method_definition :spawn, [T(Array, String), T(String), +T(String), !T(Hash, Symbol, Any)] => Nil
  add_method_definition :spawn, [T(Hash, String, T(String) | Nil), T(String), !T(Hash, Symbol, Any)] => Nil
  add_method_definition :spawn, [T(Hash, String, T(String) | Nil), T(String), T(String), +T(String), !T(Hash, Symbol, Any)] => Nil
  add_method_definition :spawn, [T(Hash, String, T(String) | Nil), T(Array, String), T(String), +T(String), !T(Hash, Symbol, Any)] => Nil

  add_method_definition :system, [T(String), !T(Hash, Symbol, Any)] => Bool | Nil
  add_method_definition :system, [T(String), T(String), +T(String), !T(Hash, Symbol, Any)] => Bool | Nil
  add_method_definition :system, [T(Array, String), T(String), +T(String), !T(Hash, Symbol, Any)] => Bool | Nil
  add_method_definition :system, [T(Hash, String, T(String) | Nil), T(String), !T(Hash, Symbol, Any)] => Bool | Nil
  add_method_definition :system, [T(Hash, String, T(String) | Nil), T(String), T(String), +T(String), !T(Hash, Symbol, Any)] => Bool | Nil
  add_method_definition :system, [T(Hash, String, T(String) | Nil), T(Array, String), T(String), +T(String), !T(Hash, Symbol, Any)] => Bool | Nil

  add_method_definition :sprintf, [T(String), +Any] => T(String)

  add_method_definition :srand, !T(Integer) => T(Integer)

  add_method_definition :sub, Pattern => T(String), !T(String) => Any
  add_method_definition :sub, [Pattern, T(String)] => T(String)

  add_method_definition :syscall, [T(Integer), +Any] => T(Integer)

  add_method_definition :test, T(String) => T(Integer) | T(Time) | Bool | Nil

  add_method_definition :trace_var, [T(Symbol), T(String) | T(Proc)] => Nil
  add_method_definition :trace_var, T(Symbol) => Nil, !Any => Any

  add_method_definition :trap, T(Integer) | T(String) => Any, [] => Any
  add_method_definition :trap, [T(Integer) | T(String), T(String) | T(Proc)] => Any

  add_method_definition :untrace_var, T(Symbol) => T(Array, Proc) | Nil, 
  add_method_definition :untrace_var, [T(Symbol), T(Sring) | T(Proc)] => T(Array, Proc) | Nil

  add_method_definition :warn, [Any, +Any] => Nil
end