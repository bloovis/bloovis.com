---
title: Enlarging the Firefox Scrollbar
date: 2025-06-28
comments: true
tags:
- software
- linux
- firefox
---

On Linux Mint, the scrollbar in Firefox is very narrow, and doesn't appear unless you hover
the mouse cursor over it.  This is a problem for my mom, who refuses to
use the scroll wheel on her mouse, and insists on scrolling the hard way.  But
the scrollbar is so small, she has to struggle slowly and tediously to
use it.  Here is a fix for the ridiculously hard-to-see scrollbar.
<!--more-->

Open `about:config` and say yes to the warning that appears.  Set
the following values:

| Name | Value  |
|--------|------|
| **widget.non-native-theme.scrollbar.size.override** | 10   |
| **widget.non-native-theme.scrollbar.style** | 4  |

This will make the scrollbar wide enough to see clearly
and hit easily with the mouse cursor.

Next, open Settings and check General / Browsing / Always show scrollbars.
This will eliminate the need to hover over the scrollbar to make
it appear.





