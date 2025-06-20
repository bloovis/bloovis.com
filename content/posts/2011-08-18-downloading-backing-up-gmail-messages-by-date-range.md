---
title: Downloading / backing up Gmail messages by date range
date: '2011-08-18 16:04:01 +0000'

tags:
- gmail
- linux
- linux mint
- software
- ubuntu
---

I currently use fetchmail to download my Gmail email via POP3 to my
laptop, where I read it with a text-mode email client called
[sup](http://sup.rubyforge.org/).  But for a couple of months back in
2009, I was in the middle of a cross-country move and temporarily
switched to using the Gmail web UI.  Then when I switched back to
using fetchmail, it wasn't able to read those two months' worth of
email, which remained missing until today.

To get back the missing messages, I first used the Gmail web UI to
label those messages.  I knew that I was missing email that had
arrived between July 9, 2009 and Aug 29, 2009.  So I did a search in
Gmail for `after:2009/7/9 before:8/29/2009`.  Then I clicked on
the "select all" checkbox, and when Gmail asked me if I wanted to
select all 1700 messages in the search results, I said yes.  Then I
tagged those messages with the "missing" label.

Back on the laptop, I installed mutt, another text-mode email client
that I used for many years, and which has excellent IMAP support.  I
created a `~/.muttrc` file that looked like this:

```
mbox_type=Maildir
set from = "myusername@gmail.com"
set realname = "My Name"
set imap_user = "myusername@gmail.com"
set imap_pass = "mypassword"
set folder = "imaps://imap.gmail.com:993"
set spoolfile = "+INBOX"
set postponed ="+[Gmail]/Drafts"
set trash = "imaps://imap.gmail.com/[Gmail]/Trash"
```

I created a maildir to store the missing messages:

```
maildirmake ~/Maildir/missing
```

Finally, I started mutt.  It showed my Gmail inbox, so I told it to
switch to the "missing" pseudo-folder by typing `c=missing`.  I
tagged all the messages in that folder using `T.`, then saved
them all to the newly created Maildir folder using
`;s~/Maildir/missing`.  It took several minutes to download
many megabytes of email.  After that was done, I now had a
fully-populated mail directory containing all the missing messages.
