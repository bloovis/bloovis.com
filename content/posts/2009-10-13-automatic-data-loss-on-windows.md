---
title: Automatic data loss on Windows
date: '2009-10-13 17:21:43 +0000'

tags:
- software
- windows
---
My employers have given me a Windows XP-64 machine, which sits 3000 miles away on the opposite coast.  Operating it remotely using TightVNC isn't anywhere near as fast or convenient as ssh, but at least it works.

The machine seemed to be working fine when I disconnected from it on Saturday night.  When I reconnected on Sunday morning, my session with all of its terminal windows was gone, and the login screen was showing.  Today, after poking around with the Event Log GUI (nothing so easy as `sudo less /var/log/messages`), I figured out what went wrong.  A process called the Windows Update Agent started running at 3 AM Sunday morning, and after five minutes it rebooted the machine.  So apparently Windows has an automatic data loss feature that is built in and enabled by default.

A Google search turned up [this article](http://blogs.msdn.com/tim_rains/archive/2004/11/15/257877.aspx), which says that the way to fix the automatic reboot is to edit the registry at `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\Auto Update` and create an entry called `NoAutoRebootWithLoggedOnUsers` with the value 1.  I also found [this article](http://www.geeked.info/disabling-windows-update-auto-reboot/), which shows how to use a GUI to disable the feature; this is the method I used, though I don't know if it actually works.  Either way, you have to wade through many levels of settings to find the right one, something that would be almost impossible without Google. And people think editing plain-text configuration files on Linux is hard!
