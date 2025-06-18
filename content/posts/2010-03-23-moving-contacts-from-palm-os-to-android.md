---
title: Moving contacts from Palm OS to Android
date: '2010-03-23 03:06:17 +0000'

tags:
- android
- centro
- nexus one
- treo
---
After nearly ten years of using Palm OS PDAs and cell phones, I'm moving to an Android phone.  I didn't want to enter over 100 contacts manually on the new device.  Some Google searching turned up ways to migrate the contact list, but most of them involved running Palm Desktop software on Windows.  It turns out there is a non-obvious, Windows-free method, described [here](http://androidcommunity.com/forums/267304-post9.html).  In case that forum posting goes away, here's a repeat of this method (slightly modified):


* On the Palm device, run the Phone app, then select Contacts.
* Choose the category to display; I chose All.
* Press MENU button and choose Send Category.
* Choose Email; this will send your contacts as an attachment file called `All.vcf`, and will bring up the email app to send it.
* In a web browser on your desktop computer, open your Gmail account.
* Find the message containing the attachment `All.vcf`.  Click on the download link for the attachment and save it somewhere on your computer.
* In Gmail, select Contacts, then Import, and locate the file you saved in the previous step.  Gmail will merge the contacts contained in that file into your existing Gmail contacts.  Your Android device will find those contacts when it syncs.

