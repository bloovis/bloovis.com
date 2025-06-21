---
title: "Postfix + Maildrop = Failure"
date: '2023-10-03 11:41:00 +0000'

tags:
- linux
- software
- notmuch
---

I've spent most of the last two days struggling to get first [chasquid](https://blitiri.com.ar/p/chasquid/)
(a minimalist SMTP server) and then [postfix](https://www.postfix.org/) (the ubiquitious SMTP
server preinstalled on my Ubuntu VPS) to work with
[maildrop](https://www.courier-mta.org/maildrop/) (a mail delivery agent).  The reason I
was attempting to do this was so that I could have maildrop pass
emails to [notmuch-insert](https://notmuchmail.org/doc/latest/man1/notmuch-insert.html).
I use [notmuch](https://notmuchmail.org/) as my mail store, and I
thought that it would be more efficient to have notmuch-insert process
emails as they come in, instead of having [notmuch-new](https://notmuchmail.org/doc/latest/man1/notmuch-new.html) process them in a big
batch.

This idea seemed plausible, since
I have something similar working using [fetchmail](https://www.fetchmail.info/)
to retrieve mails: fetchmail passes the emails to notmuch-insert directly.  This works
fine because all of these programs run as my normal login user.
Before I started using notmuch, I had fetchmail invoke maildrop
to store the email directly in a maildir, and that also worked.

But now, my attempt to run my own mail server (postfix) and have it
invoke maildrop and then notmuch-insert has proven to be a frustrating
failure.  The reason for the failure with postfix is that it runs as
root, and when it passes a message on to maildrop to do the delivery,
maildrop has to change its user ID to that of the user receiving the
email.  This seems to work fine.  But then maildrop attempts to
connect with the [Courier authentication daemon](https://www.courier-mta.org/authlib/README_authlib.html),
called authdaemon, and that fails with a permission denied error.

I was able to verify this problem manually by running
maildrop as my normal user:

    % maildrop -d marka
    ERR: authdaemon: s_connect() failed: Permission denied

This error does not occur if maildrop is run from a root account.

A similar issue occured when I tried to use chasquid instead of postfix.
The problem there is even worse, because chasquid does not run as root,
so it's not even able to start maildrop as root.

So clearly, there is some sort of permission problem that prevents the
use of authdaemon by ordinary users.  A search of the vast wisdom of
the internet proved useless after a number of failed attempts at
solving the problem.  One forum post suggested using chmod to make
maildrop setuid-root.  I tried this with chasquid, and then maildrop
claimed that it was being run by an untrusted program.

It's possible that some genius out there on the internet has figured
out how to get postfix to work with maildrop (yes, I'm aware of
the [postfix-maildrop README](https://www.postfix.org/MAILDROP_README.html),
and it didn't help).  In the meantime,
I've resorted to letting postfix deliver emails directly to my
maildir by removing all of postfix's maildrop configuration options,
and instead using something like this line in `/etc/postfix/main.cf`:

    home_mailbox = mail/inbox.2023/

Then `notmuch new` finds the new emails there and processes them.

