---
title: Determine your external IP address
date: '2020-03-29 14:45:00 +0000'

tags:
- linux
---

It's sometimes useful to know your computer's external IP address: that is, the IP address of your NAT
router as seen from the outside world.  It would be most convenient to be able
to do this from a shell, without having to resort to a web site like
[this one](https://whatismyipaddress.com/).
A quick DuckDuckGo search found
[this older discussion](https://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-a-shell-script),
but nearly all of the methods described there no longer work.  The only
ones that worked for me were this:

```
curl -s http://whatismyip.akamai.com/ && echo
```

or this:

```
dig +short -t txt o-o.myaddr.l.google.com @ns1.google.com | sed -e s/\"//g
```

Either or these commands could be placed in a one-line shell script or an alias.
