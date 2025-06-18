---
title: Pandoc on Linux Mint 18
date: '2017-03-10 09:45:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
---

As mentioned [earlier](/posts/2016-01-07-word-processors-considered-harmful-part-2/),
I use Pandoc instead of a word processor to prepare printed documents.  Installing
it on Linux Mint 18 reminded me that in order to create PDF files,
you need to install more than Pandoc itself.  Here is what I had to do
to install Pandoc and the Latex files it requires:

    sudo apt-get install pandoc lmodern texlive-latex-recommended \
                         texlive-latex-extra texlive-fonts-recommended
