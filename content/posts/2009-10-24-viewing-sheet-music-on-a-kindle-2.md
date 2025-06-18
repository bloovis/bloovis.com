---
title: Viewing sheet music on a Kindle 2
date: '2009-10-24 18:46:47 +0000'

tags:
- kindle
- linux
---
The screen on the Kindle 2 is really too small for reading music at the piano, but it can be used as a replacement for the small pocket scores that are used for study. The trick is to convert the sheet music PDF file into a series of JPEG picture files.  Here's how to do that on Linux:

First, create a separate directory on your Linux machine for the sheet music score that you want to convert.  This avoids clutter and accidents.

Then, convert the PDF file to one or more JPEG files using a command like this:

`convert -geometry 600x800 op-118.pdf op-118.jpg`

The convert program creates one JPEG file for each page in the PDF, using the second parameter as a filename template.  In this example, it created the files `op-118-0.jpg`, `op-118-1.jpg`, etc.  The -geometry option reduces the size of each picture to 600x800 pixels, which is the size of the Kindle 2 screen.

(The convert program is part of the ImageMagick suite; on Ubuntu you can install it using `sudo aptitude install imagemagick`.)

To avoid possible out-of-order sorting problems when there are more than 10 pages (`op-118-2.jpg` appearing after `op-118-10.jpg`), you can rename the first 10 files using this command:

`rename 's/-([0-9])\.jpg/-0$1.jpg/' *.jpg`

This ugly bit of regular expression magic renames `op-118-0.jpg` to `op-118-00.jpg`, `op-118-1.jpg` to `op-118-01.jpg`, etc.

Now you can copy the files to the Kindle.  First, create a directory called `pictures` in the root of the mounted Kindle device.  Then create a subdirectory of `pictures` with a recognizable name for your score.  The Kindle will display this name in its home screen, so choose wisely.  For this example, I created the directory `pictures/brahms-op-118` on my Kindle.

Finally, copy the JPEG files to the directory you just created, unmount the device, and disconnect it.

The Kindle doesn't show pictures by default.  Press **alt-Z** on the home screen to force the Kindle to scan the `pictures` directory.  It will now show each subdirectory of `pictures` as a separate "book".  When you navigate into such a book, the Kindle will display the series of pictures in that directory.  The bottom of each picture may be chopped off, so press the **F** key to display it in full screen mode.

Look [here](http://ireaderreview.com/2009/03/09/kindle-2-tips-kindle-2-hack-list-top-25/) for additional information on the Kindle picture viewer (scroll down to Kindle 2 Tip #4).
