---
title: Fixing "send to" in Shotwell on Linux Mint Mate
date: '2016-02-15 09:38:00 +0000'

tags:
- linux
- linux mint
---
I recently set up a ThinkPad T61 with Linx Mint 17 Mate for a long-time Mac OS user.
I installed Shotwell as the photo manager.  It is the default photo app in Ubuntu,
and it seemed the closest to iPhoto due to its ability to organize photos by "events" (grouping
by timestamp).  I also installed Thunderbird as the email handler.  But the Shotwell
"send to" feature, which is supposed to allow the user to send a photo via Thunderbird,
did not work.  <!--more-->

The "send to" feature is supposed to work this way: you right-click on a photo, select "Send To",
and then a dialog box pops up that gives you the option to shrink the photo.  When you press "OK",
a second dialog box is supposed to pop up that lets you decide where to send the photo: either
to a file on a disk, or to your default email problem (Thunderbird in this case).  But this
second dialog box did not appear.  Instead, an error message appeared saying that the nautilus-sendto
program could not be found.  This was an important clue to the fix.  But first, some background.

Mate is a destop UI that was forked from the very popular Gnome 2 after Gnome moved
to version 3 and a completely different look and feel.  To avoid conflict with existing Gnome
programs, the Mate equivalents were renamed.  In Gnome, the file manager was called Nautilus;
in Mate it is called Caja.  The nautilus-sendto program is a helper program that runs
the aforementioned second dialog that asks the user where to send a file.
The equivalent to the missing nautilus-sendto in Mate is caja-sendto.  So the fix
to the Shotwell bug is to install caja-sendto, and then fool Shotwell into running
caja-sendto instead of nautilus-sendto.  This is done using the following commands
in a terminal window:

    sudo apt-get install caja-sendto
    cd /usr/bin
    sudo ln -s caja-sendto nautilus-sendto

After running these commands, Shotwell will now be able to send photos via Thunderbird
using its "send to" feature.
