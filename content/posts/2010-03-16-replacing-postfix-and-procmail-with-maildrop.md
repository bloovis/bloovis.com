---
title: Replacing postfix and procmail with maildrop
date: '2010-03-16 12:16:51 +0000'

tags:
- linux
- linux mint
- software
- ubuntu
---
In the [previous post](/posts/2010-03-15-fixing-connection-refused-error-in-fetchmail-on-ubuntu-jaunty-linux-mint-7/), I wrote about how I solved a problem with fetchmail connecting to the postfix mail server.  I also have postfix configured to transfer mail to procmail, which does some filtering for me using some rules I've written in `~/.procmailrc`.  But postfix+procmail is really overkill for a laptop or any other machine that is not going to be used as a mail server.  Both of these programs can be replaced by maildrop, which delivers mail to your local mailbox or maildir, and which has a much more readable filtering language than procmail.

To get started with maildrop on Linux Mint or Ubuntu, install the maildrop and courier-authdaemon packages.  It's not strictly necessary, but for safety you can also disable postfix by doing this:

```
sudo service postfix stop
sudo chkconfig postfix off
```

Now you need to configure fetchmail to use maildrop.  Simply add the following line to your `~.fetchmailrc`:

```
mda "/usr/bin/maildrop"
```

The quotes aren't necessary; I had them there because I had been experimenting with passing options to maildrop.  The fetchmail man page recommends the options "-d %T", but these aren't required in this simple, single-user setup.

The next step is to write some mail filtering rules for maildrop.  These go into the file `~/.mailfilter`.  The mailfilter man page describes the filtering language, but doesn't give many examples.  Here's my `~/.mailfilter` (with a bogus address replacing a real one):

```
DEFAULT="$HOME/Maildir/inbox"
LINUS="$HOME/Maildir/linus"
WOTD="$HOME/Maildir/wotd"

logfile "$HOME/maildrop.log"

if (/^From:.*torvalds@linux\.com/)
{
  to $LINUS
}

if (/^From:.*word@m-w\.com/)
{
  to $WOTD
}

to $DEFAULT
```

In this example, I'm filtering mail to three different maildir directories; all messages that aren't caught by the two filters get delivered to the default maildir.  If these directories didn't already exist, they would need to be created with the maildirmake program.  maildrop also allows delivering mail to mbox files, but I consider mbox evil and don't use it any more.

Now whenever you run fetchmail, it should hand off the mail to maildrop for delivery.  Check the log file, `~/maildrop.log`, to make sure your filtering works as expected.
