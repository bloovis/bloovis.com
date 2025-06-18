---
title: Convert tabs to spaces in one line of Ruby
date: '2008-11-19 00:41:22 +0000'

tags:
- ruby
- software
- microemacs
---
Here's a one-liner Ruby script that converts tabs to spaces:
```
ruby -pe 'gsub(/([^\t]*)(\t)/) { $1 + " " * (8 - $1.length % 8) }'```
I'm in the early stages of rewriting a tiny editor, MicroEMACS, in Ruby, and needed a tab converter.  I was sure I'd seen this somewhere before, but couldn't find it with Google, so rewrote it from scratch.
