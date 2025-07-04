---
title: Using Pobox.com with Postfix
date: '2023-10-07 14:44:00 +0000'

tags:
- linux
- software
- ubuntu
---

As part of my plan to reduce my dependence on Big Tech, I recently
made an effort to self-host an email server on Ubuntu 22.04 LTS.  This
is normally a [really terrible idea](https://cfenollosa.com/blog/after-self-hosting-my-email-for-twenty-three-years-i-have-thrown-in-the-towel-the-oligopoly-has-won.html),
for a number of reasons.  Receiving email is hard, but can be done with
spam filters and other security tools.  The much worse problem is related to *sending*
email.  As the linked article above says, it's just too easy for your server
to get on blacklists and then be blocked forever.

I have had an account on [pobox.com](https://www.pobox.com/) for over two decades.  This is a redirection
and spam filtering system.  It effectively lets you keep the same email
address forever, even if your email hosting service changes.  When your actual
email address changes, you simply inform pobox.com of the change, and it
redirects email to that new address.

But pobox.com doesn't provide email hosting (i.e., a place to store
your emails) with its basic plan.  In the past I've used several email
providers, including Gmail.  Gmail is super-popular,
but I don't trust Google and its lack of privacy, so for several years
I've used a [paid service in Norway](https://runbox.com/) that supposedly offers better privacy.

Then recently I decided to see if I could host my email on my own
server, using [Postfix](https://www.postfix.org/), thus saving a few dollars and gaining more control
over the process.  This didn't seem as crazy as the linked article
above would suggest, for the following reasons:

* I only need to receive mail for my pobox.com address, so I
allow only pobox.com's SMTP servers to connect to my Postfix server, and block
all others.

* I only need to send mail from my pobox.com address, so I
use [msmtp](https://marlam.de/msmtp/) instead of having Postfix be able to send to any and all possible
SMTP servers.

## Receiving email

I tried two methods for filtering incoming connections: SPF, and
Postfix's own IP address filtering.  Later, I discovered that
my fiddling with SPF was completely erroneous and unnecessary.  I left the SPF section in for posterity,
but you can skip it.


### SPF

The first requirement for receiving email with Postfix was to block
connections from servers that are not associated with pobox.com.
At first I used [SPF](https://en.wikipedia.org/wiki/Sender_Policy_Framework)
(Sender Policy Framework)
in my DNS setup to do this.  I queried the SPF
record for pobox.com to see how they did it:

    dig -t txt pobox.com

This returned a string that looked like this:

    "v=spf1 ip4:64.147.108.0/24 ip4:173.228.157.0/24 include:spf.messagingengine.com ?all"

This gives two ranges of IP addresses where their SMTP servers reside.  I verified
this by getting the addresses of their servers:

    dig -t mx pobox.com

Then I looked up a few of the results to see that they fell in the ranges described
in the SPF record, e.g.:

    dig pb-mx20.pobox.com

Then I was able to add my MX and SPF records to my DNS setup.  Here
is the MX record:

    example.com	MX	10 mail.example.com.

and here is the SPF record:

    example.com	TXT	"v=spf1 mx ip4:64.147.108.0/24 ip4:173.228.157.0/24 -all"

Add SPF processing to Postfix by installing the `postfix-policyd-spf-python`
package on Ubuntu/Mint.  Then add the following lines to `/etc/postfix/master.cf`:

    policy-spf  unix  -       n       n       -       -       spawn
         user=nobody argv=/usr/bin/policyd-spf

### Postfix IP address filtering

Eventually I discovered that I didn't need to use an SPF record, because
Postfix has its own filtering mechanism using `mynetworks`.  In `/etc/postfix/main.cf`, I 
added the following line:

    mynetworks = 127.0.0.0/8, 64.147.108.0/24, 173.228.157.0/24

This tells Postfix to accept only local connections, or connections from pobox.com.

Here is the entirety of my `/etc/postfix/main.cf`:

    myhostname = mail.example.com
    mynetworks = 127.0.0.0/8, 64.147.108.0/24, 173.228.157.0/24
    mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
    home_mailbox = mail/inbox.2023/
    compatibility_level = 3.6
    policy-spf_time_limit = 3600s
    smtpd_recipient_restrictions =
	 permit_sasl_authenticated
	 permit_mynetworks
	 reject_unauth_destination
	 check_policy_service unix:private/policy-spf
    smtpd_use_tls = yes
    smtpd_tls_security_level = encrypt
    smtpd_tls_eckey_file = /etc/letsencrypt/live/mail.example.com/privkey.pem
    smtpd_tls_eccert_file = /etc/letsencrypt/live/mail.example.com/fullchain.pem

I verified that the SPF policy checker in Postfix does work when `mynetworks`
doesn't have the appropriate IP address range filtering.  I also verified
that the `mynetworks` filter works, by attempting to connect to Postfix
from a home machine using msmtp.

In [another blog post](/posts/2023-10-03-postfix-maildrop-failure/),
I described the headaches I ran into trying
to get Postfix to pass emails to maildrop and notmuch-insert.  In the
end, I gave up and simply had Postfix deliver straight to a maildir,
as can be seen in the `home_mailbox` line above (it ends in a '/',
which tells Postfix that it's a maildir, not an mbox file).

## Sending email

This is much simpler than receiving email, because it doesn't involve
the use of Postfix at all.  Instead, because I use pobox.com for
sending email, I use msmtp from my email client.  Here is
what `~/.msmtprc` looks like:

    # Set default values for all following accounts.
    defaults
    tls on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    logfile ~/.msmtp.log

    # Pobox service
    account pobox
    host smtp.pobox.com
    port 587
    from usera@pobox.com
    auth on
    tls_starttls on
    user user@pobox.com
    password mypassword

    # Set a default account
    account default : pobox

