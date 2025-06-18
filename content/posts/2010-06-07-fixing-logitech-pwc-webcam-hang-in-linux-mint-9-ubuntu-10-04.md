---
title: Fixing Logitech (pwc) webcam hang in Linux Mint 9 / Ubuntu 10.04
date: '2010-06-07 21:04:48 +0000'

tags:
- linux
- linux mint
- ubuntu
---
I have an old Logitech QuickCam for Notebooks that uses the pwc (Philips Web Cam) driver on Linux.  This camera has always worked flawlessly on Linux Mint 6 (Ubuntu 8.10).  But on Linux Mint 9, the camera only worked the first time it was plugged in; on subsequent plug-ins, no programs could read images from the camera.  The fswebcam utility reported a timeout trying to read the frame buffer; other programs like Cheese or Skype simply displayed blank images.

The solution is to unplug the camera (if it is not already unplugged), then forcibly remove the pwc driver:

<pre class="brush: plain">
sudo modprobe -r pwc
</pre>

Then the next time the camera is plugged in, the pwc driver will be loaded automatically and will work properly.  This has to be done every time you unplug the camera.  I'm not sure why this is necessary with recent Ubuntu releases.
