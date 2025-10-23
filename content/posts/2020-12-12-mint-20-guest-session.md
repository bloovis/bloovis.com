---
title: Fixing Guest Session on Linux Mint 20
date: '2020-12-12 15:40:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
---

It appears that out of the box, the guest session feature of Linux
Mint 20 (and Ubuntu 20.04) is broken.  In the Mate edition of Mint,
this feature is enabled in the Login Window portion of the Control
Center.  But if you attempt to login as a guest, an error dialog pops
up saying "Could not update ICEauthority file
/run/user/999/ICEauthority".  The desktop eventually appears, but only
after a very long delay.

The fix is described in this [forum post](https://forums.linuxmint.com/viewtopic.php?p=1904811#p1904811).
The following two commands are all that is necessary:

```
sudo apt-get install apparmor-utils
sudo aa-complain /usr/lib/lightdm/lightdm-guest-session
```
