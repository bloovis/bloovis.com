---
title: Batch resizing images in Linux Mint / Ubuntu
date: '2009-01-05 04:29:09 +0000'

tags:
- linux
- linux mint
- ubuntu
---
I recently switched my two main laptops to [Linux Mint](http://www.linuxmint.com).  I've been running KDE-based Linux distributions for years, and this is my first experiment with Gnome.  Right away, I discovered that there are apparently no Gnome applications that can resize multiple images as easily as the premier KDE photo application, Digikam.  GThumb, an otherwise decent photo viewer, has a [memory leak bug](http://bugzilla.gnome.org/show_bug.cgi?id=349576) in its "scale images" feature that quickly brings the system to its knees; this bug was supposedly fixed long ago but has resurfaced in Ubuntu 8.10.  The batch plugin for Gimp looks like it ought to work, but almost always fails with various errors.

At this point, I resorted to using the ImageMagick "convert" command-line tool to resize images, which works fine, but is a little inconvenient, because it's not possible to visually select the images for resizing.

I then came across a variant on this idea that works with Nautilus, the Gnome file manager.  I took the script from [this blog posting](http://rhosgobel.blogspot.com/2006/07/bulk-resizing-and-renaming-images-in.html), then hacked it up a little to eliminate the renaming steps.  This works quite well.  You select one or more images in Nautilus, right click on them and select Scripts / Resize_Images.  The script pops up a dialog asking for a maximum resolution.  Then it starts to resize the images, placing them in a new subdirectory `resized_to_NNN`, where NNN is the new image size.  It displays a progress dialog during the process.

I've placed a copy of my hacked version of the script [here](http://www.bloovis.com/downloads/Resize_images).  After downloading it, move it to the `~/.gnome2/nautilus-scripts` directory and make it executable using `chmod +x Resize_images`.

There is one serious problem with this script: the dialog boxes it pops up almost always end up being hidden behind other windows.  This is a known bug with Zenity, the application used by the script to display dialogs.  The problem and workaround are described in this [bug report](https://bugs.launchpad.net/zenity/+bug/272083).

*Update*: In more recent versions of Linux Mint that use Mate instead of Gnome, the
script should now be placed in the `.config/caja/scripts/` directory.
