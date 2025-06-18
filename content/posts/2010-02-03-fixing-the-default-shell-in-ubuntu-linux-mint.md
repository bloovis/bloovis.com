---
title: Fixing the default shell in Ubuntu / Linux Mint
date: '2010-02-03 21:38:31 +0000'

tags:
- linux
- linux mint
- ubuntu
---
Several years ago, the Ubuntu developers made a horrible decision to [make dash the default shell instead of bash](https://wiki.ubuntu.com/DashAsBinSh).  This breaks numerous shell scripts, and I recently discovered it also broke one of my own Ruby scripts that depended on bash's signal handling.  The problem here was that when a TERM signal is sent to dash, it doesn't kill off its child processes.

The problem isn't fixed by making bash the login shell for a particular user, because some programs (such as Ruby) invoke /bin/sh, which is a symlink to /bin/dash.  The fix for this problem is to make bash the default shell on a system-wide basis.   The following command does that:

`sudo dpkg-reconfigure dash`

When you are asked whether to install dash as /bin/sh, answer No.  This will update the symlink, among other things.
