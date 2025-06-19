---
title: Tagging Ogg Vorbis music files for classical music
date: '2023-08-07 06:49:00 +0000'

tags:
- android
- linux
- music
- ruby
- software
---

Fifteen years ago, I started ripping my CD collection into digital
form using the patent-free file formats FLAC and Ogg Vorbis.  I used
[FLAC](https://en.wikipedia.org/wiki/FLAC) for the first stage of ripping, because it is lossless.
But FLAC is also quite bulky, which is a problem when using the files
on space-limited portable devices.  So the next stage was to convert
FLAC to [Ogg](https://en.wikipedia.org/wiki/Ogg) [Vorbis](https://en.wikipedia.org/wiki/Vorbis),
which is compressed, lossy format similar to MP3, but free of
patents and royalties.

Fifteen years ago I was using a fourth generation iPod as a music player,
which did not support Ogg Vorbis.  So I replaced the built-in firmware
with [Rockbox](https://www.rockbox.org/), which supports multiple music
formats.  It also provides gap-free playback, useful for long works like
*Pelleas et Mélisande* and *The Lamb Lies Down on Broadway* that often have no gaps between tracks.

This system worked well until three years ago, when my ex-wife stole my iPod,
along with thousands of dollars of other personal property.  Since then
I've been trying to use Android devices to replace the iPod.  This process
was made more difficult by the lack of suitable music players for Android
that (1) supported Ogg Vorbis, and (2) had gap-free playback.

Eventually I found a few Android apps that did these two things, but
there was another problem that I'd hoped to solve, and which Rockbox
hadn't solved either.  That was the problem of tagging that supported
classical music.  Tags are bits of information that are embedded in music
files that give the album name, date, artist, genre and track information.
The problem with tagging conventions is that they were hardened by the early
adoption of the iPod into supporting popular music, but were inadequate
for classical music.  The iPod seemed not to understand the concept
of an album in which the perform and composer were different, or
that might contain multiple works, each composed of multiple tracks,
or that these works might have different composers or performers.

Eventually I found a music player for Android that supports classical
music: [Opus 1 Music Player](https://f-droid.org/en/packages/de.kromke.andreas.opus1musicplayer/).
It has a companion [Classical Music Tagger](https://f-droid.org/en/packages/de.kromke.andreas.musictagger/)
app that lets you add the appropriate tags to music files, and
a [Classical Music Scanner](https://f-droid.org/en/packages/de.kromke.andreas.mediascanner/) app
that builds a database based on the the tags it finds in the device's music files.  I tested the
tagger on some Ogg Vorbis files I'd copied to an Android phone,
and then examined the files on a Linux machine to see which tags
were used.  I determined that these apps were using the following
additional tags to support classical music:

* COMPOSER - the actual composer, *not* the performer
* GROUPING - the title of the work (e.g., "Symphony No. 4 in E minor")
* SUBTITLE - the subtitle of the work (e.g., "Opus 98")

The problem with using a tagging app on a phone is that it's fairly
cumbersome, as are most editing tasks on a crippled "smart" device
with a tiny screen and no keyboard.  So I wrote some Ruby scripts
for Linux that make it easier to add tags to music files before
they are transferred to the "smart" device.  The idea
behind these scripts was to use an album descriptor in plain text
that is easy to edit (using one's favorite editor).  Then run a script
to apply the tags specified in the album descriptor to a set of music files
at one go.  These are tools that only a long-time Unix/Linux command line user
could love, but I find that they save me a tremendous amount
of time and aggravation.

The scripts are `oggalbum` (which writes tags to music files) and
`oggmakealbum` (which reads tags from music files).  You can
find them in my Github mirror repository [here](https://github.com/bloovis/scripts.mirror),
along with some brief instructions in the README.
