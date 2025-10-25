---
title: Replacing Joplin with Fossil
date: '2025-10-21'
comments: true
tags:
- linux
- software
---

For a couple of years, I've been using the note-taking app [Joplin](https://joplinapp.org/),
and hosting my own WebDAV-based Joplin server.  It's a handy way to keep notes in sync
on both Linux and Android.  But some recent annoyances have led me to replace Joplin
with a [Fossil](https://fossil-scm.org/home/doc/trunk/www/index.wiki) repository.

<!--more-->

## Annoyances

The biggest annoyance with Joplin happened a few weeks ago, when I updated the app on
a Linux machine, and it told me that my encryption key was obsolete and needed
to be replaced.  The Joplin web site has information about how to do the conversion
to a new key, but it didn't go smoothly.  I ended up with an obsolete, disabled
key that I can't seem to delete, and some notes that Joplin refuses to encrypt,
no matter how many times I told it to retry.

Then I started using the [Niri compositor](https://github.com/YaLTeR/niri?tab=readme-ov-file)
(on Fedora 42 KDE Wayland), and discovered that even though Joplin does load correctly, the
dialog boxes initiated from the File menu (such as Export) don't appear.

There are other, smaller annoyances:

* The app on Linux is gigantic (148 MB) and takes several seconds to load.
* You need two passwords, not one: a master password, and a password for your encryption key.  I wasted
a lot of time installing Joplin on a second laptop because I had the two passwords mixed up.

## Moving to Fossil

I finally realized that I could replace my Joplin notes with a Fossil repository
containing all of the notes, which are just Markdown files.  Then I could place
the repository on my server (after making it private), clone the repository
on all my laptops, and use `fossil ui` to view the notes in a browser.

First, I exported the notes from Joplin as a JEX file, which is simply
a tar file contaning the notes.  After extracting the files, which all
have obscured filenames using long hex IDs, I wrote a simple script
to massage the files slightly and rename them.  The script examines
the first line, which Joplin uses as a title, and constructs
a filename and a Markdown header line using that line.  Then it outputs 
the remainder of the file, stopping at the line starting with "id:", which
is the start of Joplin metadata.  Here's the script:

```ruby {filename="fixjoplin.rb"}
#!/usr/bin/env ruby

ARGV.each do |filename|
  outfile = nil
  newfn = ""
  keep_going = true
  File.open(filename) do |f|
    f.each do |l|
      line = l.chomp
      if line =~ /^id: /
        keep_going = false
      elsif keep_going
        if outfile
          outfile.puts line
        else
          newfn = line.split.map {|x| x.downcase}.join("-") + ".md"
          outfile = File.open(newfn, "w")
          outfile.puts "# " + line
        end
      end
    end
  end
  outfile.close
  puts "Wrote #{newfn}"
end
```

Then I wrote a simple script to create an index file from a list of
Markdown files specified on the command line:

```ruby {filename="makeindex.rb"}
#!/usr/bin/env ruby

puts "# Index", ""
ARGV.each do |filename|
  File.open(filename) do |f|
    line = f.gets.chomp
    if line =~ /#\s*(.*)/
      name = $1
      puts "* [#{name}](#{filename})"
    else
      puts "* [#{filename}](#{filename})"
    end
  end
end
```

Using these scripts, and creating the appropriate directory hierarchy, I was
able to create a Fossil repository that approximated what the notes
looked like in Joplin.  I made the repository private and copied it to
my server.

## Search

Joplin has a handy search feature.  You can enable a search feature in your Fossil
repository, though it will have to be done on each local copy of the repository.
Run `fossil ui`, and in the Admin / Configuration section, add a line to main menu that looks
like this:

```
Search    /search      *              {}
```

Then in Admin / Search, add `*.md` to the Document Glob List, and check
the box next to Search Document.  Now when you visit the Home page,
you should see a Search menu option (you may have to reload the page
to see it).

## Android

But what about Android?  How can you possibly live without the Joplin app?

It turns out that you can do everything in [Termux](https://wiki.termux.com/wiki/Main_Page)
that you can on Linux.  First, you can install Fossil using:

```
pkg install fossil
```

Then you can clone any of your remote Fossil repositories.  But you have
to be careful with identifying yourself via ssh.  You
should already have a working ssh setup that lets you access remote machines from
Termux without a password.  I wrote about this in an [earlier post](/posts/2025-09-30-termux-ssh/).
Once that's working, you can clone a remote Fossil repository, but you have to
make sure that you insert the correct user name in the ssh URL, e.g.:

```
fossil clone ssh://joeuser@example.com/fossils/mynotes.fossil
cd mynotes
```

Then can you can use `fossil ui` in your working directory to view it
in whatever browser you have installed on your Android devices.  To make
this a little easier, in my remote repository I changed the Index Page
pathname in the Configuration page to `/doc/trunk/index.md`.  This assumes
that there is file called `index.md` in the root directory of the
repository.

## Conclusion

The result is that I no longer depend on a large, separate app to
synchronize notes between machines.  Instead I can use familiar tools that I'm
already using on a daily basis.  While the setup is a bit more
complicated than using Joplin alone, it does allow me to track changes
to my notes, view diffs, and do other source code management tasks
that Joplin can't do.
