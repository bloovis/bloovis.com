---
title: The Kindle DX and PDF metadata
date: '2009-10-06 09:42:42 +0000'

tags:
- kindle
- kindle dx
- ruby
---
One of the most common complaints about the Amazon Kindle is its lack of support for "folders".  In Linux terms, this means that the Kindle flattens your "documents" directory tree when it displays the list of your books on its home screen.  However, a directory-browsing UI would be much less flexible than a tagging system, because it would require you to impose an arbitrary hierarchy on your documents.  Fortunately, there is a workaround for this that implements a kind of [pseudo-tagging using annotations](http://kindleworld.blogspot.com/2009/05/customer-workaround-for-user-definable.html).  The advantage of this workaround is that it's performed on the Kindle and doesn't require a separate computer.

Even without tagging, the Kindle allows your document list to be sorted either by author or title.  Then you can jump to authors or titles starting with a particular letter by pressing that letter key and clicking the 5-way controller.  I find this shortcut adequate for most purposes.

But PDF documents, which are supported in a limited fashion on the Kindle DX, present special problems.  First, the tagging workaround can't be used because annotations are not supported.  Secondly, if the author and title aren't set correctly in the PDF file's metadata, the Kindle will fall back to using the filename as the title of the document.  Even if the title is set correctly, the Kindle won't display it in the home screen; it will display the filename instead, and only show the actual title when you highlight the file and then 5-way to the right.  And finally, many PDF files, such as sheet music from the [IMSLP](http://imslp.org/wiki/Main_Page), will have missing or incorrect metadata.  (This is a problem with non-PDF ebooks too, such as those from the [Baen free library](http://www.baen.com/library/).)

So in order to sort through large numbers of PDF files on the DX, it's very important to set the author metadata correctly.  The free [calibre](http://calibre.kovidgoyal.net/) program supposedly can do this, but I choose not to use it because I wanted to use my own scripts and have more control over my directory structure.  So instead, I'm using the [pdftk](http://www.pdfhacks.com/pdftk/) utility to modify the metadata in my PDF files.  In particular, I'm setting the Author and Title fields, which appear to be the only ones that the Kindle recognizes.  (I had hoped that the Kindle would also recognize Keywords, but that doesn't appear to be the case.)

However, pdftk is a little clumsy to use in this fashion.  It reads and writes metadata in a format that's not very convenient.  You have to prepare a text file that looks like this:

```
InfoKey: Title
InfoValue: Six Piano Pieces Op. 118
InfoKey: Author
InfoValue: Brahms
```

Then you pass this text file to pdftk using its update_info subcommand.  I found this usage annoying, so I wrote a wrapper script in Ruby called [pdfmeta](/downloads/pdfmeta) that lets you specify the author and title on a single command line.  Using the above example, here's how I would update the author and title for a piece of sheet music that I downloaded from the IMSLP:

```
pdfmeta -a Brahms -t "Six Piano Pieces Op. 118" op-118.pdf
```

There's one catch with this: If you transfer a PDF file to the Kindle, then discover that you need to change the metadata, you'll need to delete the old file on the Kindle, then rename the updated file (changing or adding one letter is enough) before copying it to the Kindle.  Otherwise, the Kindle will continue to use the old, incorrect metadata; apparently it stores this information in a separate index keyed by filename, and doesn't delete or update that information when you update the file.
