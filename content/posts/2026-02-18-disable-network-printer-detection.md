---
title: Disable Firefox Detecting Network Printers
date: '2026-02-18'

tags:
- linux
- firefox
---

When I set up my mom's Linux laptop in her new apartment building, I had it connect
to the building's public wi-fi network, which was free.  But Firefox was detecting
every network-connected printer in the building, and this confused my mom, who
was trying to print to her own USB-connected printer.  I tried two solutions.
<!--more-->

I used to think that all it took to prevent the detection of network printers
was to disable the `cups-browsed daemon with something like this:

```
sudo systemctl disable cups-browsed
```

That prevented CUPS from automatically adding printers to its list, but Firefox was still showing
those dozens of unwanted printers.  It turns out that programs like Firefox
use the `avahi` daemon for this purpose.  Eventually I found that this
service could be prevented from looking for printers (and other services)
on the network by editing `/etc/avahi/avahi-daemon.conf` as root,
and changing the `use-ipv4` and `use-ipv4` settings to `no`:

```
use-ipv4=no
use-ipv6=no
```

This would be a Bad Idea if it were necessary to find other network-connected
devices like file servers, but for my mom's situation, this is not a problem.
