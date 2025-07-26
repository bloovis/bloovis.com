---
title: Moving from Git to Fossil
date: '2025-05-08 09:45:00 +0000'
tags:
- linux
- software
- fossil
- git
- apache
---

This article describes the procedure I used to convert
my git repositories to [Fossil](https://fossil-scm.org/home/doc/trunk/www/index.wiki).
Git is a perfectly fine source code manager; it was designed for
large projects that have hundreds of contributors, like the Linux
kernel.  But for small projects git is a bit of overkill, and
there are number of things that I find annoying about it.
<!--more-->

1. The command line interface can be very confusing and counter-intuitive.
In fact, there's even a [git parody web site](https://git-man-page-generator.lokaltog.net/)
that generates random man pages that are just as obscure as the real thing.

2. The staging area adds extra complexity that I don't need.  I can understand why Linus would want
to use it for the kernel, because it allows cherry-picking of contributor
patches before a commit (among other things).  But for small projects
like mine, with no other contributors, it's an extra step that just
adds confusion.  The terminology is inconsistent, too: the staging
area is actually called an index, but if you want to do a diff between
what's in your work area and the index, you use `git diff --cached` instead
of `--index` like you'd expect.

3. Heaven help you if you try to undo something in git that was a mistake.
To address this, there are specialized web pages out there that cover
all the possible undo commands, and of course none is intuitive.
For example, to undo a `git add`, you would think something like `git remove` or
maybe `git subtract`, would make sense, but no: you have to do a `git reset`.

Fossil is, in my opinion, more suitable for small projects than git, and has
a number of attractive features:

* It consists of a single executable that implements everything you'd need: a command line
interface, a UI that lets you use a browser to examine repositories, and a server.
This replaces all of the equivalent git commands, the cgit server, and the gitk repository
browser.

* It supports other non-git features, e.g., a wiki and tickets.

* A repository consists of a single file (actually an SQLite file with
the extension `.fossil`), separate from a checked-out copy of the respository's files.
This means that a repository can easily moved around, and you can have multiple checkouts
of the same repository.

* Automatic syncing with a remote repository is enabled by default, so no need for an
easily forgotten extra "push" step.

* The user interface is well-designed and relatively easy to understand.

I already have a number of Git projects in local repositories.  These have remote
repositories on my own server, and mirrors on Github.  So there are several
steps in converting such a Git project into an equivalent Fossil project:

1. Import a Git project into Fossil
2. Copy the Fossil project to the server
3. Install Fossil as a server
4. Make a Github mirror

### Import a Git project into Fossil

It's helpful (but not necessary) to make a single directory
for storing your repository files.  In this example,
we create a directory `fossils` for this purpose.

    mkdir ~/fossils

Then move to the directory of the git project, and export
it.  Note that I used "master" instead of "--all" to prevent
problems later when pushing "ref" branches to Github:

    cd ~/gits/myproject
    git fast-export master | \
      fossil import --git --rename-master trunk ~/fossils/myproject.fossil

Move to the fossils directory, create a checkout directory,
and check out a copy of the project:

    cd ~/fossils
    mkdir myproject
    cd myproject
    fossil open ../myproject.fossil

For fun, run the UI to examine the project in a browser:

    fossil ui

Try clicking on the Timeline link and then clicking on a check-in number.
This should show you a diff for that check-in.  If your browser produces an error complaining
about an SQL injection attempt, try clearing the browser cookies for `localhost`
and reloading the page.

### Copy the Fossil project to the server

Take a look at the document
[How to Configure a Fossil Server](https://www3.fossil-scm.org/home/doc/trunk/www/server/),
and the **Repository Prep** section in particular.  At a minimum, you'll want make
some changes to your repository before uploading it.  Do this by running `fossil ui`
on your repository, and then making the following changes:

1. Change password for the Setup user (under Admin / Users).
2. Make the repository private (under Admin / Security Audit).
3. Change the Canonical Server URL (under Admin / Configuration).  It is probably
not obvious what this should be, so you can
postpone changing this until you have Fossil running as a server; see below.

If you do make a repository private, anonymous users will no longer be
able to log in.  To re-enable this capability later, set the following
privileges in Admin / Users:

* anonymous: hz (Hyperlinks + Download Zip)
* nobody: gjorz (Clone + Read Wiki + Check-Out + Read Ticket + Download Zip)

Log into the server as your normal user and create
a directory for storing repositories, as you did for your local machine.

    mkdir ~/fossils

On the local machine, copy the project repository file to the server:

    scp ~/fossils/myproject.fossil user@myserver.example.com:fossils

Back on the server, check out a copy of the uploaded repository and
examine it.  This will ensure that when you install the fossil server
later, it will be able to see this repository.  This is similar
to what you did earlier on the local machine:

    cd ~/fossils
    mkdir myproject
    cd myproject
    fossil open ../myproject.fossil
    fossil info
    fossil all info	# should show same thing as as fossil info

### Install Fossil as a server

I installed Fossil as a server behind an Apache reverse proxy on Ubuntu Server 22.04.
I used the reverse proxy to ensure that Fossil would
use SSL.  I had previously tried running Fossil without
the proxy, but there were two catches:

1. In order to use my server's certbot certificates, Fossil
needed to run as root.

2. But I wanted to run Fossil as my ordinary user, not root,
so that it would be restricted to my personal repositories,
and not have system-wide access.

So in order to use SSL *and* restrict Fossil to my personal
repositories, I needed a reverse proxy.

(*Note*: run all of the following commands as root.)

First, create the file `/etc/systemd/system/fossil.service` with
these contents, replacing USER with your actual user name, replacing
`example.com` with your actual server name, and replacing `/home/USER/fossils`
with the actual location of your repository files.

```
[Unit]
Description=Fossil user server
After=network-online.target

[Service]
WorkingDirectory=/home/USER/fossils
ExecStart=/usr/local/bin/fossil server --baseurl https://example.com/fossil/ /
Restart=always
RestartSec=
User=USER
Group=USER

[Install]
WantedBy=multi-user.target
```

Make the file executable using:

    chmod +x /etc/systemd/system/fossil.service

Start the fossil service and check its status:

    systemctl enable fossil
    systemctl daemon-reload
    systemctl start fossil
    systemctl status fossil

Enable the Apache proxy module if it is not already enabled:

    a2enmod proxy_http

Tell Apache how to redirect the URL `/fossil` from your base web site URL to
Fossil.  Do this by adding a single line to the `<VirtualHost *:443>`
section of your Apache site configuration.  If you used
Let's Encrypt to obtain your SSL certificates, this configuration file might be at
`/etc/apache2/sites-enabled/000-default-le-ssl.conf`.  The line you
need to add looks like this:

    ProxyPass /fossil/ http://127.0.0.1:8080/ upgrade=websocket

Restart Apache and check its status:

    systemctl restart apache2
    systemctl status apache2

If all went well, you should be able to visit the Fossil server by
going to this URL in a browser:

    https://www.example.com/fossil/

which should show you a list of your repositories.  This assumes you have
performed some actions on those repositories so that they'll show up when
you use the following command:

    fossil all info

From the [man page for fossil all](https://fossil-scm.org/home/help?cmd=all):

> Repositories are automatically added to the set of known repositories
> when one of the following commands are run against the repository:
> clone, info, pull, push, or sync. Even previously ignored repositories
> are added back to the list of repositories by these commands. 

### Make a Github Mirror

The [official Fossil document](https://fossil-scm.org/home/doc/trunk/www/mirrortogithub.md)
on how to make a Github mirror is good, but I did things slightly differently,
because I use ssh instead of https to update my Github projects, and because I use
a dedicated mirrors directory outside of my fossils directory.

Here's what I did to create a mirror for the `myproject` repository.
(I performed these actions on my server, but you could also perform
them on your local machine if you don't have a remote repository.)

On Github, create a blank Github repository `myproject.mirror`; the `.mirror` distinguishes
it from a normal repository that is updated from git.  Do **not** add a README
file or a license; you want an entirely empty project.

On your server, create a mirror directory (if it has not already
been created):

    mkdir ~/mirrors

In a Fossil checkout of `myproject`, run this command to create a git mirror
on your server (or local machine) *and* update the mirror on Github:

    fossil git export ~/mirrors/myproject --autopush \
      git@github.com:user/myproject.mirror.git

Note that I didn't specify a password; that's because Github has
my ssh key, allowing me to push changes to it without a password.

In the future, the `--autopush` option isn't necessary to update the mirrors;
simply do thi:

    fossil git export

Use this command to check on the status of the mirror:

    fossil git status

### Tweak your project

Now that you have your project on your server, it's time to go
back and fix the setting for its Canonical Server URL.  Visit the Fossil server in your
browser:

    https://www.example.com/fossil/

Then click on the project you just uploaded.  In Admin / Configuration,
take a look at the suggested value for Canonical Server URL.  Copy this
value into the entry field, and click on the Apply Changes button
at the bottom of the page.

Back on your local machine add the new remote repository to your local
repository, so that the two will always remain in sync:

    cd ~/fossils/myproject
    fossil remote ssh://example.com/fossils/myproject.fossil

Check that the remote connection is working:

    fossil update
