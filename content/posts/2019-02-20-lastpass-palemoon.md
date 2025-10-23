---
title: Using LastPass in Pale Moon browser
date: '2019-02-20 16:48:00 +0000'

tags:
- linux
- software
- palemoon
- lastpass
---

Firefox 57 introduced a new extension API that broke most of the extensions
I had been using, including It's All Text, Dorando Keyconfig, and Tab Mix Plus.
So I installed [Pale Moon](https://www.palemoon.org/), a fork of an older
Firefox that works with those extensions.  But the current LastPass extension
only works with the new (57+) Firefox.

<!--more-->

A few months ago, I was able to find a copy of LastPass 3.3.4
on the Firefox web site; this is the last version that works with Pale Moon.
Then today I tried to install Pale Moon on a second
machine and discovered that LastPass 3.3.4 had been removed from the Firefox
site, and I couldn't find it anywhere else.

The solution was to recreate the xpi file for the extension using the existing
installation.  Here's how to do that:

Pale Moon extensions are stored in `~/.moonchild productions/pale moon/xxxxxxxx.default/extensions/`,
where `xxxxxxxx` will be a seemingly random sequence of letters and digits.
In that directory, the LastPass extension is stored in the subdirectory
`support@lastpass.com`.  Move into that directory and then execute this command:

```
zip -r /tmp/lastpass.xpi .
```

Copy the resulting xpi file to `/tmp` on the second machine.  In Pale Moon
on that machine, enter this URL in the address bar:

```
file:///tmp/lastpass.xpi
```

The extension should install and be available upon restart of Pale Moon.
