---
title: Improving fonts in Ubuntu/Linux Mint
date: '2009-12-30 04:27:14 +0000'

tags:
- linux
- linux mint
- software
- ubuntu
---

By default, Linux Mint 6 and 7 (and presumably, Ubuntu 8.10 and 9.04) come with a minimal set of somewhat ugly fonts.  There are two things that can be done to improve the situation.

First, install the Microsoft TrueType fonts:

`sudo aptitude install msttcorefonts`

Then, if you are using an LCD monitor (e.g., a laptop), enable anti-aliasing (smoothing).  On Linux Mint, start the Control Center from the main menu, then select Appearance.  (On Ubuntu, I believe this is done using System > Preferences > Appearance.)  Click the Font tab, and under Rendering, select Subpixel Smoothing.

You'll see an immediate change in all fonts used in Gnome, but you may need to restart Firefox get it to see the new fonts and use smoothing.
