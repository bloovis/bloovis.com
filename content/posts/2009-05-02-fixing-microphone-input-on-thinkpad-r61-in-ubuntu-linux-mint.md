---
title: Fixing microphone input on ThinkPad R61 in Ubuntu / Linux Mint
date: '2009-05-02 10:06:49 +0000'

tags:
- linux mint
- thinkpad
- ubuntu
---
Yesterday I tried using the internal microphone on the ThinkPad R61 for the first time, in an attempt to make a Skype call.  Skype kept saying there was an error in the sound configuration.  After the usual Google searching and flailing about, I made the following changes to my system to fix the problem.  It's not clear whether all of these changes are necessary, but using them all certainly doesn't hurt.


* In Skype's Options / Sound Devices, change "Sound In" to the raw hardware device; mine was "HDA Intel (hw:Intel:0)", but it will take some experimentation and some test calls to figure out the correct setting.  Do NOT set it to "pulse"; there is a known bug in Ubuntu's implementation of PulseAudio that causes delays of many seconds on microphone input.

* Also in Skype's Options / Sound Devices, set both "Sound Out" and "Ringing" to "pulse".

* Also in Skype's Options / Sound Devices, it may be necessary to uncheck "Allow Skype to automatically adjust my mixer levels".

* Right click on the task bar's volume control (the speaker icon), and select Open Volume Control.  Hit the Preferences button, and add the following two controls: Capture (Recording) and Input Source (Options).  Then in the Volume Control dialog, in the Recording tab, bring up the Capture level to near full, and in the Options tab, set the Input Source to Internal Mic.

* Using sudo, edit the file `/etc/modprobe.d/alsa-base` and append the line:

   `options snd-hda-intel model=thinkpad`

I didn't find an easy way to reload the sound modules after the last change, so I had to reboot the system for it to take effect.

*Note*: these instructions apply to Linux Mint 6, and, presumably, Ubuntu 8.10.  I can't guarantee they'll work on other versions of Linux or other machines.
