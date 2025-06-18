---
title: How to avoid Twitter and Reddit URL censorship
date: '2023-04-08 07:37:00'
draft: false
tags:
- covid19
---

(Sarcasm is *OFF* for this post.)

For at least the entire three years of the scamdemic, and possible longer than that,
Reddit has been censoring URLs for web sites that they don't like, such
as Bitchute and Rumble.  A sysadmin for a Covid dissenters' Reddit group that I belong to
created a workaround for this: a Javascript program on their own personal
web site that redirected obfuscated "naughty" URLs to their actual destinations.
This redirection service allowed us to avoided Reddit's censorship bots.

For fun, I re-engineered this redirection service as a CGI script written in Perl,
and enhanced it with a form that allowed the user to enter a URL and
get back its obfuscated form.  Up until now, I did not offer this
script publicly.

Recently, it was discovered the Twitter is doing a kind of
[censorship on Substack URLs](https://boriquagato.substack.com/p/bluebird-bans-are-back).
Instead of simply not allow Substack URLs to be posted, as Reddit
might have done, Twitter is a little sneakier: it prevents tweets containing
Substack URLs from being "liked" or responded to with comments.

In light of this new development, I updated my redirection CGI script to deal with
the Twitter problem.  It's a bit more complicated than dealing with, say,
Bitchute URLs, because Substack URLs can have a subdomain part
before the "substack.com" part, and more than just a simple ID after the "substack.com"
part.

In order to use this CGI script, you'll need to have your own
web site that supports CGI (obviously).  You can find the script
[here](https://gitlab.com/bloovis/scripts/-/blob/master/redirect.cgi).
If you install this script on your web site, you'll need to change
the `$site` variable to reflect your actual site URL.  Unfortunately,
or perhaps fortunately, I do not have a Twitter account, so I don't
have a way of testing this script there.  But the redirection does
seem to work correctly outside of Twitter.

