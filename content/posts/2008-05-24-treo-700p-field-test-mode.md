---
title: Treo 700p field test mode
date: '2008-05-24 16:09:28 +0000'

tags:
- treo
---
I recently moved to a rural location where cell phone signal strength is weaker.  The signal strength indicator (the "bars" icon) on the Treo 700p isn't terribly useful in finding the strongest signal in and around the house.  A more accurate method of determining signal strength is to put the phone into field test mode.  You do this in the main phone app by dialing ##33284, or ##DEBUG, and pressing Dial.  (This is for Sprint Treos; for other carriers, see [this page](http://fieldtest.necellularsites.net/palm.htm).) This brings up a continuously updated "Debug Parameters" display.  The signal string is the "RSSI Value" on the top line.

At my home the RSSI values ranged from -95 to -102 depending on where I was standing, with the larger (less negative) numbers indicating stronger signal.  According to [this posting on HowardForums](http://www.howardforums.com/showthread.php?t=1327053), -105 is the "no service" point.  This will come in handy in determining where to mount the [external panel antenna](http://www.criterioncellular.com/antennas/planarpanelantennas.html) when it arrives.
