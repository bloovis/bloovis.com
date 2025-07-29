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

### DNS

An DNS MX record is needed to tell the world which server I use to receive mail.
Here's the relevant record:

| Name | Type | Data |
|------|------|------|
| example.com | MX | 10 mail.example.com |

### Postfix

Postfix has IP address filtering mechanism using `mynetworks`.  I used this to tell Postfix
to accept mail only from IP addresses used by pobox.com.  In `/etc/postfix/main.cf`, I 
added the following line:

```
mynetworks = 127.0.0.0/8, 198.55.239.67, 64.147.108.0/24, 173.228.157.0/24, 103.168.172.192/26, 202.12.124.192/26
```

Here is the entirety of my `/etc/postfix/main.cf`:

```
myhostname = mail.example.com
mynetworks = 127.0.0.0/8, 198.55.239.67, 64.147.108.0/24, 173.228.157.0/24, 103.168.172.192/26, 202.12.124.192/26
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
```

I verified that the `mynetworks` filter works, by attempting to connect to Postfix
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

```
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
```
