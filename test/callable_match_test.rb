require "test_helper"

module Ahiru
  class CallableMatchTest < Minitest::Test
    Any = Duck.new
    Thing = Duck.new(Any)

    def test_match_no_args
      a = Callable.new()
      b = Callable.new()
      c = Callable.new(Any, [Callable::Argument.new(Any)])

      assert a <= b
      refute a <= c
      refute c <= a
    end

    def test_match_args
      a = Callable.new(Any, [Callable::Argument.new(Any)])
      b = Callable.new(Any, [Callable::Argument.new(Thing)]) 
      c = Callable.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any)])
      d = Callable.new(Any, [Callable::Argument.new(Thing), Callable::Argument.new(Thing)])
      e = Callable.new()

      refute a <= b
      assert a <= a
      assert b <= a
      assert b <= b
      refute b <= c
      refute c <= b
      assert c <= c

      refute a <= e
      refute b <= e
      refute c <= e
      refute d <= e

      refute e <= a
      refute e <= b
      refute e <= c
      refute e <= d
    end

    def test_match_optional_args
      a = Callable.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any, optional: true)])
      b = Callable.new(Any, [Callable::Argument.new(Thing), Callable::Argument.new(Thing, optional: true)])
      c = Callable.new(Any, [Callable::Argument.new(Thing)])
      d = Callable.new(Any, [Callable::Argument.new(Thing), Callable::Argument.new(Thing)])
      e = Callable.new(Any, [Callable::Argument.new(Any)])
      f = Callable.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any)])
      g = Callable.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any), Callable::Argument.new(Any)])

      h = Callable.new()
      i = Callable.new(Any, [Callable::Argument.new(Any, optional: true)])

      assert a <= a

      refute a <= b
      refute a <= c
      refute a <= d
      refute a <= e
      refute a <= f

      assert b <= a
      assert c <= a
      assert d <= a
      assert e <= a
      assert f <= a

      refute a <= g
      refute g <= a

      assert h <= i
      refute i <= h
    end

    def test_match_variadic_args
      a = Callable.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any, variadic: true)])
      b = Callable.new(Any, [Callable::Argument.new(Thing), Callable::Argument.new(Thing, optional: true)])
      c = Callable.new(Any, [Callable::Argument.new(Thing)])
      d = Callable.new(Any, [Callable::Argument.new(Thing), Callable::Argument.new(Thing)])
      e = Callable.new(Any, [Callable::Argument.new(Any)])
      f = Callable.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any)])
      g = Callable.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any), Callable::Argument.new(Any)])
      h = Callable.new(Any, [Callable::Argument.new(Thing), Callable::Argument.new(Thing), Callable::Argument.new(Thing)])
      i = Callable.new()
      j = Callable.new(Any, [Callable::Argument.new(Thing), Callable::Argument.new(Thing, variadic: true)])

      assert a <= a

      refute a <= b
      refute a <= c
      refute a <= d
      refute a <= e
      refute a <= f
      refute a <= g
      refute a <= h
      refute a <= j

      assert b <= a
      assert c <= a
      assert d <= a
      assert e <= a
      assert f <= a
      assert g <= a
      assert h <= a
      assert j <= a

      refute a <= i
      refute i <= a
    end

    def test_match_kwargs
      a = Callable.new(Any, [], {a: Callable::Argument.new(Any), b: Callable::Argument.new(Any)})
      b = Callable.new(Any, [], {a: Callable::Argument.new(Thing), b: Callable::Argument.new(Thing)})
      c = Callable.new(Any, [], {a: Callable::Argument.new(Any)})
      d = Callable.new(Any, [], {a: Callable::Argument.new(Any), b: Callable::Argument.new(Any), c: Callable::Argument.new(Any)})

      assert a <= a

      refute a <= b
      assert b <= a

      refute a <= c
      refute c <= a
      refute a <= d
      refute d <= a
    end

    def test_match_optional_kwargs
      a = Callable.new(Any, [], {a: Callable::Argument.new(Any), b: Callable::Argument.new(Any, optional: true)})
      b = Callable.new(Any, [], {a: Callable::Argument.new(Thing), b: Callable::Argument.new(Thing)})
      c = Callable.new(Any, [], {a: Callable::Argument.new(Any)})
      d = Callable.new(Any, [], {a: Callable::Argument.new(Any), b: Callable::Argument.new(Any), c: Callable::Argument.new(Any)})

      assert a <= a

      refute a <= b
      assert b <= a

      refute a <= c
      assert c <= a

      refute a <= d
      refute d <= a
    end

    def test_match_block
      a = Callable.new(Any, [], {}, Block.new(Any, [Callable::Argument.new(Any)]))
      b = Callable.new()
      c = Callable.new(Any, [], {}, Block.new(Any, [Callable::Argument.new(Thing)]))
      d = Callable.new(Any, [], {}, Block.new(Any, [Callable::Argument.new(Any), Callable::Argument.new(Any)]))

      assert a <= a

      refute a <= b
      assert a <= c

      refute b <= a
      refute c <= a

      refute a <= d
      refute d <= a
    end
  end
end