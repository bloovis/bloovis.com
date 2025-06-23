---
title: Free music formats
date: '2008-02-23 05:26:28 +0000'

tags:
- ipod
- linux
- music
- ruby
- software
- treo
---

(*Update 2025*: I no longer use an iPod or a Treo, or rip CDs to FLAC.
Instead, I rip CDs directly to Ogg Vorbis.  See my
[scripts source repository](/fossil/home/marka/fossils/scripts/doc/trunk/README.md)
for more information.)

Playing music directly from CDs is, like, *so* last millennium.  I
don't even own a CD player any more, unless a laptop with a CD drive
counts.  I do all my listening now via a 4th-generation iPod and a
Treo 700p.

The problem is that most popular music file formats, particularly MP3,
are encumbered by patents.  The owners of these patents require
license fees if you use files in these formats for commercial
purposes, or make them available for downloading via the internet, or
copy them to a physical medium like a CD -- essentially, you have to
pay protection money for any purpose except private use in the home.

Because the legality of patented file formats is questionable for
Linux users, I decided to stop using these formats altogether.
Fortunately, there are free formats that work just fine:
[FLAC](https://github.com/xiph/flac) (a lossless format), and
[Ogg Vorbis](https://github.com/xiph/vorbis) (a lossy format conceptually similar
to MP3).  My fourth generation iPod didn't support these formats, but
replacing the iPod's firmware with [Rockbox](http://www.rockbox.org/)
fixed that problem.  The commercial [Pocket Tunes](http://www.pocket-tunes.com/) software for the Treo also plays
Ogg Vorbis files.

So now the interesting technical problem was to convert my CD
collection to digital files for use on the computer and my two
playback devices.  My first two attempts at this were failures because
I mistakenly chose to rip the CDs initially to Ogg Vorbis and MP3.
This was a mistake because these formats are lossy, and some audio
fidelity is lost in the conversion process.  I could hear the loss in
fidelity when comparing a CD of the Brahms First Symphony with an Ogg
Vorbis file created with -q3 (equivalent to MP3 at 128Kbps).  The
opening bars of this symphony are very thick, and the Vorbis file
sounded muddy compared with the CD.  Increasing the Ogg Vorbis quality
level to -q6 cleared up the muddiness, but I realized that I need to
start from scratch with the ripping process. 

Now my strategy is to first rip CDs to FLAC files.  FLAC is a lossless
format, so these files are, in essence, an exact copy of the music on
the CD.  FLAC is quite bulky, anywhere from three to six times the
size of an Ogg Vorbis -q6 file of the same recording.  But the FLAC
files only need to live on the ThinkPad, not on the iPod or the Treo.
When the ThinkPad disk fills up, I back up the FLAC files to an
external USB disk, then delete them from the ThinkPad disk.  I'm not
too worried about the lack of redundancy here because the CDs act as
the ultimate backup.

Once I have the FLAC files, I then transcode them to whatever lossy
format I need for playback, typically Ogg Vorbis.  As mentioned
earlier, I use quality level -q6 for this step, because I find it
produces results that, to my ears, are nearly indistinguishable from
the original CD.

The workflow for these steps (ripping, tagging, transcoding, syncing)
was not so easy at first.  I was using GUI tools like grip, but as
with nearly all GUIs, these tools required a large amount of manual
labor: filling out forms, clicking buttons, and so forth.  The problem
was particularly annoying when I had ripped several albums and wanted
to convert them all at once to Ogg Vorbis.

To make the process of ripping and tagging more automatic, I invented
an album description file format, and wrote some Ruby scripts that use
these "album files", as I call them.  Album files are simple text
files that contain the artist, album title, genre, date, and track
names.  Here's a hypothetical album file:

```
Artist=Brahms
Album=Piano Works - Radu Lupu
Genre=Classical
Date=1970
Rhapsody in B minor Op. 79 #1
Rhapsody in G minor Op. 79 #2
Intermezzo in E flat Op. 117 #1
...
```

The first step in ripping a CD is to create an album file for it.
There are several online databases of track information that can be
used; I use freedb.org.  The script
[cdmakealbum](/fossil/home/marka/fossils/scripts/file?name=cdmakealbum&ci=tip) reads the
track data from a CD, queries freedb.org for a matching record, and
writes a corresponding album file to standard output.  I usually
hand-edit the resulting album files to correct mistakes or to suit my
aesthetic and organizational preferences.

The second step is to rip the CD to FLAC files and tag them based on
the information in the album file.  The script
[ripalbum](/downloads/ripalbum) does this. It
keeps the files separate by using a two-level directory hierarchy
(artist name, album name).

The third step is to trancode the FLAC files to Ogg Vorbis. The script
[flac2ogg](/downloads/flac2ogg) recursively
walks the FLAC directory tree and creates Ogg Vorbis files in a
separate Ogg directory. The script is smart enough to skip files that
have already been converted.

The final step is to copy the converted Ogg Vorbis files to the iPod.
Because the iPod runs Rockbox, it's a simple matter of using rsync to
copy a directory on the laptop to a directory on the iPod.  The script
[syncipod](/downloads/syncipod) does this, after
first running `flac2ogg` (thus eliminating the need for the separate
transcoding step described in the previous paragraph).

While this might seem like an awful amount of work, it's actually
quite fast.  The lengthiest part of the process is hand-editing the
album files; once that's done, the scripts can run unattended.

Another advantage of the scripts is that some of them take an optional
parameter that tells them to pause when the CPU temperature exceeds a
certain level.  This prevents my flaky ThinkPad T40 from crashing when
it gets too hot (which it can do during the very CPU-intensive
transcoding process).
