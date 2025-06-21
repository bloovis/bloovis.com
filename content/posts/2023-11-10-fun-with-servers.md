---
title: Running a Linux Server for Fun and Non-Profit
date: '2023-11-10 06:33:00 +0000'

tags:
- linux
- software
- ubuntu
- git
- xbrowsersync
- vaultwarden
- fossil
---

For the last couple of months, I've gradually been weaning myself from some
Big Tech services, and reimplementing these services on my own Linux VPS
(virtual private server) on Linode, running Ubuntu Server 22.04.
<!--more-->
I now have a server that I use for:

1. Running my [email client](https://www.bloovis.com/fossil/home/marka/fossils/sup-notmuch/doc/trunk/README.md).

2. This blog, formerly hosted on [NearlyFreeSpeech](https://www.nearlyfreespeech.net/),
a very fine BSD-based hosting service.

3. The [FreshRSS](https://freshrss.org/index.html) RSS reader.

4. The [Vaultwarden](/posts/2023-10-06-vaultwarden-without-docker/) implementation
of the BitWarden password service.

5. Using Postfix to [receive email](/posts/2023-10-03-postfix-maildrop-failure/) from
the [Pobox](/posts/2023-10-07-pobox-and-postfix/) redirection service.

6. My own implementation of the [xBrowserSync API service](/posts/2023-11-04-implementing-xbrowsersync-api/).

7. My [Git repositories](/posts/2023-11-09-publishing-with-cgit/), formerly hosted on Gitlab.

8. My [Fossil repositories](/fossil/), which replaced my Git repositories recently.

This sort of thing is not for the faint of heart, but I learned a lot
in the process and gained more control over the things I use on the internet.

I'm still dependent on [Pobox](https://www.pobox.com/) for email forwarding,
email sending, and spam protection.  But the price for the basic service
is very reasonable, and frees me from the almost certain disaster of trying
to use my own Postfix installation as a general-purpose email sending system.
