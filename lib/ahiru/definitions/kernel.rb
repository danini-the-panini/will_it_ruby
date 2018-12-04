module Ahiru
  T_Kernel.define do
    m :Array, T_Nil => T_Array[T_Any]
    m :Array, T_Hash[T, Y] => T_Array[T | Y]
    m :Array, T_Array[T] => T_Array[T]
    m :Array, T_Range[T] => T_Array[T]
    m :Array, T => T_Array[T]

    # m :BigDecimal, [T_Real | T_String, !T_Integer] => T(BigDecimal) # TODO: requires BigDecimal

    m :Complex, [T_Numeric, T_Numeric] => T_Complex
    m :Complex, T_String => T_Complex

    m :Float, T_Any => T_Float

    m :Hash, T_Hash[T, Y] => T_Hash[T, Y]
    m :Hash, T_Array[T] => T_Hash[T, T]
    m :Hash, T_Nil => T_Hash[T_Any, T_Any]

    m :Integer, [T_Any, o(T_Integer)] => T_Integer

    # m :Pathname, T_String => T(Pathname) # TODO: requires pathname

    m :Rational, [T_Integer, T_Integer] => T_Rational
    m :Rational, [T_String | T_Float] => T_Rational

    m :String, T_Any => T_String

    m :__callee__, T_Symbol
    m :__dir__, T_String
    m :__method__, T_Symbol
    m :`, T_String => T_String # TODO: what does `cmd` look like in sexp?

    m :abort, o(T_String) => T_Nil

    m :at_exit, T_Proc[T_Any] do
      T_Any
    end

    m :autoload, [T_String | T_Symbol, T_String] => T_Nil
    m :autoload?, [T_String | T_Symbol] => T_String | T_Nil

    m :binding, T_Binding

    m :block_given?, T_Bool
    m :iterator?, T_Bool

    # m :callcc, T, T(Continuation) => T # TODO: requires Continuation

    m :caller, [o(T_Integer), o(T_Integer)] => T_Array[T_String] | T_Nil
    m :caller, T_Range[T_Integer] => T_Array[T_String] | T_Nil

    m :caller_locations, [o(T_Integer), o(T_Integer)] => T_Array[T_String] | T_Nil
    m :caller_locations, T_Range[T_Integer] => T_Array[T_String] | T_Nil

    m :catch, o(T) => E do
      { T => E }
    end
    m :throw, [T_Any, o(T_Any)] => T_Nil

    m :chomp, o(T_String) => T_String

    m :chop, T_String

    m :eval, [T_String, o(T_Binding), o(T_String), o(T_Integer)] => T_Any

    m :exec, T_String => T_Nil
    m :exec, [T_String, T_String, v(T_String)] => T_Nil
    m :exec, [T_Array[T_String], T_String, v(T_String)] => T_Nil

    m :exit, o(T_Bool) => T_Nil
    m :exit!, o(T_Bool) =>  T_Nil

    m :fail, o(T_String) => T_Nil
    m :fail, [T_Exception, o(T_String), o(T_Array[T_String])] => T_Nil

    m :fork, T_Nil
    m :fork, T_Nil do
      { v(T_Any) => T_Any }
    end

    m :format, [T_String, v(T_String)] => T_String

    m :gem_original_require, T_String => T_Bool

    m :gets, [o(T_String), o(T_Integer), chomp: o(T_String)] => T_String | T_Nil
    m :gets, [T_Integer, chomp: o(T_String)] => T_String | T_Nil

    m :global_variables, T_Array[T_Symbol]

    m :gsub, T_Pattern => T_String do
      { o(T_String) => T_Any }
    end
    m :gsub, [T_Pattern, T_String] => T_String

    m :lambda, T_Proc[R] do
      { v(T_Any) => R }
    end
    m :proc, T_Proc[R] do
      { v(T_Any) => R }
    end

    m :load, [T_String, o(T_Bool)] => T_TrueClass

    m :local_variables, T_Array[T_Symbol]

    m :loop, T_Any do
      T_Any
    end
    m :loop, T_Enumerator

    m :p, T_Nil
    m :p, T => T
    m :p, [T, v(T)] => T_Array[T]
    m :pretty_inspect, T_String
    m :print, [T_Any, v(T_Any)] => T_Nil
    m :puts, [T_Any, v(T_Any)] => T_Nil
    m :printf, [T_IO, T_String, v(T_Any)] => T_Nil
    m :printf, [T_String, v(T_Any)] => T_Nil
    m :putc, T_Integer => T_Integer

    m :raise, o(T_String) => T_Nil
    m :raise, [T_Exception, o(T_String), o(T_Array[T_String])] => T_Exception

    m :rand, T_Float
    m :rand, T_Numeric => T_Numeric

    m :readline, [o(T_String | T_Integer)] => T_String
    m :readline, [T_String, T_Integer] => T_String
    m :readlines, [o(T_String | T_Integer)] => T_String
    m :readlines, [T_String, T_Integer] => T_String

    m :require_relative, T_String => T_Bool

    m :select, T_Array[T_IO] => T_Array[T_String] | T_Nil
    m :select, [T_Array[T_IO] | T_Nil, o(T_Array[T_IO] | T_Nil), o(T_Array[T_IO]), o(T_Numeric)] => T_Array[T_String] | T_Nil

    m :set_trace_func, T_Proc[T_Any] => T_Proc[T_Any]
    m :set_trace_func, T_Nil => T_Nil

    m :sleep, T_Integer => T_Numeric

    _fd = T_Symbol | T_Integer | T_IO
    _spawn_options = {
      unsetenv_others:     o(T_Bool),
      pgroup:              o(T_Bool | T_Integer),
      new_pgroup:          o(T_Bool),
      rlimit_resourcename: o(T_Any),
      umask:               o(T_Integer),
      key:                 o(_fd | T_Array[_fd]),
      value:               o(_fd | T_String | T_Symbol | T_Array[T_Any]),
      close_others:        o(T_Bool),
      chdir:               o(T_String)
    }
    m :spawn, [T_String, _spawn_options] => T_Nil
    m :spawn, [T_String, T_String, v(T_String), _spawn_options] => T_Nil
    m :spawn, [T_Array[T_String], T_String, v(T_String), _spawn_options] => T_Nil
    m :spawn, [T_Hash[T_String, T_String | T_Nil], T_String, _spawn_options] => T_Nil
    m :spawn, [T_Hash[T_String, T_String | T_Nil], T_String, T_String, v(T_String), _spawn_options] => T_Nil
    m :spawn, [T_Hash[T_String, T_String | T_Nil], T_Array[T_String], T_String, v(T_String), _spawn_options] => T_Nil

    m :system, [T_String, _spawn_options] => T_Bool | T_Nil
    m :system, [T_String, T_String, v(T_String), _spawn_options] => T_Bool | T_Nil
    m :system, [T_Array[T_String], T_String, v(T_String), _spawn_options] => T_Bool | T_Nil
    m :system, [T_Hash[T_String, T_String | T_Nil], T_String, _spawn_options] => T_Bool | T_Nil
    m :system, [T_Hash[T_String, T_String | T_Nil], T_String, T_String, v(T_String), _spawn_options] => T_Bool | T_Nil
    m :system, [T_Hash[T_String, T_String | T_Nil], T_Array[T_String], T_String, v(T_String), _spawn_options] => T_Bool | T_Nil

    m :sprintf, [T_String, v(T_Any)] => T_String

    m :srand, o(T_Integer) => T_Integer

    m :sub, T_Pattern => T_String do
      { o(T_String) => T_Any }
    end
    m :sub, [T_Pattern, T_String] => T_String

    m :syscall, [T_Integer, v(T_Any)] => T_Integer

    m :test, T_String => T_Integer | T_Time | T_Bool | T_Nil

    m :trace_var, [T_Symbol, T_String | T_Proc] => T_Nil
    m :trace_var, T_Symbol => T_Nil do
      { o(T_Any) => T_Any }
    end

    m :trap, [T_Integer | T_String] => T_Any do
      T_Any
    end
    m :trap, [T_Integer | T_String, T_String | T_Proc] => T_Any

    m :untrace_var, T_Symbol => T_Array[T_Proc] | T_Nil
    m :untrace_var, [T_Symbol, T_String | T_Proc] => T_Array[T_Proc] | T_Nil

    m :warn, [T_Any, v(T_Any)] => T_Nil
  end

  M_Kernel.define do
    m :URI, [T_URI_Generic | T_String] => T_URI
    m :open, [T_String, o(T_Integer), o(T_Hash[T_Symbol, T_Any])] => T_IO | T_Nil
    m :open, [T_String, o(T_Integer), o(T_Hash[T_Symbol, T_Any])] => T do
      { T_IO => T }
    end

    m :pp, T => T
    m :pp, [T, o(T)] => T_Array[T]
  end
end