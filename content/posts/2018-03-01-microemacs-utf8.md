---
title: Adding Undo and UTF-8 support to MicroEMACS
date: '2018-03-01 18:53:00 +0000'

tags:
- linux
- software
- microemacs
---

I've been hacking on the original Conroy version of
[MicroEMACS](https://gitlab.com/bloovis/micro-emacs) for over thirty
years, and every so often I add new features that I need.
In the last dozen or so years I added support for ctags, cscope, and
Ruby on Rails (the latter very minimally).  But for many
years I've been wanting an undo function, and the ability to
view and edit UTF-8 text files.

<!--more-->

[Years earlier](/2008/11/19/convert-tabs-to-spaces-in-one-line-of-ruby.html),
I thought I'd rewrite the editor in Ruby, since Ruby had built-in support
for UTF-8.  I started the project, but the task seemed more daunting than
writing a little more C to implement the new features.  Finally, over the last month, I
added the undo and UTF-8 support to the original MicroEMACS.

The undo feature is very basic.  It doesn't support redo, which greatly simplifies
the code and data structures.  Each command that modifies a buffer must
record actions that will recreate the state of the buffer as it existed
before the modifications.  In principle, this is fairly simple: if some text
is deleted, record an action that will insert the characters that were deleted.
If some text is inserted, record an action that will delete that many characters.

The tricky part has to do with actions that move the current insertion
point, called the "dot".  Unlike sequences of inserts and deletes, moves
cannot be executed in the same order that they were recorded: they must
be executed in reverse order.  The solution to this conflict in requirements
is to break up the sequence of undo steps associated with a command
into sub-sequences; each sub-sequence starts with a move.  These sub-sequences
are executed in reverse order, but within each sub-sequence the undo steps
are executed in normal order (i.e., the order in which they were recorded).

Adding support for UTF-8 took about the same amount of time as undo:
about two weeks part-time, much of it while I was laid up with
injuries and illnesses.  Formerly, MicroEMACS assumed that text was
stored as one byte per character.  MicroEMACS still stores lines of
text internally as sequences of bytes, but these sequences are now
UTF-8 encoded, so some characters are longer than one byte.  To make
this work required writing some new macros and functions that allowed
the editor to treat a UTF-8 encoded line of text as a virtual array of
Unicode characters.  These macros and functions typically take an offset into this virtual array,
and then step through the line's bytes to find the
appropriate character.

Though this new code for undo and UTF-8 is obviously slower than the
old code, which didn't record undo steps, and which indexed lines
of text directly using byte offsets, it is still fast enough on modern
computers that no slowdown is noticeable.  This wouldn't have been the
case thirty years ago, on machines like the IBM PC/XT.  That 8088-based machine
was slow enough that I actually rewrote some of MicroEMACS's search
code in assembly language to speed it up (that code is long lost).
