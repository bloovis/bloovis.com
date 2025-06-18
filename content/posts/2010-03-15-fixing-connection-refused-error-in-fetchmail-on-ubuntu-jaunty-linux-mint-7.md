---
title: Fixing "connection refused" error in fetchmail on Ubuntu Jaunty / Linux Mint
  7
date: '2010-03-15 01:30:24 +0000'

tags:
- linux
- linux mint
- software
- ubuntu
---
Today I installed fetchmail on Linux Mint 7, which also brought in postfix as the mail transfer agent.  I'd used this combination on Linux Mint 6 with no problems, but on Mint 7 (which is based on Ubuntu Jaunty), fetchmail printed this error message:

```
fetchmail: connection to localhost:smtp [::1/25] failed: Connection refused.
```

The error was caused by fetchmail attempting to make an IPV6 connection to postfix on the local machine.  Postfix refused the connection, so fetchmail then attempted an IPV4 connection, which was successful.  The mail was delivered, but the error message was annoying.

As usual, I tried several solutions I found with Google, including an attempt to disable IPV6 on a system-wide basis.  The thing that finally worked was to comment out the following line in `/etc/hosts`:

```
#::1     localhost ip6-localhost ip6-loopback
```
