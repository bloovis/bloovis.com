---
title: Ispell unable to open default.hash
date: '2018-11-23 07:18:00 +0000'

tags:
- linux
- linux mint
- ubuntu
---

For some reason, one of my Linux Mint 18.1 machines was not able to run
ispell, which gave this error message:
<!--more-->

    Can't open /usr/lib/ispell/default.hash

Comparing this installation with another machine running the same OS,
it seemed that the missing file was supposed to be the first in a chain
of symlinks that eventually pointed to `/var/lib/ispell/american.hash`.
The man page for ispell suggested that the `buildhash` program might
possibly create the missing files, but I could find no instructions
online about how to use it.

Eventually I figured out that I needed to install the missing `iamerican`
package, which contains the missing files and runs `buildhash` as part
of its configuration script.  I'm still not sure why this package wasn't installed
automatically when the Mint was first installed on this machine.
