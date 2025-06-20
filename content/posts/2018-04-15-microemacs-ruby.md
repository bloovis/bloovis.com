---
title: Extending MicroEMACS with Ruby
date: '2018-04-15 15:04:00 +0000'

tags:
- linux
- software
- microemacs
- ruby
---

Years ago, when I had planned to rewrite MicroEMACS in Ruby, the motivation
was to have support for Rails built into the editor.  Eventually
I did add some very minimal Rails support without rewriting the editor.
But it was never quite satisfactory.  Some things that are easy
to do in Ruby, such as converting singular names to plural or camel-case
names to underscores, are not easy in mimimal C, and I did not attempt
all of them.  The solution was to allow new commands to be written in Ruby.

<!--more-->

There were several things I wanted to achieve in the Ruby support:

1. MicroEMACS should continue to be a small, efficient
editing engine written in C.

2. On a machine without the requisite Ruby shared libraries, the executable file
should still be able to run, but with Ruby support disabled.

3. Ruby code should be able to call any built-in editor command.

4. Writing new editor commands in Ruby should be fairly painless.

5. Ruby code should be able to read and modify edit buffers
in a straightforward manner.

Here is what I did to implement these requirements:

1. The Ruby support was mostly isolated to a single
source module, with a few small changes elsewhere.

2. MicroEMACS is not linked directly with
the Ruby library (libruby).  Instead, it loads the library dynamically
and queries it for the addresses of the Ruby API functions that it
needs.  A set of trampolines (indirect jumps to APIs) in assembly language
is constructed at build time, and a table of API addresses is filled
in at run time.  This allows the Ruby APIs to be called as
if they were linked directly into MicroEMACS.

3. At startup, MicroEMACS loads a helper file written in Ruby that
provides the interface to built-in commands.  Instead of having to
provide wrappers in C for every built-in command, the Ruby helper
file uses `method_missing` to trap a call to an undefined method.  If
the function can be found in the MicroEMACS command table, it is called
via a C helper function.  Otherwise the missing method causes the usual
Ruby exception.  MicroEMACS traps the exception and displays the
backtrace in a popup window.

4. A new command in Ruby is simply a global function that takes a single
numeric parameter.  Two helper functions can be used to tell MicroEMACS
about the new command, and to bind it to a key.

5. MicroEMACS provides some virtual global variables that Ruby code can
use to read and modify edit buffers.  These variables encapsulate the
current line's text, character, line number, offset within the line,
and the filename associated with the buffer.
Some other helper functions are also available for querying information
about the editor.

This functionality allowed me to write better Rails support commands.
They can now do some minimal parsing of the edit buffer to determine
class and method names, so that the user doesn't always have to
be prompted to enter them.  The commands can also determine the location
of the Rails root directory, in case the editor is run from a subdirectory.

See the section [Ruby Extensions](https://www.bloovis.com/fossil/home/marka/fossils/pe/doc/trunk/www/ruby.md)
at my [Fossil repository](https://www.bloovis.com/fossil/home/marka/fossils/pe/doc/trunk/README.md)
for more information and some example code.

In the writing of the new code, I was helped greatly by the excellent
[Definitive Guide to Ruby's C API](http://silverhammermba.github.io/emberb/c/).

I also discovered that a talented programmer from Japan had implemented
an [EMACS-like editor in Ruby](https://github.com/shugo/textbringer)
during the last year.  The code looks much better than anything I would
written, so I'm glad I didn't go down that path.
