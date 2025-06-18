---
title: Fixing disabled TrackPoint after Mint 13 update
date: '2016-05-04 07:13:00 +0000'

tags:
- linux
- software
- linux mint
- thinkpad
- ubuntu
---
Yesterday I did a normal software update on a ThinkPad X200s running Linux Mint 13
(which is based on Ubuntu 12.04 LTS).
After the update and reboot, the TrackPoint (belly button mouse) no longer
worked.  This made working with the GUI desktop nearly impossible.

Fortunately, Linux has several virtual text consoles that can be used
to make repairs.  <!--more--> I used Ctrl-Alt-F1 to switch to the first of these consoles.
From there I tried doing a full upgrade, including a new kernel, using
these commands:

    sudo apt-get update
    sudo apt-get dist-upgrade
    sudo reboot

This didn't fix the problem.  After some searching, I determined that
for some reason, the `psmouse` kernel module, which controls the
TrackPoint, was not loaded.  The fix was to switch to a text console
using Ctrl-Alt-F1, as mentioned above.  Then I loaded the module using this command:

    sudo modprobe psmouse

After switching back to the GUI using Ctrl-Alt-F8, the TrackPoint
started working again.

To make this fix permanent, as root (using sudo and a favorite editor)
edit the file `/etc/modules` and add this line:

    psmouse

This forcibly loads the module at startup.  This didn't used to be necessary,
and it is not clear why it is now.
