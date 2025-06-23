---
title: Creating business cards with Gimp and ImageMagick
date: '2015-08-29 11:20:59 +0000'

tags:
- graphics
- linux
- software
---
In the search for ways to create business cards on Linux, I came across a couple of
useful items from the GimpWimp.  First, a video showing
how to use the Gimp to copy and paste a business card into a template for printing a sheet of ten cards
<!--more-->

{{< youtube E_2RERCpdNo >}}

Second, a related blog [posting](https://thegimpwimp.wordpress.com/2012/08/20/business-card-template-for-gimp-users/)
describing the process in words.  But there are a couple of problems
with this technique when used with an Avery card sheet instead of
uncut card stock.

The first problem was that the horizontal lines in the template take
up just enough space that the cards at the bottom of the template end
up being located slightly too far down on the sheet.  This means that
letters or figures on the cards' bottom edges may end up being chopped
off or falling on the card below.

The other problem was the tedious manual work.  The GimpWimp's tips
for creating the single business card and printing the sheet of cards
are excellent, and I followed them carefully.  But the part about
copying and pasting the single card ten times into the sheet of cards
and filling in the guide lines was quite tedious.  It turns out there
is a much simpler method for creating the sheet of cards from a single
card, using the ImageMagick command line tools.

First, create the single business card, using a
1050x600 canvas.  Flatten all the layers in the card and export it to
a PNG file, preserving the original XCF file for later modifications.
Then move to the terminal command line.  Assuming the card has been
exported to a file called `business-card.png`, the following commands
create a ten-card image called `cards.png` with the proper border for
printing on an Avery business card sheet:

```bash
montage business-card.png business-card.png \
    business-card.png business-card.png \
    business-card.png business-card.png \
    business-card.png business-card.png \
    business-card.png business-card.png \
    -tile 2x5 -geometry +0+0 cards-noborder.png
convert -border 225x150 -bordercolor white cards-noborder.png cards.png
```
