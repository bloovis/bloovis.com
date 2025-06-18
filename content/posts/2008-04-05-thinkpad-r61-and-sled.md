---
title: ThinkPad R61 and SLED
date: '2008-04-05 19:58:52 +0000'

tags:
- linux
- software
- suse
- thinkpad
---
Lenovo now sells some ThinkPads that come with SUSE Linux Enterprise Desktop 10 SP 1 instead of Windows.  The cheapest of these is the R61.  I have owned an R61 for about a month and it's quite nice.  SLED has been performing admirably, and pretty much everything Just Works, including video, sound, suspend to disk or RAM, DVD movies, and wireless.  The Network Manager is especially nice, and it reliably detects and configures wireless connections, and automatically connects to networks it's seen before.  The wireless antenna in this laptop is very sensitive and picks up networks that other laptops miss.

But SLED did need a little bit of tweaking to suit my tastes. First, by default SLED uses Gnome as its GUI, and while it looked fine, I've been using KDE for many years and wanted a familiar environment.  I also wanted to migrate all of my mail (which is stored in KMail) to the new system.  But installing KDE wasn't completely trivial.  In the Software Management part of Yast (the SUSE control panel) there didn't seem to be a single master KDE package that would pull in everything I needed.  So I ended up installing the following packages (as printed by `rpm -qa | grep kde`):
```
kdebase3-3.5.1-69.52
kdenetwork3-3.5.1-32.24
kdebindings3-3.5.1-19.2
kdemultimedia3-CD-3.5.1-20.15
kdebase3-beagle-3.5.1-69.52
kdenetwork3-InstantMessenger-3.5.1-32.24
kdelibs3-3.5.1-49.39
kdelibs3-doc-3.5.1-49.35
kdepim3-3.5.1-41.30
kdepim3-networkstatus-3.5.1-41.30
kdegraphics3-pdf-3.5.1-23.13.1
kdebase3-kdm-3.5.1-69.52
kdemultimedia3-sound-3.5.1-20.15
kdegraphics3-scan-3.5.1-23.13.1
kdemultimedia3-video-3.5.1-20.15
kdepim3-sync-3.5.1-41.30
kdegraphics3-kamera-3.5.1-23.13.1
kdegraphics3-postscript-3.5.1-23.13.1
kdebase3-session-3.5.1-69.52
NetworkManager-kde-0.1r588481-1.17
kdebindings3-ruby-3.5.1-19.2
kdebase3-ksysguardd-3.5.1-69.52
kdemultimedia3-mixer-3.5.1-20.15
kdelibs3-arts-3.5.1-49.35
sled-kde-user_en-10.1-0.11
kdemultimedia3-3.5.1-20.15
kdeutils3-laptop-3.5.1-25.14
kdeutils3-3.5.1-25.14```
I didn't have to select all of these packages manually; some were pulled in via dependencies.

Once KDE was installed, it still wasn't presented as an option at the login screen.  I had to edit `/etc/sysconfig/displaymanager` and change DISPLAYMANAGER to "kdm".  Then rebooting brought up the proper login screen.

Then I discovered that KMail wasn't able to send mail via authenticated SMTP.  After some frustrating Google searches, I discovered that I needed to install the following Cyrus packages (as printed by `rpm -qa | grep cyrus`):
```
cyrus-sasl-plain-2.1.21-18.4
cyrus-sasl-crammd5-2.1.21-18.4
cyrus-sasl-digestmd5-2.1.21-18.4
cyrus-sasl-gssapi-2.1.21-18.4
cyrus-sasl-2.1.21-18.4
cyrus-sasl-saslauthd-2.1.21-18.4
cyrus-sasl-otp-2.1.21-18```
Finally, there was a strange problem running Yast from the KDE menus: nothing seemed to happen after I typed the root password, although running it manually from a terminal window logged in as root worked fine.  It appears that running Yast via kdesu is not always reliable.  To work around this, I created a desktop icon that runs `gnomesu yast2`, and that works every time.  But strangely, now I can't reproduce the problem with kdesu.  So this problem still remains to be diagnosed.
