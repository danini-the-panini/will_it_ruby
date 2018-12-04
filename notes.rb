# root scope is of type Module<Kernel> (??)

def qux(x) # define method on root scope
  x.upcase # x has a duck-type of method "upcase" returning unknown type
end

# qux has a free type variable, T, which denotes the possible result of calling upcase on its argument
# finding a call to qux should then investigate the argument's upcase method to determine the possible return type
# definition could look like this:

# qux<T>(Duck(upcase()->T)) -> T

class Foo # define type, set constant on root scope
  def bar # define method on Foo type (since current scope is Class<Foo>)
    "asdf" # bar returns String
  end
end

# Foo type is a a subclass of Object because it has no other superclass
# bar is a simple method with no free types, and can be defined as follows:

# Foo#bar() -> String

f = Foo.new # f is an lvar of type Foo

# f.bar returns a string, and string has a method upcase that returns a string
a = f.bar.upcase # a is an lvar of type String

# calling qux with f.bar should populate the free type T with String because String#upcase -> String
b = qux(f.bar) # b is an lvar of type string

# this should attempt to call Foo#baz, which is undefined.
def norf
  f.baz
end
# Instead of failing immediately, it should treat it successfully and record the attempt
# The assumed type is something along the lines of:

# Foo#baz<T>() -> T

# where T is a free type
# now, one of two things can happen: 1. the process ends without seeing a definition matching Foo#baz, and it fails
# or two, a definition for Foo#baz comes later, and the mystery is resolved

# here, we assume "Bar" is a class that is defined (so we pre-emptively define it) and set the return type to "Bar"
# we _could_ also just assume Bar is a constant of a type Duck(new() -> E), where the return type is E which is a free type
# This is more "correct" but it is unlikely
# One way we can allow this is that all Classes that are defined will be of a type that conforms to
# Duck(new(*) -> E) where * is the signature of E#initialize, and E is the type itself
# Then if/when Bar _is_ defined, it will propagate back here.
# However, we need to be careful, as the definition of "new" dedends on the definition of a Bar#initialize
# We may need to wait for a class to be _finished_ being defined before we propagate, therefore its initialize is set
def asdf
  Bar.new
end

class Bar
  attr_accessor :a

  def initialize(a) # this ought to cause a contradiction with the "asdf" method above, since the signature does not match
    @a = a
    @b = "asdf"
    @c = 7
  end

  def do_thing
    @b.upcase
  end

  def b=(b)
    @b = b
  end

  def c
    @c * 7
  end
end

# Bar has three known ivars: @a, @b, and @c
# Therefore it has three free types, one for each type
# attr_accessor, attr_writer, and any method that sets an ivar from the "outside" immediately makes the ivar's type almost completely unknown
# However, we can still set the types as some sort of free types A, B, and C respectively
# Because of Bar#do_thing, B must at least conform to Duck(upcase() -> T). This will allow for detecting weird things like setting @b to a number or nil
# A is a completely unknown free type at this point, since we know nothing about it
# C can definitely be rules as an integer, since it cannot be affected by the outside world and is only ever set to integer values
# B might be construed as a String, but needs to be malleable since it can be affected by the outside world
# We may need to set it to something like a "Candidate" type which then gets concreted once the class definition has ended
# However, what if the class gets reopened and something is written that could change the type? OR monkey patching gets a slap on the wrist and is not allowed to change a type
# could be tricky with Duck types, for example B only has the upcase method, but since we all know it's really a string, you could open up the class and call a different string method
# This would _have_ to append that other string method to the existing Duck type

def thing(a)
  if a.nil?
    :nope
  else
    a.something
  end
end
# Okay, so E#nil? is a special case. If used in a conditional like this, we can safely assume that A is of type NilClass or not (same as E#is_a?(C))
# Do, in this case a is possbily of type NilClass? Or, it's just a free type Duck(nil?() -> B, something() -> T) and thing returns Symbol | T
# OR is a of type Duck(something() -> T) | Nil, and in the if branch, a becomes Nil and in the else branch a become Duck(something() -> T)
# This is tricky since we would have to back-propagate the type based on if statements
# perhaps leave this one alone for now...

if foo
  :a
else
  :b
end

# In this case, we can determine if foo is either NilClass | FalsClass, or anything but those two


# IDEA

# Duck() [the empty duck type] is the "Any" type. It will match any and all things
# Each free type could just be a new instance of the empty Duck type
# BUT whenever you call something on an empty Duck type, it immediately back-propagates a potential method definition onto it

# foo(Duck(upcase() -> T)) -> T
def foo(a)
  a.upcase
end

# foo(Duck(strip() -> Duck(upcase() -> T))) -> T
def foo(a)
  a.strip.upcase
end

# foo(Duck(+(B) -> T, B) -> T
def foo(a, b)
  a + b
end

# A call to foo, e.g.
foo(1, 2)
# would find that 1 has a + method that takes in a numeric
# this would match B because B is 2
# and it returns an Integer, therefore resolving T as an integer

# If you were to write something like
foo(nil, "asdf")
# You would get a contradiction, becuase the NilClass type has no method + that takes in a String

# REVELATION: It's Ducks all the way down

# Type definitions are just Ducks with lots of methods defined
# e.g. the following class:

class Thing
  def quack
    "Quack!"
  end
end

# The only thing "special" about it is that it defines a constant Thing that is of type Duck(new() -> Duck(quack() -> String))

# We can still have inheritence knowledge, for example: any Duck can have a SuperDuck, so to speak
# This can be useful because a lot of the standard libraries are not Duck typed, but more concrete
# For example, Integer#+ can only take in numerics, and there are "overloaded" methods that might return different numerics
# So, which Duck types are usually matched on their interfaces, sometimes a Duck type is matched for what it really is
# So in the above case, Thing#new returns a Duck type, but it is still known to be an instance of Thing, which is a subclass of Object.
# But also, Object is also "just another duck"

class Thing
  def initialize(a)
    @a = a
  end

  def a
    @a + 2
  end

  def self.foo
    "foo"
  end
end

# Class(Thing) = Duck(new(A) -> Thing, foo() -> String)
# Thing = Duck(a() -> T)
# A = Duck(+(Integer) -> T)

def bar(a)
  a + 1
end

def foo(a)
  bar(a.thing)
end

def foo2(a)
  bar(a.thing) + 7
end

# bar(Duck(+(Integer) -> T)) -> T
# foo(Duck(thing() -> Duck(+(Integer) -> T))) -> T
# foo(Duck(thing() -> Duck(+(Integer) -> Duck(+(Integer) -> T)))) -> T

class Thing1
  def thing
    1
  end
end

class Thing2
  def thing
    "asdf"
  end
end

class HasPlus
  def thing
    self
  end

  def +(x)
    1 + x
  end
end

class WeirdPlus
  def thing
    self
  end

  def +(x)
    "+ #{x}"
  end
end

foo(Thing1.new) # YES
foo(Thing2.new) # NO!

foo2(HasPlus.new) # YES
foo2(WeirdPlus.new) # NO?

# Duck type matching

def foo(a)
  a + 1
end

# foo(Duck(+(Integer) -> T)) -> T

foo(1)      # check: foo(Integer) ... yes, Integer has method +(Integer) -> Integer ... success and T = Integer
foo("asdf") # check: foo(String) ... yes, String has a method +, but it is +(String) -> String. String does not match Integer ... fail
foo(a_duck) # check: foo(Duck(+(Numeric) -> String)) ... yes, it matches and T = String
foo(quack)  # check: foo(Duck(+(Duck(to_i() -> Integer)) -> Integer)) ... success and T = Integer

# ...... ?

def foo
  Foo.new
end

# foo() -> T, generate maybe constant Foo = Duck(maybe new() -> T)

class Foo
end

# defines Foo
# finds maybe constant, un-maybe's it, back propagates to re-define foo as foo() -> Foo

class Foo
  def initialize(a)
  end
end

# defines Foo
# finds maybe constant, attempts to un-maybe it, but hits maybe method new() that does not match Foo.new(A) -> Foo
# back-propagates failure to foo method, says Foo has no matching method new that takes 0 arguments, candidates are Foo.new(A)

# If Foo is never defined, then all maybes get errors that back-propagate to their origin
# in this case, the foo method will have something like undefined constant Foo

# Classes and Instances

# Ruby is weird, classes are objects that are instances of Class, which is itself an instance of itself...?

class Foo < Bar
end

# Class(Foo) = Duck(new() -> Foo) < Class(Bar)
# type(Foo)  = Duck()             < Bar


# GENERIC TYPES!?!?!?!?!

# Arrays and Hashes must have element types
# But what about your own "Generic" type?
# e.g.

class Wrapper
  def initialize(e)
    @e
  end

  def e
    @e
  end

  def e=(x)
    @e = x
  end
end

# This bastard is going to have a free type E that can bloody-well be anything :/

w = Wrapper.new("asd") # Do we make this of type Wrapper<String> and complain if you put something other than a string in it?
w.e = 1 # WARNING

# And subclasses?

class Top; end
class Bottom < Top; end

w = Wrapper.new(Bottom.new) # Wrapper<Bottom>
w.e = Top.new # re-write w as a Wrapper<Top> now?

# What if you "get" a wrapper object from someone else? How do you know what to do with it?
# Mutations are nasty things

def change_wrapper(x)
  x.e = 7
end
w = Wrapper.new("foo")
change_wrapper(w)
w.e # Could be anything :/

# change_wrapper(Duck(e=(Integer) -> Integer)) -> Integer

# we'll come back to that

# CHECKING DUCKS AT RUNTIME

# respond_to? is a special method, esp. for duck typing

def do_a_thing(foo)
  if foo.respond_to?(:bar)
    do_something_with(foo)
  else
    do_something_else
  end
end

foo = something_we_dont_know
do_a_thing(foo)

# do_a_thing(T) -> ?
# T = Duck()
# In the first branch, T becomes Duck(foo(*) -> ?)
# In the second branch, T becomes some kind of negative-duck... like Duck(-foo). i.e. a duck type that explicitely _cannot_ quack a certain way

# We could do a similar thing with is_a? and nil?, because all they are doing is saying "Does this duck quack like this other duck or not?"

class Foo
  def bar
  end
end

if foo.is_a?(Foo)
else
end

# In the true case, foo "becomes" a Foo, i.e. it immediately inherits Duck(bar() -> ?)
# In the false case, foo is _not_ a foo, but it could be anything, so we don't want to rule out the possibility that is might have a bar method


# OPTIONAL AND VARIADIC

class Foo1
  def foo(a, b=1) # foo(A, B?) -> Nil
  end
end

class Foo2
  def foo(a) # foo(A) -> Nil
  end
end

class Foo3
  def foo(a, b) # foo(A, B) -> Nil
  end
end

class Foo4
  def foo(a, *b) # foo(A, *B) -> Nil
  end
end

def bar1(f)
  f.foo(1)
  f.foo(1, 2)
end
# bar1(Duck(foo(Integer) -> ?, foo(Integer, Integer) -> T)) -> T
# Foo1: yes
# Foo2: no
# Foo3: no
# Foo4: yes

def bar2(f)
  f.foo(1)
end
# bar1(Duck(foo(Integer) -> T)) -> T
# Foo1: yes
# Foo2: yes
# Foo3: no
# Foo4: yes


def bar3(f)
  f.foo(1, 2)
end
# bar1(Duck(foo(Integer, Integer) -> T)) -> T
# Foo1: yes
# Foo2: no
# Foo3: yes
# Foo4: yes

def bar4(f)
  f.foo(1)
  f.foo(1, 2)
  f.foo(1, 2, 3)
end
# bar1(Duck(foo(Integer) -> ?, foo(Integer, Integer) -> ?, foo(Integer, Integer, Integer) -> T)) -> T
# Foo1: no
# Foo2: no
# Foo3: no
# Foo4: yes

# MATCHING TERMINOLIGY AND SET NOTATION

# a and b are methods

a.match?(b)
# true iff the set of possible ways to call a is a subset of the set of possible ways to call b
# and a's name == b's name

# A and B are types

A.match?(B)
# true iff, for every method a in A, there is a method b in B where a.match?(b)

def foo(a:, b:, c:1, d:1)
end

def foo(a:, b:, c:, d:1)
end

def foo(a:, b:, c:1) # foo(a: A, b: B, c: C?) -> ?
end

def foo(a:, b:, c:)
end

def foo(a:, b:)
end

# BLOCK MATCHING

class Foo
  def foo(a) # Foo#foo(E) { |E| -> T } -> T
    yield a
  end
end

class Foo
  def foo(a) # Foo#foo(Duck(+(Integer) -> E, +(T) -> R)) { |E| -> T } -> R
    a + yield(a + 1)
  end
end

class Foo
  def foo(a) # Foo#foo(Duck(+(Float) -> E)) { |E| -> T } -> T
    yield a + 1.5
  end
end

class Foo
  def foo(a) # Foo#foo(Duck(to_s() -> String)) { |String| -> T } -> T
    yield "blah#{a}"
  end
end

class Foo
  def foo(a) # Foo#foo(A) { |BasicObject| -> Any } -> A
    yield BasicObject.new
    a
  end
end

def bar(f) # bar(Duck(foo(Integer) { |Duck(to_i() -> T)| -> T } -> R)) -> R
  f.foo(12) { |x| x.to_i } # F#foo(Integer) { |Duck(to_i() -> T)| -> T } -> R
end

def bar(f) # bar(Duck(foo(Integer) { |Duck(upcase() -> T)| -> T } -> R)) -> R
  f.foo(12) { |x| x.upcase } # F#foo(Integer) { |Duck(upcase() -> T)| -> T } -> R
end

def block(s) # block(Duck(upcase() -> T)) -> T
  s.upcase
end

# RECURSION

def fib(a)
  return 1 if a <= 1
  return fib(a - 1) + fib(a - 2)
end

# initially...
# fib(Duck(<=(Integer) -> Any, -(Integer) -> T)) -> Integer

x = fib(5) # x = Integer

# RESOLVING FREE TYPES

def foo(a) # foo(A) -> A
  a
end

foo(1) #-> A = Integer

# resolve(A, Integer, [A], {})
# => { A => Integer }

def foo(a)
  a + 1
end

foo(1)

# resolve(Duck(+(Numeric) -> A), Integer, [A], {})
# resolve(A, Numeric, [A], {})
# => { A: Numeric }

def foo(a, b) # foo(Duck(+(B) -> R), B) -> R
  a + b
end

foo(1, 2.7)

# resolve(Duck(+(B) -> R), Integer, [B, R], {})
# => {}
# resolve(B, Float, [B, R], {})
# => { B: Float }

# resolve(Duck(+(B) -> R), Integer, [B, R], { B: Float })
# resolve(R, Float, [B, R], { B: Float })
# => { B: Float, R: Float }

def foo(a) # foo(A) { |A| -> B } -> B
  yield a
end

foo("asdf") { |s| s.upcase } # foo(String) { |Duck(upcase() -> R)| -> R }

# resolve(A, String, [A, B], {})
# => { A: String }
# _.merge({ B: block.resolve([A]) })
# resolve(Duck(upcase() -> R), String, [R], {}) #=> { R: String }
# => { A: String, B: String }

def foo(a) # foo(Duck(+(Integer) -> E, +(T) -> R)) { |E| -> T } -> R
  a + yield(a + 1)
end

foo(1) { |i| i + 2.4 } # foo(Integer) { |Duck(+(Float) -> R)| -> R }

# resolve(Duck(+(Integer) -> E, +(T) -> R), Integer, [E, R, T], {})
# => { E: Integer }
# _.merge({ T: block.resolve([E]) })
# resolve(Duck(+(Float) -> R), Integer, [R], {})
# => { R: Float }
# => { E: Integer, T: Float}
# resolve(Duck(+(Integer) -> E, +(T) -> R), Integer, [E, R, T], { E: Integer, T: Float})
# resolve(R, T, [E, R, T], { E: Integer, T: Float })
# => { E: Integer, T: Float, R: Float}

def foo(a) # foo(Duck(strip() -> Duck(upcase() -> R))) -> R
  a.strip.upcase
end

foo "asdf"

# resolve(Duck(strip() -> Duck(upcase() -> R)), String, [R], {})
# resolve(Duck(upcase() -> R), String, [R], {})
# resolve(R, String, [R], {})
# => { R: String }

def foo(a) # foo(Duck(strip() -> A, upcase() -> B)) -> Array<A|B>
  [a.strip, a.upcase]
end

# TYPE RESOLUTION

# resolve(Array<T>, Array<Integer>, [T], {})
# => { T => Integer }

##################################

# Methods have the following attributes
# 1. name, as symbol
# 2. free types
# 3. pargs (optional and variadic)
# 4. kwargs (optional)
# 5. block (optional)
# 6. return type
# 7. in what scope they were defined

# Blocks have the same attributes except for the name and scope

# Method calls have the following
# 1. pargs
# 2. kwargs
# 3. block