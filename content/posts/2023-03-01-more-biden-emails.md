---
title: More on the Hunter Biden Emails
date: '2023-03-01 20:40:00 +0000'

tags:
- biden
- ukraine
- software
- notmuch
---

Earlier I described a [procedure for importing the Hunter Biden emails](/posts/2022-05-17-biden-emails/)
into [Notmuch](https://notmuchmail.org/), an excellent email search engine.  Now that I've been
playing around with these emails for a while, I wanted to share some
random thoughts and ideas about them.  Nothing I'm going to write here
is a bombshell; all of the juiciest tidbits have been reported by
various news sites.

<!--more-->

### Mail client

Notmuch can be used as a standalone application for searching and displaying
emails, but the command line user interface is not terribly convenient.
There are several [email clients](https://notmuchmail.org/frontends/)
that use Notmuch as a backend.  I have tried two of the clients listed there:

* Neomutt.  Although I was a Mutt user for many years, the Notmuch
interface in Neomutt is not usable.  With large quantities of email, it's incredibly slow --
so slow that I had to abort it from another terminal window.
That is surprising, given that Notmuch is so fast.  Apparently, Neomutt is
gathering huge lists of emails simply to display the inbox, instead of limited
the search to the number of emails that will fit on a screen.  At least, that's
my best guess about why it's so slow.

* [Astroid](https://github.com/astroidmail/astroid).  I tried this several years ago, and it seemed a bit rough then,
but it was quite usable when it wasn't crashing.  I suspect the current version
is stable, but I haven't tried it.

I eventually decided to use my own [Notmuch-enabled version of Sup](https://gitlab.com/bloovis/sup-notmuch).
I had used the original version of Sup for nearly a decade and liked it quite a bit;
it used Xapian directly as its mail search engine, but occasionally it would crash and leave the search
index in a corrupted state.  I took a version of Sup that another developer
had enhanced to use Notmuch instead of Xapian, and hacked it into a more
stable state.  I've used this hacked version of Sup for my own emails
for several years now, and now also use it for examining the Hunter Biden
emails.

### Attachments

One of the disappointing things about the Hunter Biden email dump is that
it is missing attachments.  This is unfortunate, because some of the emails
had PDF attachments that consisted of contracts between Hunter and Burisma, and those would be very
interesting to look at.

### Joe Biden's aliases

The "Big Guy", Joe Biden himself, appears in these emails using three email
addresses:

* robinware456@gmail.com
* Robert.L.Peters@pci.gov
* 67stingray@gmx.com

### Hunter is a cheapskate

I know it's going to come as a shock to many, but Hunter is a mean-spirited cheapskate who
doesn't like to pay his bills or his employees, and who writes bouncy checks.  Here is an email from
his long-suffering assistant, Katie Dodge, dated December 28, 2018, with
the subject "Please respond":

> Hello - I am trying to figure out what to do about bills/BD & BHR travel etc.  Would you be able to let me
> know how you plan to proceed with things?  Below is a list of items that have come up or we have discussed.
> No particular order …
> 
> 1) Signing the BHR loan? - sent to you by Eric and forwarded to you by me - he also is asking about the BD
> buyout.  Should I start by contacting George?
> 
> 2) UPenn tuition payment due Jan 4 - $27,945
> 
> 3) Sidwell Payment due Jan 5 - $4,244.70
> 
> 4) Health Insurance is past due - $5841.45 would make it current
> 
> 5) KBB - Monthly payment due and She has asked you to sign a doc for her refi of the lake house. Email was
> sent to you around Dec 14 re:refi possibly sent by her attorney.
> 
> 6) Your storage unit check was returned.  It costs $780/month.  It will cost $4,975 to move all the stuff to
> Delaware.  Due now is just the $780. They have called me about this.
> 
> 7) Pay day is today (Friday, Dec 30).  Not sure how to handle that.  ADP is is looking for $22,500 to restart
> with them.  Total bi-weekly is $4k (you) +$3k (me) +$1k (Erin) = $8k total :: Benefit of ADP is they do all
> the state & Fed taxes and issue W2s etc.  Also - Health Insurance uses tax compliance from payroll as part of
> the verification that the company exists/legit.
> 
> 8) Porsche payment was due and was returned by Wells Fargo — ( Not sure if you have responded officially to
> Edward about closing accounts.)  The Porche payment was about $1,700.

Note that Dodge is also concerned about how she is going to be paid (item 7).

Here is Hunter's response:

> Pay the health care. Pay the Porsche.
>  Pay yourself 1500 not 3000. Im sorry if there was a misunderstanding but I clearly don’t remember saying not
> so I think you could believe that I have the capacity to pay you a $72,000 a year salary for part time work
> with no hours and no Responsibilities beyond responding to my mail and paying my bills. Of which you rarely
> do anything but tell me I need to figure out what’s in my inbox and do what I had hoped you could do that
> Joan did that Eric did that you won’t.  I’M not using ADP for a $22000 down payment so you can have your
> taxes taken out.  If you haven’t noticed Katie my business partner is now a prisoner on death row in China.
> Somehow the directive of not cutting Devon half my Burisma pay never happened I pay more alimony than single
> divorce in the east coast including NYC. You pay more alimony just b/c I told her I would give her everything
> than Ron Perlman who is worth 6 billion dollars. So there’s not much income coming through these days.
> 
> Ive told Eric 10 times to talk to George. Eric is  not agreeing to my terms and pretending like I’m not being
> responsive. Please email him George and me that George knows my position and that Eric should talk to him.
> Also tell Eric that is asked that he please pay me 30-% of any business debt including the Wells Fargo
> business card- whatever the balance was the day I fired him. And please discontinue the autopay to Amex he
> somehow put into my Wells Fargo account.  And I also am positive I signed  esigned and returned loan doc to
> BHR directly. Please ensign it - I have the text to you that says yes I sign.  FYI Eric has zero equity in
> any single thing related to me. Not BD not BHR nothing.
> 
> I am fully aware of what Kathleen wants.
> 
> I’ll deal with tuitions when time comes.
> 
> In order for me to close the WF brokerage accounts you need to move all autopsy’s to whatever new account
> best option would be for you to move them to one of my Bank or America checking accounts.  I thought that was
> made clear in the email Edward sent us both. All brokerage accounts can then be closed and the Maisy account
> should be closed and the check sent to the CA address ASAP.
> Today is the 28th not the 30th. Payday is the first and 15th.

Some things to note about Hunter's response:

* He claims he's too strapped for cash to pay Dodge her expected salary; he gaslights
her about their salary agreement; and he accuses her of laziness.  So he cuts her salary in half, but
apparently he is OK with paying himself almost three times as much.

* He seems to be getting all of his
income from Burisma, and he complains that it's not enough for his expenses.

* He whines about his business partner being on death row in China; this is a reference
to Ye Jianming.

* Kathleen (KBB, nee Buhle) is his estranged wife; Maisy is his daughter.

* Because I'm a terrible person, I am amused by Hunter's use of auto-correction
(autopay -> autopsy, esign -> ensign), and also by his use of apostrophes
(missing in "im", wrong in making a plural of "autopsy").

You'll find more tidbits like this if you search for all of Dodge's emails.  You'll
also find messages from Kathleen about missed alimony payments.

### Junk emails

Hunter was subscribed to a bunch of mailing lists: some from news sites, others from
places where he bought stuff.  These are mostly annoying clutter and can be deleted
(actually just labelled "deleted" so that Sup doesn't display them by default),
using a command like the following:

    notmuch tag +deleted -- from:email.bloomberg.com

### Ukraine

As expected, there are numerous emails about Ukraine.  It's not easy
to get the entire picture of Hunter's involvement with that bastion of
~~money laundering~~ freedom just from these emails.  The overall
impression is that he was involved with Ukrainian companies
(especially Burisma) and wealthy and/or powerful Ukrainians, without
actually doing any real work for them.  Instead, he seems to be a
channel for Ukrainians (e.g., Vadym Pozharskyi) to get access to
powerful and influential people in the United States.

### Metabiota

There are a number of emails concerning Metabiota, a company that supposedly
"compiles data from around the world to predict disease outbreaks".  A few emails
mention Ebola.  They appear to be heavily involved with Ukraine, but it's not clear from the emails
exactly what this involvement looks like.  The emails in 2014 appear to
be related to Hunter investing in the company.

### Fact Checkers

If you try to do internet searches for things that you find in these emails,
inevitably you'll run into "fact check" articles in mainstream media
like the Washington Post.  The purpose of these "fact checks" is to convince
you that Hunter Biden is a totally honest guy and that his involvement
with various shady-sounding companies, characters, and countries was
totally legitimate and above-board.

But there are many other non-mainstream people scouring the internet for
information about the people mentioned in the emails.  It's a rabbit hole
that appears to be bottomless.
