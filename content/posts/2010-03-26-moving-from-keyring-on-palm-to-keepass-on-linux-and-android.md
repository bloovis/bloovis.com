---
title: Moving from Keyring on Palm to KeePass on Linux and Android
date: '2010-03-26 04:02:59 +0000'

tags:
- android
- centro
- linux
- nexus one
---
[Keyring](http://gnukeyring.sourceforge.net/) is a fine little open source application for Palm OS that stores and generates passwords.  There is no Android version of this program, so I decided to move to KeePass 1.x, both the [Linux version](http://www.keepassx.org/) and the [Android version](http://www.keepassdroid.com/).

Then I hunted for way to import my Keyring data into KeePass 1.x.  I couldn't find a tool to do this, so I had to invent my own method, which included writing a conversion script in Ruby.

The first step is to generate an XML version of the Keyring data file, using this [Java program](http://gnukeyring.sourceforge.net/conduits.html).  I fed it the Keyring data, a file called `Keys-Gtkr.pdb` that I had previously backed up onto my Linux machine using pilot-xfer.  It produced the XML equivalent, which I redirected to a file.

Then I wrote a Ruby script called [kr2kp](/downloads/kr2kp), which reads the Keyring XML file  and outputs KeePass-compatible XML.  I saved the output of this script to another file.

The Android version of KeyPass doesn't import XML, so I turned to the Linux version, and used it to import the XML file I had created in the previous step.  Then I saved the resulting database into a file called `keyring.kdb`.

Next, I copied `keyring.kdb` to the `keepass` directory on the Android device's SD card.  (The exact path of the SD card will depend on the directory where your computer mounts the SD card when you connect the Android device via USB.)

Finally, I ran the Android KeePass app and opened the `keyring.kdb` file.  The Android app is somewhat limited, and doesn't let you move entries between groups or rename groups.  So that kind of manipulation has to be done on the Linux side, and then the .kdb file has to be copied to the Android SD card, as described above.
