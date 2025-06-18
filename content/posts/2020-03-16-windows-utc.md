---
title: Windows, UTC, and the hardware clock
date: '2021-03-16 08:48:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
- windows
---

Users of Windows / Linux dual boot systems might notice that the time of day
is correct in LInux but incorrect in Windows.  I ran into this problem with
a PC at our local library.  There is a fix for this, but to explain
the cause of the problem in the first place, we have to look at the 40-year history
of the IBM PC and subsequent compatible computers.

<!--more-->

The first IBM PC, introduced in 1981, had a hardware clock that allowed the machine
to keep the correct time even when it was powered off.  The clock was a simple CMOS
(i.e., low-power) chip backed up by a tiny battery that could last many years.
Back in 1981, the operating systems used on the PC (such as MS-DOS) had no conception
of time zone, so they assumed that the hardware clock was set to the local time,
not UTC (Universal Time, formerly known as Greenwich Mean Time or GMT).

The hardware clock still exists in modern PCs, but timekeeping is much different
now in modern operating systems.  Nowadays, an OS such as Linux or Windows understands time zones,
so it is able to keep its internal notion of the time of day in UTC.  When displaying
the time to users, the OS adjust the UTC time to local time to account for the time zone.
For example, my computer is in the Eastern Time Zone (Daylight Saving Time), so the OS
knows to subtract four hours from UTC to display the local time.

A modern OS can also query a time server on the internet, using the
so-called NTP protocol, to get the exact time.  This is especially
useful when sharing files with other computers on the net: you want
the timestamps on those files to be correct to avoid confusion.

The problem comes about when the OS starts up.  Before the network is available
(or if the machine is not even connected to the internet), the OS must use the
hardware clock to initialize its internal time counter.  Here is where Windows
and Linux differ: by default Windows assumes that the hardware clock is set
to local time, but Linux assumes it is set to UTC.  The use of UTC by Linux is a much more sensible
choice, because it means that if the computer is moved to a different time zone,
or when the time changes due to Daylight Saving Time, the user does not have
to manually change the time: Linux will adjust the time automatically.

The use of local time by Windows is probably due to Microsoft's desire to
be backwards-compatible with older operating systems.  But it creates problems
for the user, because the time will be incorrect in the situations mentioned
above.  It's especially a problem if the hardware clock isn't set correctly.  You
may not notice this problem on a Linux machine connected to the network,
because within a few seconds after it boots, it will use NTP to get the correct time.
Unfortunately, Windows does not appear to use NTP immediately after booting;
some forum posts imply that it waits one hour before using NTP.  So during
that first hour, the time of day may well be wrong.

The fix is to tell Windows that the hardware clock is set to UTC, not local
time.  Then use Linux to write the correct UTC time to the hardware clock.

First, boot Windows, and click on the Start menu (or whatever they're calling
it this week).  In the search box, type "regedit" (without the quotes).  This
should display a single choice, the regedit program, so click on that choice.
Answer "Yes" to the question about whether you want regedit to make changes
to your computer.  In regedit, nagivate to this point in the registry tree:

    HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation

In that set of keys, right click on an empty space and create a new key of type DWORD
called `RealTimeIsUniversal`.  Regedit will set it to 0.  You must set it to
1 by double-clicking on its name, which will allow you to change its value.

Reboot into Linux.  Wait a minute for the correct time to be obtained via NTP.
Then run the following command in a terminal session:

    sudo hwclock -u --systohc

This writes the current system time to the hardware clock as UTC.
You can verify that the hardware clock is set to UTC by booting into the BIOS,
and seeing what it displays as the time of day.  In the case of my computer
mentioned above, the BIOS shows the time of day as being local time plus four hours,
which is UTC time.

Now when you reboot Windows, you should see the correct time displayed, assuming that
you've previously set the time zone correctly.
