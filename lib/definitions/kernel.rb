require 'gemologist/definition'

Geomologist::Definition.add_class_definition(BasicObject) do
  add_class_method_definition :URI, T(URI), T(URI::Generic) | T(String)
  add_class_method_definition :open, T(IO) | Nil, T(String) # TODO: can take a block
  add_class_method_definition :open, T(IO) | Nil, T(String), T(Integer)
  add_class_method_definition :open, T(IO) | Nil, T(String), T(Integer), T(Hash, Symbol, Any)

  add_class_method_definition :pp, Any # TODO: variadic

  add_method_definition :Array, T(Array, Any), Nil
  add_method_definition :Array, T(Array, X | Y), T(Hash, X, Y)
  add_method_definition :Array, T(Array, X), T(Array, X)
  add_method_definition :Array, T(Array, X), T(Range, X)
  add_method_definition :Array, T(Array, X), X

  add_method_definition :BigDecimal, T(BigDecimal) # TODO: variadic

  add_method_definition :Complex, T(Complex), T(Numeric), T(Numeric)
  add_method_definition :Complex, T(Complex), T(String)

  add_method_definition :Float, T(Float), Any

  add_method_definition :Hash, T(Hash, X, Y), T(Hash, X, Y)
  add_method_definition :Hash, T(Hash, X, X), T(Array, X)
  add_method_definition :Hash, T(Hash, Any, Any), Nil

  add_method_definition :Integer, T(Integer), Any
  add_method_definition :Integer, T(Integer), Any, T(Integer)

  add_method_definition :Pathname, T(Pathname), T(String) # TODO: require 'pathname'

  add_method_definition :Rational, T(Rational), T(Integer), T(Integer)
  add_method_definition :Rational, T(Rational), T(String) | T(Float)

  add_method_definition :String, T(String), Any

  add_method_definition :__callee__, T(Symbol)
  add_method_definition :__dir__, T(String)
  add_method_definition :__method__, T(Symbol)
  add_method_definition :`, T(String), T(String) # TODO: what does `cmd` look like in sexp?

  add_method_definition :abort, Nil
  add_method_definition :abort, Nil, T(String)

  add_method_definition :at_exit, T(Proc, Any) # TODO: block

  add_method_definition :autoload, Nil, T(String) | T(Symbol), T(String)
  add_method_definition :autoload?, T(String) | Nil, T(String) | T(Symbol)

  add_method_definition :binding, T(Binding)

  add_method_definition :block_given?, Bool
  add_method_definition :iterator?, Bool

  add_method_definition :callcc, Any # TODO: takes a block, require 'continuation'

  add_method_definition :caller, T(Array, String) | Nil
  add_method_definition :caller, T(Array, String) | Nil, T(Integer)
  add_method_definition :caller, T(Array, String) | Nil, T(Integer), T(Integer)
  add_method_definition :caller, T(Array, String) | Nil, T(Range, Integer)

  add_method_definition :caller_locations, T(Array, String) | Nil
  add_method_definition :caller_locations, T(Array, String) | Nil, T(Integer)
  add_method_definition :caller_locations, T(Array, String) | Nil, T(Integer), T(Integer)
  add_method_definition :caller_locations, T(Array, String) | Nil, T(Range, Integer)

  add_method_definition :catch, Any # TODO: takes a block
  add_method_definition :catch, Any, Any
  add_method_definition :throw, Any, Any
  add_method_definition :throw, Any, Any, Any

  add_method_definition :chomp, T(String) # Available only when -p/-n command line option specified.
  add_method_definition :chomp, T(String), T(String)

  add_method_definition :chop, T(String) # Available only when -p/-n command line option specified.

  add_method_definition :eval, Any, T(String)
  add_method_definition :eval, Any, T(String), T(Binding)
  add_method_definition :eval, Any, T(String), T(Binding), T(String)
  add_method_definition :eval, Any, T(String), T(Binding), T(String), T(Integer)

  add_method_definition :exec, Nil, T(String) # TODO: can be variadic

  add_method_definition :exit, Nil
  add_method_definition :exit, Nil, Bool
  add_method_definition :exit!, Nil
  add_method_definition :exit!, Nil, Bool

  add_method_definition :fail, Nil
  add_method_definition :fail, Nil, T(String)
  add_method_definition :fail, Nil, T(Exception)
  add_method_definition :fail, Nil, T(Exception), T(String)
  add_method_definition :fail, Nil, T(Exception), T(String), T(Array, String) # TODO: array of string or any? callback info is usually a string

  add_method_definition :fork, Nil # TODO: takes optional block

  add_method_definition :format, T(String), T(String) # TODO: variadic

  add_method_definition :gem_original_require, Bool, T(String)

  # TODO: optional trailing argument "getline_args" could be kwargs?
  add_method_definition :gets, T(String) | Nil
  add_method_definition :gets, T(String) | Nil, T(Hash, Symbol, Any)
  add_method_definition :gets, T(String) | Nil, T(String) | T(Integer)
  add_method_definition :gets, T(String) | Nil, T(String) | T(Integer), T(Hash, Symbol, Any)
  add_method_definition :gets, T(String) | Nil, T(Integer), T(String)
  add_method_definition :gets, T(String) | Nil, T(Integer), T(String), T(Hash, Symbol, Any)

  add_method_definition :global_variables, T(Array, Symbol)

  add_method_definition :gsub, T(String), T(String) | T(Regexp) # TODO: can take a block, Available only when -p/-n command line option specified.
  add_method_definition :gsub, T(String), T(String) | T(Regexp), T(String)

  add_method_definition :lambda, T(Proc, Any) # TODO: takes block
  add_method_definition :proc, T(Proc, Any) # TODO: takes block

  add_method_definition :load, T(TrueClass), T(String)
  add_method_definition :load, T(TrueClass), T(String), Bool

  add_method_definition :local_variables, T(Array, Symbol)

  add_method_definition :loop, Any # TODO: takes block
  add_method_definition :loop, Enumerator # TODO: no block

  add_method_definition :p, Nil
  add_method_definition :p, X, X
  add_method_definition :p, Array(X) # TODO: variadic...
  add_method_definition :pretty_inspect, T(String)
  add_method_definition :print, Nil, Any # TODO: variadic...
  add_method_definition :puts, Nil, Any # TODO: variadic...
  add_method_definition :printf, Nil, T(IO), T(String) # TODO: variadic...
  add_method_definition :printf, Nil, T(String) # TODO: variadic...
  add_method_definition :putc, T(Integer), T(Integer)

  add_method_definition :raise, Nil
  add_method_definition :raise, Nil, T(String)
  add_method_definition :raise, Nil, T(Exception)
  add_method_definition :raise, Nil, T(Exception), T(String)
  add_method_definition :raise, Nil, T(Exception), T(String), T(Array, String)

  add_method_definition :rand, T(Float)
  add_method_definition :rand, T(Numeric), T(Numeric)

  add_method_definition :readline, T(String)
  add_method_definition :readline, T(String), T(String) | T(Integer)
  add_method_definition :readline, T(String), T(String), T(Integer)
  add_method_definition :readlines, T(Array, String)
  add_method_definition :readlines, T(Array, String), T(String) | T(Integer)
  add_method_definition :readlines, T(Array, String), T(String), T(Integer)

  add_method_definition :require_relative, Bool, T(String)

  add_method_definition :select, T(Array, String) | Nil, T(Array, IO)
  add_method_definition :select, T(Array, String) | Nil, T(Array, IO) | Nil, T(Array, IO)
  add_method_definition :select, T(Array, String) | Nil, T(Array, IO) | Nil, T(Array, IO) | Nil, T(Array, IO)
  add_method_definition :select, T(Array, String) | Nil, T(Array, IO) | Nil, T(Array, IO) | Nil, T(Array, IO), T(Numeric)

  add_method_definition :set_trace_func, T(Proc), T(Proc) # TODO: proc takes _up to_ 6 params
  add_method_definition :set_trace_func, Nil, Nil

  add_method_definition :sleep, T(Integer), T(Numeric)

  add_method_definition :spawn, T(Integer), T(String) # TODO: can be variadic
  add_method_definition :spawn, T(Integer), T(Hash, String, T(String) | Nil), T(String)
  add_method_definition :spawn, T(Integer), T(Hash, String, T(String) | Nil), T(String), T(Hash, Symbol, Any) # TODO: trailing options hash could be kwargs

  add_method_definition :system, Bool | Nil, T(String) # TODO: can be variadic
  add_method_definition :system, Bool | Nil, T(Hash, String, T(String) | Nil), T(String)
  add_method_definition :system, Bool | Nil, T(Hash, String, T(String) | Nil), T(String), T(Hash, Symbol, Any) # TODO: trailing options hash could be kwargs

  add_method_definition :sprintf, T(String), T(String) # TODO: variadic...

  add_method_definition :srand, T(Integer)
  add_method_definition :srand, T(Integer), T(Integer)

  add_method_definition :sub, T(String), T(String) | T(Regexp) # TODO: can take a block, Available only when -p/-n command line option specified.
  add_method_definition :sub, T(String), T(String) | T(Regexp), T(String)

  add_method_definition :syscall, T(Integer), T(Integer) # TODO: variadic

  add_method_definition :test, T(Integer) | T(Time) | Bool | Nil, T(String)

  add_method_definition :trace_var, Nil, T(Symbol) # TODO: takes a block
  add_method_definition :trace_var, Nil, T(Symbol), T(String) | T(Proc)

  add_method_definition :trap, Any, T(Integer) | T(String) # TODO: takes a block
  add_method_definition :trap, Any, T(Integer) | T(String), T(String) | T(Proc)

  add_method_definition :untrace_var, T(Array, Proc) | Nil, T(Symbol)
  add_method_definition :untrace_var, T(Array, Proc) | Nil, T(Symbol), T(Sring) | T(Proc)

  add_method_definition :warn, Nil, T(String) # TODO: variadic...
end