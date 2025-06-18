---
title: Using an "unauthorized" network card in a ThinkPad
date: '2012-10-26 18:35:12 +0000'

tags:
- linux
- thinkpad
---
I recently decided to replace the Intel Wimax/WiFi Link 5350 card in a ThinkPad X200s, because the WiMax part of the card seemed to be flaking out and causing Linux kernel errors and hangs.  I found a generic (non-Lenovo branded) Intel 5300 card, which is just a WiFi adapter (no WiMax).  But I got an unpleasant surprise when I powered on the X200s: the BIOS gave an error message: "1802: Unauthorized network card is plugged in - Power off and remove the miniPCI network card" and then refused to boot.  It turns out that the ThinkPad BIOS has a whitelist of supported network cards and won't boot if the card isn't on the list.  The solution I used was to put a tiny piece of transparent tape over pin 20 of the card, then install it in the second MiniPCI slot (the WWAN card slot).  The WiFi LED on the ThinkPad no longer works, but the machine boots and the network card works.

For complete details on the problem and the solutions, see this [ThinkWiki page](http://www.thinkwiki.org/wiki/Problem_with_unauthorized_MiniPCI_network_card).
