---
title: Standard methods missing in Ruby C API
date: '2025-09-07'
tags:
- linux
- software
- microemacs
- ruby
---

For a few years now, I've been using my [Ruby-enhanced MicroEMACS](/posts/2018-04-15-microemacs-ruby/)
to write editor extensions. I implemented this feature using
the [Ruby C API](https://silverhammermba.github.io/emberb/c/),
which allows Ruby code to manipulate the edit buffer.
But when I tried to build the editor on Linux Mint 22 (Ubuntu 24.04),
I discovered that the `Time.now` class method is no longer available in editor extensions.
A similar issue occurred on Fedora 42: the `Symbol#to_s` instance method
doesn't produce the expected result.

<!--more-->

## Time.now

The `Time.now` problem affected an extension I'd written that used `Time.new` in
several places, and now I was getting an error that `Time` didn't
have a `now` method.  This seemed weird, because outside of the editor,
`Time.now` still worked.  After a long slog through Ruby documentation,
source code, and header files, I came across [this commit](https://github.com/ruby/ruby/commit/9101597d05ef645949bab3a210d8fa5e61de26e3)
in the Ruby source code with this comment: "Moved Time.now to builtin".

Somehow the Ruby interpreter, when run outside of the editor, is
able to patch up the `Time` class to use the built-in definition,
but I wasn't able to figure out how to do that using only the Ruby C API.
However, I did find a way to do that in a mix of C and Ruby.

First, in the editor's C code, define a Ruby-callable function that uses
`rb_time_timespec_new` to fetch the current local time:

```c
static VALUE
my_now (VALUE self)
{
  struct timespec ts;
  VALUE now;

  rb_timespec_now (&ts);
  now = rb_time_timespec_new (&ts, INT_MAX);
  return now;
}
```

Then tell Ruby about this function and give it the name `timenow`:

```c
  rb_define_global_function("timenow", my_now, 0);
```

Finally, in the Ruby helper script that the editor loads at startup,
add some code that dynamically creates the `Time.now` class method if it's
not available:

```ruby
class Time
  unless Time.respond_to?(:now)
    class << self
      define_method(:now) { timenow }
    end
  end
end
```

This works on Linux Mint 21 (which *does* provide `Time.now` via the API) and
Linux Mint 22 (which *does not* provide `Time.now` via the API).

## Symbol#to_s

I installed Fedora 42 on a spare laptop, and discovered that similar
problem occurred: calling `to_s` on a symbol didn't produce the
expected string, but seemed to do nothing, i.e. returned the symbol unchanged.
This caused the editor's helper function `pe.rb` to fail when attempting to
call a MicroEMACS command.  Also, the method `Symbol#name`,
which works outside the editor, was undefined, so I couldn't use that.

The solution was very similar to the `Time.now` solution: implement
a helper function in C to fetch the string representation of a symbol,
and define a `Symbol#to_s` method to use that helper function.

First, in the editor's C code, define a Ruby-callable function that uses
`rb_sym_to_s` to get the string name of a symbol:

```c
static VALUE
my_sym2str (VALUE self, VALUE sym)
{
  VALUE ret;

  ret = rb_sym_to_s (sym);
  return ret;
}
```

Then tell Ruby about this function and give it the name `sym2str`:

```c
  rb_define_global_function("sym2str", my_sym2str, 1);
```

Finally, in the Ruby helper script that the editor loads at startup,
add some code that dynamically creates the `Symbol#to_s` instance method if
`Symbol#name` is not available:

```ruby
class Symbol
  unless :name.respond_to?(:name)
    define_method(:to_s) { sym2str(self) }
  end
end
```
