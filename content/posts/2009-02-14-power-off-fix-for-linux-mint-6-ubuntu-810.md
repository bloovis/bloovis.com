---
title: Power-off fix for Linux Mint 6 / Ubuntu 8.10
date: '2009-02-14 13:56:39 +0000'

tags:
- linux
- linux mint
- ubuntu
---
The older computer on which I installed Linux Mint recently wouldn't power off properly after a shutdown.  This used to work on Mandrake 10.2.  Apparently the problem is due to the newer Linux kernels requiring ACPI by default for power management, and this machine's BIOS doesn't seem to provide a compatible ACPI implementation.

After the usual slogging through Google search results and numerous experiments, the fix was extremely simple: add the following line to `/etc/modules`:

```

Several forum postings I found with Google suggested other solutions, including boot parameters and commenting out lines in various configuration files, but these weren't necessary on this machine (which uses a [ Biostar M7VKQ motherboard](http://www.biostar-usa.com/mbdetails.asp?model=m7vkq)).
