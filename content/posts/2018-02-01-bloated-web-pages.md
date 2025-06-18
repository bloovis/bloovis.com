---
title: Bloated Web Pages
date: '2018-02-01 14:23:00 +0000'

tags:
- crapification of everything
- software
- web
---
[Parkinson's Law](https://en.wikipedia.org/wiki/Parkinson%27s_law) states
that "work expands so as to fill the time available for its completion".
Corollaries to this law apply to most areas of software development.
For example, the memory required for a program typically expands to fill
the space available.  This is especially true in embedded systems where
code is placed in ROM.  We could probably formulate a newer version of this law for
the World Wide Web, relating average internet speeds to web page size.

<!--more-->

Back in the good old days of modems, with transfer rates approaching
5.6 kilobytes per second on a good day, web pages were tiny, mostly text,
and loaded in ten seconds, or less if you were lucky.
Now, with high speed broadband being widely available (except in places like
rural Vermont), a typical web page can be 2 megabytes or more, and loads in about
ten seconds.  In other words, internet to the home is more than 100 times faster
now than it was in the old days, but the web is still just as slow.

For a detailed account of why this happened, take a look at
[The Website Obesity Crisis](http://idlewords.com/talks/website_obesity.htm).
Read the whole thing right now.

Now take a look at [Web Bloat Score Calculator](https://www.webbloatscore.com/),
and use it to calculate the bloat on a web page that annoys the heck
out of you with its useless pictures and "responsive" (i.e., weirdly
unpredictable) design.  A friend who was trying to
find the hours of a local grocery store ran into this [typical
example](http://soromarket.com/about/).  To find the store's hours,
you have to scroll past a bunch of useless pictures, which move around in a
non-linear fashion.  Further, on a slow internet connection (such as
a cellular data plan) it is frustratingly slow
(and possibly expensive) to get to the information you really need.

Not surprisingly, the web page mentioned above has a Bloat Score of 8.91.  In other words,
the web page is almost nine times larger than an equivalent image file representing
the entire page.  (Update: I obtained the 8.91 value just over a month ago; today
it is 19.3!)

Call me a pessimist, but there doesn't seem to be a practical solution
for this problem.  Web designers will continue to use the latest
enormous Javascript libraries and ads and trackers and images and
social media buttons, because that's what everybody else is doing.
Remember when everybody and their uncle had a Flash intro video on
their main page?  That is so 2008!  Now it's useless, gigantic, and
sometimes animated background images, and no "skip intro" button (take a look at Squareup and
Netflix for just two examples).  Nobody will go back to minimalist web
sites.  That would be like using a two-year old iPhone instead of the
latest model&mdash;a horrifying prospect when your goal is innovation
at all costs.
