---
title: Blocking Koha Attacks
date: '2024-04-05 07:53:00 +0000'
tags:
- linux
- software
- koha
---

Our library's [Koha](https://koha-community.org/) installation has been subject to unfriendly attacks by
servers in China that are apparently associated with alibaba.  The symptom
is that Koha becomes very slow, and the `top` command on the server
shows that Koha is using 100% of all CPUs.
<!--more-->

Examining the Apache log using `tail -f /var/log/apache2/other_vhosts_access.log`
shows the culprit.  There are many lines like the following (line wrapped
and shortened for clarity):

```
koha.ourlibrary.com:443 47.76.209.138 - - [05/Apr/2024:07:51:33 -0400]
  "HEAD /cgi-bin/koha/opac-search.pl?count=20&limit=ccode%3AA [...]
  "-" "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 
  (KHTML, like Gecko) Chrome/66.0.3197.46 Safari/537.36"
```

Note that the requester identifies as browser, not as a web crawler.  It also
ignores the `robots.txt` that I've installed for our Koha instance.

Running `dig -x` on the attacker's IP address says this (abbreviated and wrapped
for simplicity):

```
76.47.in-addr.arpa.	270	IN	SOA
  rdns1.alidns.com. dnsmgr.alibaba-inc.com.
  2015011307 1800 600 1814400 300
```

My temporary solution is to block the requester's IP address:

```
iptables -A INPUT -s 47.76.209.138 -j DROP
```

I had to do this for two different IP addresses today.  There is probably a better
way to do this, perhaps specifying a range of IP addresses, or using some kind
of throttling module for Apache2.  But this hack works for now.
