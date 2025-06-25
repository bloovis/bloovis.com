---
title: Csup email client
date: 2025-06-24
tags:
- software
- notmuch
- crystal
- linux
- csup
---

Terminal-based email clients may seem like an anachronism from the 1970s, but
they have their place even now.  They don't require a browser, they can
run on servers via ssh, and they are very fast to operate, being keyboard-driven
and character-based.
<!--more-->

I have been using these kinds of email clients since around 1986, when
I was working at [Digital Research](https://en.wikipedia.org/wiki/Digital_Research)
and we got a [DEC VAX](https://en.wikipedia.org/wiki/VAX) running
[4.2BSD Unix](https://en.wikipedia.org/wiki/History_of_the_Berkeley_Software_Distribution#4.2BSD).
 I continued using terminal-based clients when I started using Linux,
especially [mutt](https://en.wikipedia.org/wiki/Mutt_(email_client)).

In 2008, as I was becoming familiar with the
[Ruby programming language](https://www.ruby-lang.org/en/),
I discovered [sup](https://github.com/sup-heliotrope/sup), an email client written in Ruby.
Sup had a number of improvements
over mutt, some of which were inspired by gmail.  It had a very fast search feature, it used tags instead
of folders, and it displayed threads in a tree-like fashion.

I used sup until around 2017, when I discovered a
[fork of sup](https://github.com/quark-zju/sup) that replaced
sup's own search index system with [notmuch](https://notmuchmail.org/).
This appealed to me, because I had found sup to be
not entirely robust about the integrity of its search index
when it would crash.  Occasionally I would have to rebuild
the index from scratch when it got corrupted.  By offloading
the searching to notmuch -- which ran as a separate program,
was in active development, and had achieved good stability --
sup could gain some of that stability.

(There is also a certain amount of irony in the existence of
sup-notmuch, since notmuch itself was inspired by sup.)

I forked the notmuch-enabled sup, and called it
[sup-notmuch](/fossil/home/marka/fossils/sup-notmuch/home)
([github mirror](https://github.com/bloovis/sup-notmuch.mirror)).  After a
fair amount of hacking and bug-fixing, I was able to get it to be stable,
and I used it for the next seven years.

Around 2023 I started moving many of my software dependencies, like
email and web hosting, to a [Linux VPS](/posts/2023-11-10-fun-with-servers/).  Because my email was now
being stored on this server, I was able to run sup-notmuch there
as my email client.  This allowed me to use ssh
from any machine to access my email.

However, I noticed that sup-notmuch used a very large amount
of memory, about 145 MB, which was a bit of a load on my
server, which doesn't have a large amount of memory.  So around
the end of 2019, I started rewriting sup-notmuch in [Crystal](https://crystal-lang.org/),
which is a compiled language similar to Ruby.  I had to
put the project on hold until late 2023, when I resumed
work in earnest.  By the middle of 2024, I had a working
email client that was functionally nearly identical to
sup-notmuch, but was now a single compiled binary that
was much faster and smaller.

I call this program *csup*, short for "Crystal sup".
It's terrible name, and unpronounceable, but I am sticking
with it because it's easy to type.  I've been using it
full-time for just over a year, and it works well enough
for me that I no longer feel the need to add any more features.

The main thing that csup is missing is support for gpg-encrypted
emails, but I never needed that feature and don't expect to need it
in the future.  It's also missing most of the hooks from
sup-notmuch, but has enough for my use.

In csup, I was able to eliminate nearly all of the parsing of emails
in sup-notmuch, by using notmuch itself for this purpose.  I also
added an SMTP client to csup, so that an external email sender (like
[msmtp](https://marlam.de/msmtp/)) is not needed.

The source code, including full documentation, is in a Fossil
repository [here](/fossil/home/marka/fossils/csup/home).
I also have a github mirror [here](https://github.com/bloovis/csup.mirror).

I don't expect anybody else to use this client, but I do
believe it's usable, and that sup users (if there are
any left) might be happy with it.
