---
title: Word processors considered harmful (part 1)
date: '2015-05-01 14:03:44 +0000'

tags:
- linux
- rants
- software
- windows
---
It almost goes without saying that when you buy a PC, part of the
price is the Microsoft Tax, to pay for a copy of Windows whether you
want it or not. <!--more--> Windows, unlike free operating systems, is bereft of
useful software like word processors and spreadsheets. You would think
that having to pay for an operating system would give you more
features, but the opposite is true. So if you decide to stick with the
Windows OS that came with your computer (as mostly people think they
must), then it also goes without saying that you will want to pay
another Microsoft Tax, to obtain a copy of Office. And in my
experience, the most common reason people give for buying Office is so
that they can have a copy of Word, which is a hugely bloated word
processor.

Putting aside the hazards of entrusting one's documents to proprietary
software and data formats, let's focus on the perceived need for a
word processor. Even Windows includes a basic text editor. But from
what I've observed, most people who buy Word end up using it as mostly
as a text editor, and hardly touch any of its more powerful features.
Those extra features are, admittedly, useful when you want to make
something look pretty on paper. Word, like all WYSIWYG (what you see
is what you get) word processors, gives you full control of the
appearance of every character in document, from font family to point
size and beyond. And that's just scratching the surface of what can be
done.

But is this kind of fine control of a document's appearance really
necessary? Or rather, is a word processor really the right tool for
this job?

Let's say we're starting to write a book in Word. We know we'll want
to have chapter titles that will stand out in some way. So we type the
title of our first chapter, then realize we need to make the text
bigger, and perhaps bolder. So we use the toolbar (called a
&quot;ribbon&quot; these days) and select a font size. But that
doesn't seem to do anything. Then we remember that when we want to
change the formatting of existing text, we have to select it first. So
we sweep over the chapter title with the mouse, then select a larger
font size. 

So far so good. The chapter title is definitely bigger. Now let's type
the first few sentences of our chapter. Oops! The text is super-large!
How did that happen? Oh, right -- our first attempt to change the
chapter title size only managed to set the default size for subsequent
text. So we need to set the default font size back to something small
again. But the enlarged text we just typed has to be fixed, too. So we
select it, and then shrink it.

Now we're cooking. But after typing a few more paragraphs, we realize
that the chapter title might need some more tweaking. We've noticed
that chapter titles in books by our favorite novelists sometimes use a
different typeface than the main text, and are typically boldfaced.
Perhaps the chapter title should use a sans-serif font. So we to
select the chapter title, then select a sans-serif font, then select
the &quot;bold&quot; icon. That looks better, and we resume working on
our opening chapter.

This kind of fiddling with appearance is an appalling waste of time.
Instead of encouraging us to focus on writing, Word's power as
formatter is encouraging us to become typesetters, and not very good
ones at that. Because we're Word novices and haven't yet discovered
templates (and most Word users probably never do), we have to do the
same kind of tedious fiddly work whenever we want to change the
appearance of some piece of text. We have to make sure that chapter
headings all uses the same formatting. If we're writing a trashy novel
in the style of James Patterson, with 107 chapters, three prologues,
and three epilogues, that's a lot of fiddling. We'll end up doing the
kind of work that computers should be doing for us.

So is there a better way? There is, and it's not a new thing at all.
The idea is to focus on the meaning of the text -- its logical
structure -- and not its appearance. We would like to be able to say,
&quot;this piece of text is a chapter title&quot;, and then just let
the computer render it appropriately for print (or the web, or
whatever our target medium might be). We can tell the computer how we
want all chapter titles to appear, and it can make that appearance
happen without any further intervention on our part.

Conventional word processors, being focused on appearance, make this
more difficult. They offer templates, but the WYSIWYG view obscures
the logical structure and presents only typographical information.

Text processors that let the users focus on logical structure have
been around a long time. The first one to be used widely was Brian
Reid's Scribe, which was available on VMS in the 1980s. Unlike
previous text formatters, which were mostly spinoffs of DEC's
&quot;runoff&quot;, it had a flexible syntax that allowed markup to be
placed anywhere in the text, not just on separate lines. The markup
was actually a kind of programming language, in which new logical
environments could be defined, either based on existing environments
(a kind of single inheritance), or defined entirely from scratch.

An example should make this more clear. In Scribe, it was easy to
write nested enumerated lists or description without worrying about
the numbers incrementing or the indentation of the list items. Let's
say we're writing a book about how to assemble a simple computer from
a kit. We could write something like this:

```
@chapter(How to assemble your motherboard)
The kit you received includes several parts packets:
@begin(enumerate)
Packet 1 consists of the following pieces:
@begin(description, spread 0 lines)
CPU@\A CPU chip
RAM@\Two RAM chips
SIO@\A serial port
@end(description)
Packet 2 consists of a circuit board. It is @b(self-contained).
@end(enumerate)
```

Scribe would render this as:

====

**Chapter 1 How to assemble your motherboard**

The kit you received includes several parts packets:

1. Packet 1 consists of the following pieces:

<dl>
<dt>CPU</dt>
<dd>A CPU chip
</dd>
<dt>RAM</dt>
<dd>Two RAM chips
</dd>
<dt>SIO</dt>
<dd>A serial port
</dd>
</dl></li>

2. Packet 2 consists of a circuit board. It is **self-contained**.

====

In this example, we used several environments: &quot;chapter&quot; for
a chapter title, &quot;enumerate&quot; for a numbered list,
&quot;description&quot; for a description list, and &quot;b&quot; for
a boldfaced word. The &quot;chapter&quot; environment boldfaced the
title and inserted the correct chapter number for us; it also
generated an entry in a table of contents (not shown here). The
&quot;enumerate&quot; environment generated the correct item numbers
for us, and indented the list items properly. We didn't have to worry
about any of that formatting fussiness.

Now, strictly speaking, the &quot;b&quot; environment does not
describe a logical structure; it defines a typographical suggestion
(boldface). But in Scribe we could easily define a logical environment
for the words that we wanted to emphasize:

`@define(emph = b)`

Then to emphasize some text, we would do this:

`@emph(these words are emphasized)`

This involves slightly more typing. But if we decide later that we want emphasized words to be italicized rather than boldfaced, we can redefine the emph environment without having to change the many instances of the emphasized words:

`@define(emph = i)`

The Scribe model was later copied by Mark of the Unicorn in their
PC-based text formatter, Final Word II. FWII was then bought by
Borland and used in their Sprint word processor. Although Sprint had a
pseudo-WYSIWYG text editor, the formatter could be used standalone,
allowing you to continue using your favorite editor. 

But unfortunately, Scribe and Sprint were commercial, proprietary,
closed-source products that eventually died, leaving their users
stranded. These days, the preferred text formatter that follows
Scribe's semantic markup model is LaTeX, which uses Donald Knuth's TeX
as its typesetting language. LaTeX and TeX are free and open-source
programs that are widely used and not likely to disappear. More on
this next time.

