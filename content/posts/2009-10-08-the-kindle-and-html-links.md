---
title: The Kindle and HTML links
date: '2009-10-08 10:27:13 +0000'

tags:
- kindle
- kindle dx
---
I had heard that the Kindle would recognize (and display correctly) HTML documents, if you renamed them to have a `.txt` filename suffix.  My hope was that it would also recognize internal and external links.  If this were the case, then it would be possible to write scripts that would help with the lack of organizational tools.  These scripts could walk the documents directory tree and construct HTML files that represented that tree.  It would also be possible to extract metadata (such as author, title, and keywords) and represent them appropriately in HTML.

But it turns out that this is not possible.  The Kindle displays the formatting of HTML documents correctly, and even supports external links of type `http:`.  But it does not support other types of links, such as `file:` or internal links.

These are limitations in the file viewer that the Kindle launches when you select an HTML (`.txt`) file from your home screen.  (Such files show up in the "Books" section.)  The experimental browser is slightly better, though.  It recognizes `file:` links and allows you to select them, and will jump to the appropriate document.  To get this to work, your HTML documents must have the extension `.html`, not `.txt`.  Also, the external links in your document must have the prefix `file:///mnt/us/`.  In other words, if you want to create a link to the file `documents/test.html`, the href attribute in the link must be `file:///mnt/us/documents/test.html`.

But there are some serious limitation in the browser's support for links that make it unusable for my original purpose.  First, the browser will not work if Whispernet is unavailable; in fact, it will hang the Kindle, forcing you to do a hard reset.  Secondly, it does not allow links to other types of files besides HTML.  I tried linking to a `.azw` file in the documents directory, and the browser complained that it could not open the file.  The browser does recognize such a file when it is in an `http:` link, though, and will offer to download the file.

So it looks like there is no easy way to construct organizational tools using the Kindle's HTML support.
