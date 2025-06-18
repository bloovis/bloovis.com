---
title: Linux as an Internet Kiosk
date: '2016-11-16 05:36:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
---

*UPDATE May 2020*: this procedure has been greatly simplified for Linux Mint 19.

For some time I have been looking for a way to use Linux as an
internet kiosk in our small local library.  The library currently has
a number of computers available for use by patrons, ranging from
netbooks to desktops, all running some variant of Windows 7.  Some of
these machines are crippled by not having Office licenses.

<!--more-->

The main problem with shared computers is privacy.  When users run a
browser to look at their email, the users often forget to log out,
leaving their email open to other users.  Some email providers (like
Gmail) leave cookies in the browser, revealing information like user
names (if not passwords).  Occasionally, users attempt to install
browser extensions or other software that can cause problems for other
users or disrupt the operating system itself.

Ideally, a shared public computer should provide an unprivileged guest account that is
restored to a pristine state when the user logs out.  Apparently there
are solutions for Windows that provide this feature, but I was looking
for a way to avoid Windows entirely, since our library's computers are
already quite slow due to Windows itself and the accompanying
antivirus software.  Windows 7 is supposedly faster than its
predecessor, Vista.  But to me, on modern (Core i7) hardware it still
feels much slower than Linux Mint on ancient (Merom) laptops.

Another problem I'd like to avoid is licensing fees.  Office is not cheap, and it would
nice if all of our shared computers provided some kind of office software for those
rare occasions when users have to edit or view a word processing document or spreadsheet
that they might have received in an email or downloaded from a web site.

It would also be nice if the operating system were permanenly installed on the computer,
and not just run from a USB flash drive, which could be easily damaged or lost.

There are several kiosk-specific Linux distros that provide some, but not all,
of the features mentioned above.  Porteus Kiosk provides a fully installable
system, but does not provide extra features like LibreOffice without quite
a bit of extra work.  This extra work looked quite daunting at first glance, and
it was not obvious if it was even possible to get the features I was looking for.

Finally I came across a
[how-to](https://easylinuxtipsproject.blogspot.com/p/hacks-mint.html#ID1) that
describes how to convert a Linux Mint machine into a kiosk.  The
idea is to create a "frozen guest account" that uses a temporary
directory as a home directory, and which is recreated from scratch at
each login.  The only problem I've found with those instructions
is that it's necessary to restart Linux after enabling the guest account.

Here's a brief summary of those instructions:

Log in to your normal adminstrator account (typically the first account
you created when you installed Mint, and the one that has "sudo" privileges).

In Menu / Administration / Login Window, enable guest accounts.

Reboot the computer.  This is the missing step; it's necessary in
order for the login window to display the Guest Account option, which
you should now see after rebooting.

Log in to your administrator account.

In Menu / Administration / Users and Groups, create a new
user with the full name "Hospitality" (capitalized) and login name "hospitality" (NOT capitalized).
Give it the same password as your super-user account.

Log out and log in as Hospitality.  Configure the account as you'd
like the guest account to appear.  This might involve adding the Privacy
Badger and uBlock Origin extensions to Firefox, adding icons for useful
programs like LibreOffice to the desktop, changing the desktop background,
etc.

Log out and log back in to your administrator account.

In a terminal session, execute this command:

    sudo ln -v -s /home/hospitality /etc/guest-session/skel

This causes the Hospitality account to be used as the template
for the guest account.

Log out and log in as the "Guest Account".  You should
see that the desktop is a copy of the Hospitality account's
desktop.

If in the future it's necessary to change any details about the
Guest Account's desktop, make those changes in the Hospitality
account.
