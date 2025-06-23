---
title: Implementing the xBrowserSync API
date: '2023-11-04 06:39:00 +0000'

tags:
- linux
- software
- xbrowsersync
- android
- crystal
---

For about a year, I've used the Brave browser, mostly due to its built-in
ad blocking and its bookmark sync feature.  I have been using Brave on
four different devices (three Linux laptops and one Android phone
running GrapheneOS), so the bookmark sync feature is very useful.

But [this article](https://digdeeper.club/articles/browsers.xhtml) on
the privacy features of numerous browsers is rather scathing
about Brave.  So I decided to try [Ungoogled-Chromium](https://github.com/ungoogled-software/ungoogled-chromium),
along with the uBlock Origin and uMatrix extensions.

Then the problem was to find a replacement for bookmark syncing.
Fortunately there is a project called [xBrowserSync](https://www.xbrowsersync.org/)
that solves this problem.  It provides extensions for browsers, as well
as an Android app that works surprisingly well.

xBrowserSync works by storing encrypted bookmark data on a server, and
the project offers their own free server for this purpose.  Being that
I'm on a mission to reduce my dependency on third party servers,
I looked into seeing if I could host my own xBrowserSync server.
xBrowserSync provides the [source code](https://github.com/xbrowsersync/api) for their
server, but I found its huge pile of Node.js code and dependencies
rather intimidating.  I also found a couple of reimplementations
of the server written in Go ([xSyn](https://github.com/ishani/xsyn)
and [xbsapi](https://github.com/mrusme/xbsapi)), but building these
projects also seemed intimidating.

In short, I'm a bit lazy and would rather not have to learn a new programming
language system (Go or Node.js) that I'm already predisposed to dislike.  My impression
of Node.js in particular is one of horror at the sheer number of packages that
have to loaded in order to do build the most basic of projects.

So I decided to write my own implementation of the xBrowserSync API
in [Crystal](https://crystal-lang.org/), a compiled Ruby-like language that is perfectly suited for
implementing small API servers.  I used Crystal a few years ago to
build a [book cover URL server for Koha](/fossil/home/marka/fossils/cover/doc/trunk/README.md),
and was very pleased with how much faster it ran than the
Node.js server it replaced.  It also had the added advantage of
being written in a much more pleasing programming language.

It took me about a day to write the xBrowserSync API server
in Crystal; you can find the result [here](/fossil/home/marka/fossils/xbs/doc/trunk/README.md).
I call it by the very imaginative name of "xbs".
It turns out that the API is very simple; you can find
the complete specification [here](https://api.xbrowsersync.org/).
The number of paths it requires is very small, and you don't need
a fancy web framework to do the routing and serving.  Instead,
you can easily use regular expressions to parse the request paths,
and the [Crystal HTTP class](https://crystal-lang.org/api/1.10.1/HTTP.html) provides
everything you need to implement a fast, efficient server.

Another advantage of using Crystal to build an API server is that
deployment is very simple: you have a single binary executable file
that can be invoked from systemd, and which can be placed behind
a reverse proxy in Apache.  The [README](/fossil/home/marka/fossils/xbs/doc/trunk/README.md)
for the project has details about this.

One thing to note about the xBrowserSync API is that it can store very
large amounts of data.  It doesn't use incremental diffs.  Instead,
whenever you change your bookmarks in a browser, xBrowserSync copies
the entire bookmark tree (in encrypted form) to your API server.  So for
example, the resulting bookmark data for my browser came to about 300K
bytes (I have accumulated a lot of bookmarks over the years).  The
default free xBrowserSync service has a limit on the size of
the data it can store.  You have to upgrade to a paid plan
to get more storage.  This was another reason why I decided
to self-host my own server: I could implement any size limit
I chose.
