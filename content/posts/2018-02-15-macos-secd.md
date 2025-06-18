---
title: Mac OS Sierra and secd hogging CPU
date: '2018-02-15 01:40:00 +0000'

tags:
- software
- mac
---

A friend with a 2011 Mac Mini running Mac OS Sierra was complaining that the machine was running
very slowly.  Was the machine too old and needed to be replaced by a new one?
Was the problem due to opening large numbers of tabs in Firefox?
I was skeptical that either of these was the problem.  My ThinkPad is
even older (2008), has similar specs (Core 2 Duo processor, 8 GB RAM)
and is plenty fast (Linux shouldn't be much different from Mac OS
in this regard).

<!--more-->

When I finally got to take a look at the machine, it was obviously
very sluggish, as my friend had said.  But more suspiciously, the fan
was running continuously.  This is a sure sign of excessive CPU usage.

I opened a Terminal session and ran 'top -o cpu', and a process called
`secd` was at the top of the list, using 98% of a CPU.  The Activity
Monitor (a GUI version of top) showed the same thing.  A few minutes
with a search engine uncovered a number of Sierra users complaining
about secd.  The problem seemed related to iCloud and keychains.
There were a number of solutions that seemed excessively complicated.
In the end, this [simple solution](https://atsblog.allcovered.com/2016/11/15/sierra-secd-bug-linked-to-icloud-keychain/)
did the trick.  Here's what I did:

Open the iCloud preferences (found in the System Preferences, which is found
by clicking on the Apple logo at the left side of the menu bar).  In the
iconified list of services, check the one called Keychain.  Unfortunately,
this prompted the user to enter the iCloud password, then a six digit
security code, then the number of a cell phone that can receive SMS.

Checking again with top and Activity Monitor showed that secd was no
longer hogging the CPU.  In a few minutes, the fan turned off.

The post linked to above says that checking and un-checking Keychain
in the iCloud preferences is all that is necessary, so it is possible
that all the steps involving the password, security code, and cell
phone number were not needed.
