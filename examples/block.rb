class Foo
  def foo
    1 + yield(2)
  end
end

Foo.new.foo do |n|
  n + 3
end