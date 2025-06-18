---
title: Adding Redo to MicroEMACS
date: '2019-02-09 06:31:00 +0000'

tags:
- linux
- software
- microemacs
---

Last year I added [undo support](/posts/2018-03-01-microemacs-utf8/) to my ancient fork
of Dave Conroy's [MicroEMACS](https://gitlab.com/bloovis/micro-emacs).
The undo function has been useful on those occasions where
I do something stupid, like justifying a paragraph in, say,
a piece of C code.  But sometimes it's possible to go a bit
too far with repeated undos and lose some valuable work.
The solution was to implement a redo command that undoes an undo.

<!--more-->

The implementation of redo is fairly straighforward when the mechanism
for undo is already in place.  There are three things to consider:

First, it is helpful to think of undo and redo as controls for going
forward and backward in time, with undo records being treated as journal entries
that record modifications made to the text.  There is now a redo stack to supplement
the existing undo stack.  When the user performs an undo, MicroEMACS pops the
corresponding journal entry off the undo stack and pushes it onto the redo stack.
Similary, when the user performs a redo, MicroEMACS moves the corresponding
journal entry from the redo stack to the undo stack.

Secondly, the redo function requires that the editor store more information.
Specifically, a journal entry for the insertion of a string used to store
only the length of the string, because that is all the information that is
needed to undo an insertion.  But redo requires that the journal
entry must also store a copy of that string.

Finally, the redo function introduces a problem that is sometimes referred
to as the time travel paradox in science fiction.  What happens when you
travel back in time and make a change that affects the future?  In an editor,
this problem can show up as a merge conflict.  For example, if you move back in time
via an undo, make a change to a line, then try to move forward in time
with a redo that changes that same line, your changes could be lost.  The fix
is to not allow redo after the user makes any manual change to a buffer (that is,
any change that was not the result of an undo or a redo).
