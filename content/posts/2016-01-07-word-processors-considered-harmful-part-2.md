---
title: Word processors considered harmful (part 2)
date: '2016-01-07 10:50:00 +0000'

tags:
- linux
- rants
- software
- windows
---
Several months ago, I wrote about the considerable
[drawbacks of using word processors](../../../2015/05/01/word-processors-considered-harmful-part-1.html).
A few years ago I started searching for a replacement for Sprint that would
run on Linux: a non-WYSIWYG text formatting system that would allow me to use
my favorite editor and focus on writing instead of typesetting and formatting.
<!--more-->

For a while, I experimented with [DocBook](http://www.docbook.org/), which uses XML-based semantic markup;
that is, the markup described the meaning of words, not their typographic appearance.
It worked well, and there were tools for generating both PDF and HTML output.
But writing the DocBook dialect of XML was rather tedious, even moreso than HTML.
Each paragraph, for example, has to
be surrounded by &lt;para&gt; and &lt;/para&gt; tags, and that quickly gets tiresome.

There is a GUI front end for DocBook called [LyX](https://www.lyx.org/) that eliminates some of this tedium.
LyX doesn't attempt to be WYSIWYG, but has some of the other drawbacks of GUIs,
the major one being the inability to use any editor.

More recently, I discovered [Pandoc](http://pandoc.org/), and have settled on this versatile piece of software
as my preferred text processor.  Its preferred input is an
[extended version of Markdown](http://pandoc.org/README.html#pandocs-markdown).
Instead of using tags in the style of XML or HTML, Markdown uses many of the conventions that were
developed in the early days of plain text systems like Usenet and pre-HTML email.  For example,
you emphasize a word by surrounding it with asterisks or underlines; quote a block of
text by preceding each line with a "> "; and indicate a header line by preceding it
with one or more "#" characters.  These conventions are easy to type, and they are also
much more readable than XML or HTML.

Pandoc uses LaTex to generate PDF files, and it allows you to insert LaTex commands
in the input Markdown files for special situations that Markdown can't express.
As an example, I use this feature to write letters.  I first installed a
[letter template for Pandoc](https://github.com/aaronwolen/pandoc-letter)
by copying it to the directory `~/.pandoc/templates/`. Then a letter that uses this template looks like this:

    ---
    author: Mark
    opening: Dear Sir,
    closing: Sincerely,
    address: 
     - John Q. Public
     - 123 Main Street
     - Podunk, IL 34567
    return-address: 
     - Mark Alexander
     - 666 Farm Road
     - Gitville, VT 01234
    ...

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin mollis
    dolor vitae tristique eleifend. Quisque non ipsum sit amet velit
    malesuada consectetur. Praesent vel facilisis leo.

To output a PDF for this letter, I use this command:

```
pandoc --template=template-letter.tex -V blockquote -o test-letter.pdf test-letter.md
```

I've used Pandoc to create other kinds of documents as well, ranging
from text-only informational flyers to book chapters that include
figures.

Semantic markup works best with documents that are heavy on text and
have straightforward or repetitive formatting.  The situations where
semantic markup will be weakest are those where an old-style desktop
publishing program would be more suitable: documents with complicated
layouts, large numbers of images or text styles, and precise
placements of those elements.  Word processors are the wrong tools for
this kind of work, too, but are frequently used that way.
