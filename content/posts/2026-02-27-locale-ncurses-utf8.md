---
title: Locale, Ncurses, and UTF-8
date: '2026-02-27'

tags:
- linux
- c
- crystal
---

Here's something I keep forgetting about and have to relearn every time: ncurses(w)
won't display UTF-8 characters correctly unless you call `setlocale` first.  Here's
how to do it C and Crystal.
<!--more-->

## C

```c
#include <locale.h>
...
setlocale (LC_CTYPE, "");
```

## Crystal

```crystal
lib Locale
  LC_CTYPE = 0
  fun setlocale(category : Int32, locale : LibC::Char*) : LibC::Char*
end

Locale.setlocale(Locale::LC_CTYPE, "")
```
