class Foo
  def fib(n)
    return 1 if n <= 1
    return fib(n-1) + fib(n-1)
  end
end

Foo.new.fib(12)