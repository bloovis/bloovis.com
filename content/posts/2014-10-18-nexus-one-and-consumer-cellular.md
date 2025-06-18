---
title: Nexus One and Consumer Cellular
date: '2014-10-18 09:39:35 +0000'

tags:
- android
- nexus one
---

We have two Nexus One phones, one of which is used as our internet
connection (no broadband here) and long-distance phone.  The other is
almost never used as a phone or an internet terminal.  Both of these
phones are on an AT&T family plan, which is ridiculously expensive
given the poor quality of the service (internet almost unusable during
the day).  So I started looking for alternate services, and decided to
try Consumer Cellular. <!--more--> This is a service that piggybacks on AT&T, but
offers much lower prices; it looked like we could switch both phones
and cut our bill by 50%.

To avoid disruption to our internet and long distance service, I
decided to experiment by switching the lesser-used phone to Consumer
Cellular, and if it worked well, I could switch the other phone.  The
company lets you use your own device and ships a SIM card for this
purpose.  This went smoothly, and after I activated the SIM card
through the company's web site, the phone was able to make voice
calls.

But there was no data service.  After a lot of head-scratching and
Google searching, I found the solution: switch the APN (Access Point
Name). In Cyanogenmod 7 (the Android variant being used on the phone I
switched), hit the menu button, and select Settings, then Wireless &
networks, then Mobile networks, then Access Point Names.  There were
now two APNs to choose from, where there had been only one before the
switch in service.  Select StraightTalk ATT (att.mvno), which is the
APN used by Consumer Cellular.  After this, the data service was
functional and the phone could make a 3G connection, do tethering,
etc. 
