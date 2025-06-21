---
title: Hunter Biden Emails
date: '2022-05-17 13:15:00 +0000'

tags:
- biden
- ukraine
- software
- notmuch
---

Now that the [Hunter Biden emails](http://www.bidenlaptopemails.com/)
from the famous laptop are available,
it's possible to download them to one's own computer and examine them
at leisure, without using the very overloaded site, and without requiring
a network connection.  I accomplished this using the mail indexer
[notmuch](https://notmuchmail.org/),
and my own fork of the [sup email client](https://github.com/bloovis/sup-notmuch.mirror)
that uses notmuch as a backend.

<!--more-->

First, download the zip file containing the Windows flavor of all the emails
[here](https://bidenlaptopemails.com/biden-emails/emls.zip).

Create a mail directory for storing the emails, using a command like this:

    maildirmake bidenemails

This will create three subdirectories below `bidenemails`: `new`, `cur`, and `tmp`.

(The `maildirmake` command can be found in several packages in Linux Mint; I chose
the `maildrop` package.)

Move to the `new` subdirectory of `bidenemails` and unpack the zip file:

    cd bidenemails/new
    unzip ~/emls.zip

This will put all 128K emails in a single directory.  I chose to create
separate maildirs for each year, but that isn't necessary.

Many of the emails will have a bogus first line starting with the
bytes FF FE (the Unicode Byte Order Mark), followed
by a decimal number.  This will cause notmuch to ignore those emails,
so it's necessary to remove the offending lines.  The following shell
script will do the job:

```bash
#!/bin/sh
if [ $# -eq 0 ]
then
  echo usage $0 files ...
  exit 1
fi
for file in "$@" ; do
  if head -1 "$file" | hd | grep -q " ff fe " ; then
    echo "fixing $file"
    sed -i '1d' "$file"
  fi
done
```

Now it's time to configure notmuch.  Run the command `notmuch setup`.
Give it the full path to the maildir you created before (`/home/SOMEBODY/bidenemails`
in the example above).  This will create a configuration file `~/.notmuch-config`.
Edit this file and make the following changes:

* Change the `ignore` definition to the empty string.
* Change the `synchronize_flags` definition to false.

Now tell notmuch to index all of the emails for the first time,
using this command:

    notmuch new

This took 12 minutes on a seven year old laptop with an SSD.  It will probably take
longer on a mechanical hard disk.

You can test that things worked by doing a few queries.  For example, the following
command will find the email where Hunter bragged that he was taking over Ukraine:

    notmuch search '"taking over ukraine"'

This will produce output like the following:

    thread:000000000000990e   2014-05-30 [4/6] Timothy Stanton; Golf (inbox starred)

Display that thread using the following command:

    notmuch show thread:000000000000990e | less

Scroll down a bit and you'll see the part in question:

    On Mon, May 19, 2014 at 2:28 PM, Hunter Biden <hbiden@rosemontseneca.com>wrote:

    > That's for people who have time to do such things. Me - I'm busy taking
    > over Ukraine.
    >
    > RHB
    > 202.333.1880

While notmuch is certainly powerful, it will probably be more convenient to
use an email client to view the emails.  Earlier I mentioned that I
was using a notmuch-enabled version of the sup email client.  Setup
for sup is rather involved, so I won't repeat the instructions here; see the
README [here](https://github.com/bloovis/sup-notmuch.mirror).

As an experiment, I also tried using the neomutt mail client, which has
support for notmuch.  But it was not usable with the large Biden email
set.  It took several minutes to read every email when it started, and
when it exited, it tried to modify every email, a process that took so
long that I had to abort it with `killall neomutt`.  The advantage of sup
is that it starts quickly and doesn't modify the emails.
