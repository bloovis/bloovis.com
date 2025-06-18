---
title: Three Bad Designs
date: '2009-03-02 13:41:21 +0000'

tags:
- hardware
- rants
---
Most modern computers, and especially laptops, are afflicted with three especially poor design choices.  We seem to be stuck with these choices, because the market, in its infinite wisdom, has decided that they are somehow an improvement over the old ways, or at least different.  I'll start with the oldest problem first.

**Caps Lock in the wrong location**

Up until around the mid-80s all terminals and computer keyboards had a Control key placed where God intended it, next to the A key on the home row.  This was extremely convenient when using programs like editors (especially Emacs and it imitators).  Even Windows has plenty of keyboard shortcuts that use the Control key.  So having that key within easy reach was a big plus.

Life was good until IBM introduced its third-generation PC, called the PS/2.  For reasons known only to Big Blue, the perfection of the predecessor AT keyboard was destroyed by having the Control key moved down to the bottom left corner of the keyboard, which required a long pinky stretch to reach.  In its place IBM put a Caps Lock key, which was entirely useless, except possibly for writing angry rants on Usenet.  The clone market responded by imitating IBM's keyboard, and now all keyboards and laptops sold today, even those made by Apple, have this tendinitis-inducing Control key placement.

Fortunately, this is the one design blunder of the three I'm describing here that can be easily fixed.  In both Linux and Mac OS, the Caps Lock key can be made to function as Control Key through the operating system's respective GUI control panels.  In Windows it's a little more work that involves editing the Registry manually; a Google search can uncover the method.

**Touchpads**

I started using laptop computers about ten years ago, and my first was a Toshiba that had a TrackPoint: a pointing device that looks like a nipple placed in between the G, H, and B keys.  It took me a week or so to get used to the thing, but once I got past the learning curve, I fell in love with it.  It was a huge improvement over earlier laptop pointing devices, which were mostly trackballs.  The TrackPoint was brilliant because it required no motion, just pressure; and because it allowed the fingers to stay on the home row.  Because of these advantages, it was also a great improvement over conventional mice, which require constant movement of one hand from the home row to the mouse and back again.

But for some reason, trackpads became popular on laptops in the last few years, and now it's impossible to find a laptop that doesn't have one.  These have the primary disadvantage of a conventional mice (the need to take one or both hands off of the home row), coupled with the need to repeatedly flick the finger across the thing to get the mouse cursor to do a complete travel from one side of the screen and the other.  To make matters worse, trackpads are placed right where the thumbs naturally want to rest, resulting in unintended mouse movements and clicks due to the thumbs inadvertently touching or grazing the pad.

Fortunately Lenovo (formerly IBM) still makes ThinkPads with the TrackPoint, but these also come with touchpads, whose only advantage now is the side-scrolling feature.

**Wide Screens**

In the last couple of years, wide screen monitors have taken over the market.  There appears to be no good reason for this other than the existence of wide-format movies.  In every other respect, these screens are a disaster, because they have taken pixels away from the vertical dimension and given them to the horizontal.  Screens that used to have 1200 pixels vertically are now typically have only 900.  This is a disaster because most information is presented on screen vertically.

This is terrible for programmers, who like to see as much text as possible when editing. But it's also bad for ordinary users running web browsers.  Take a loop at a typical screen.  On Linux or Windows, from top down we might see the following visual elements: the browser's title bar, menu bar, tool/address bar, bookmarks bar, tabs bar, content window, search bar, status bar, and OS task/system bar.  Each of these takes up vertical space, ultimately limiting the most important (and only scrollable) element, the content window.  Wide screens make this worse by taking away as many as 300 pixels from the content window.

There isn't much that can be done about this problem if you use a laptop.  The various visual elements mentioned above cannot be moved to the side of the screen, for the most part.  The OS task bar can be moved, true, but it's not nearly as useful on the side of the screen, because the labels are no longer readable.  The only solution is to grab up conventional displays while they are still available.  I found a used ThinkPad R50p on eBay in December.  It's slower and noisier than a new laptop, but it was one of the last ThinkPads made that had the beautiful 1600x1200 FlexView display.  Now, alas, all new ThinkPads have wide screens, a truly sad situation that appears to be permanent.

Desktop computer users can sometimes fix this problem by rotating their monitors 90 degrees and setting their graphics drivers to use portrait mode.  I'd estimate that at least half the programmers at work have done this.  Unfortunately, the last time I checked, Linux graphics drivers didn't support hardware-assisted acceleration in portrait mode.  But I still have a 1600x1200 display, so I don't have to worry about this problem until the display breaks.
