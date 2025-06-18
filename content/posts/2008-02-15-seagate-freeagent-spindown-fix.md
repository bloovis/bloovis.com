---
title: Seagate FreeAgent spindown fix
date: '2008-02-15 04:55:05 +0000'

tags:
- freeagent
- hardware
- linux
- seagate
---
A few months back I bought a Seagate FreeAgent external USB hard disk with 320GB of space.  The intent was to use it as a backup device for my ThinkPads, all of which run Linux.  Formatting the drive for ext3 was no problem.  I started my first backup one night and went to bed.  When I woke up the next morning, I couldn't access the drive; it appeared to have spun down due to inactivity.  After some Google searching, I found a solution [here](http://alienghic.livejournal.com/382903.html).   Quick summary: run the following command as root the first time you connect the drive:
```
This turns off the drive's idle timeout, and it appears to be a sticky setting that survives power-off.

Adjust the device name for your particular system.  You can look at `/var/log/messages` for clues if your desktop icons aren't being helpful.
