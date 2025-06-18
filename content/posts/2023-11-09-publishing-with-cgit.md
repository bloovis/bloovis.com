---
title: Publishing source code with Cgit
date: '2023-11-09 08:59:00 +0000'

tags:
- linux
- software
---

As part of my continuing work to free myself from Big Tech, I recently
moved most of my source code repositories from Gitlab to Cgit on
my own server.  There's nothing particularly wrong with services like
Gitlab or Github, but they are far more powerful than I need.  My
source code projects are a one-man show; virtually nobody else
is interested in them.  So I don't need all of the fancy collaboration
tools offered by the big Git sites.

The thing that triggered the move was the difficulty I had in logging
into Gitlab after several months away.  Apparently, the user interface
had changed radically in that period, and my attempts to log in
constantly ran into barriers.  At first, all login attempts led to
an annoying "About" page instead of my account.  Eventually I was able
to log in somehow using a cell phone as a second factor authenticator.
Then I discovered the UI changes and, thankfully, found a way to restore
the "old" UI.  This process was so annoying and so time-wasting that
I vowed to abandon Gitlab and free myself from future unexpected annoyances.

As for Github, I had used that until Microsoft bought it.  It's been my experience that
Microsoft eventually turns everything they acquire into crap.  Apparently, they've already
started doing this with Github by abandoning Github's IDE in favor of their own
(I don't use IDEs so this means nothing to me).  They did the same thing
when they bought Hotmail: replaced a reliable service hosted on BSD with
something that ran on Windows Server.

So then the question was: how to host a Git service on my own site?
The Gitlab service has an open source offering, but it's so huge and unnecessarily
feature-rich that it would be ridiculous to try to get it to work on my
tiny server, which has only 1GB of RAM and 25GB of disk storage.
I found a few other candidates, like Gitea, but they still suffered
from feature bloat.

Finally, I decided to install
[Cgit](https://git.zx2c4.com/cgit/about/).  It's fast and small, being
written in C, provides a simple but effective web interface, and has
just enough features for my use.  There's a package in Ubuntu 22.04
that integrates it into Apache, so installation is trivial.  What's
left to do after installation is to tell Cgit something about your code
repositories.

The first thing to do is make sure you have password-free SSH access
to the account on your server where you're going to store the
repositories.  Setting this up involves creating public and private
keys, and copying the public key to your server.  There are
plenty of guides on the internet describing this process.

For an existing project on your local machine,
you need to make a so-called "bare repository" on your server.
I used a possibly stupid method that works for me.  First, create
a local bare copy of the repository.  Supposing that your code
is in the subdirectory `myapp`, the following command creates
a bare repository that has all of the code but no working directory:

    git clone --bare myapp myapp.git

Copy this bare repository to your server.  In this example,
the parent directory for all of your repositories is `~/repos`:

    scp -r myapp.git joeuser@git.example.com:repos

Now it's time to add some things to Cgit's configuration file `/etc/cgitrc`,
to tell it about your repositories.

Set `root-title` to a brief description:

    root-title=example.com git repositories

Set `root-desc` to a longer description:

    root-desc=Personal open source projects

Enable Cgit to serve your repositories via HTTP for use by others:

    enable-http-clone=1

Tell Cgit to provide clone URLs on its web interface: one via
http for use by others, and one via SSH for your use only.
Note that I've divided this line into multiple lines for readability, but
it should be placed on a single line:

    clone-url=https://git.example.com/cgit/$CGIT_REPO_URL
      ssh://joeuser@git.example.com/home/marka/repos/$CGIT_REPO_URL.git

Tell Cgit about the various mime-types it should use for files
in your repositories:

    mimetype.gif=image/gif
    mimetype.html=text/html
    mimetype.jpg=image/jpeg
    mimetype.jpeg=image/jpeg
    mimetype.pdf=application/pdf
    mimetype.png=image/png
    mimetype.svg=image/svg+xml

Tell Cgit to use fancy source code highlighting:

    source-filter=/usr/lib/cgit/filters/syntax-highlighting.py

Tell Cgit how to process README files in various formats, like Markdown:

    about-filter=/usr/lib/cgit/filters/about-formatting.sh

Set one or more instances of `readme` to specify the file patterns for
the README files that you use in your repositories:

    readme=:README.md
    readme=:readme.md

Now it's time to tell Cgit about your repositories.  These can be organized
in sections; see the Cgit documentation for information about this.
Here's a sample repo description:

    repo.url=myapp
    repo.path=/home/joeuser/repos/myapp.git
    repo.desc=My super-wonderful APP for doing marvelous things
    repo.owner=joeuser@example.com

Finally, restart Cgit by restarting Apache:

    systemctl restart apache2

Your repositories should now be visible at <https://cgit.example.com/cgit/>
You can try cloning your newly created remote repository using this:

    mv myapp myapp.old
    git clone ssh://joeuser@git.example.com/home/joeuser/repos/myapp.git

You should also be able to push changes to the remote repository.
