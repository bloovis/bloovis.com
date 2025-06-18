---
title: Reading non-DRM ebooks using the Amazon Kindle app for Android
date: '2010-06-30 11:53:56 +0000'

tags:
- android
- kindle
---
\[*Update*: According to recent comments (thanks!) the procedure described below no longer works and there is apparently no workaround.\]

The new Amazon Kindle app for Android stores its books in the "kindle" directory on the phone's SD card.  I naively assumed that I could copy any non-Amazon but Kindle-compatible books into that directory and have the app recognize them.  I tried this with a mobipocket Jane Austen collection (a .prc file) that works just fine on the Kindle, but the Android app crashed immediately after display the book's title and author.

The trick to getting such a book to be recognized on Android is to use Amazon's free personal documents service to convert the file to a DRM-ified .azw file.

First, I emailed the .prc file as an attachment to my free personal documents email address: EXAMPLE@free.kindle.com (obviously, you must replace EXAMPLE with your configured Kindle email address). Within a few minutes Amazon converted the file to a .azw (DRM-ified version of the original file), and replied with an email that included a download link for the converted file.

I saved the file to a temporary directory on my computer and renamed it by changing the .azw extension back to .prc.  This renaming is very important; otherwise, the Android app won't recognize the file.

Finally, I copied the file to the kindle directory on the phone's SD card. The Kindle app can see the file and display its contents.

\[*Note*: I tested this procedure on a Nexus One; no guarantees about other devices.\]
