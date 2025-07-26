---
title: Blocking Koha Attacks With iptables
date: '2024-04-05 07:53:00 +0000'
tags:
- linux
- software
- koha
- apache
---

Our library's [Koha](https://koha-community.org/) installation has been subject to unfriendly attacks by
servers in China that are apparently associated with Alibaba.  The symptom
is that Koha becomes very slow, and the `top` command on the server
shows that Koha is using 100% of all CPUs.
<!--more-->

{{< callout type="warning" >}}
I now use [Anubis](/posts/2025-07-11-anubis-koha/) instead of iptables to block bot attacks.
{{< /callout >}}

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

*Update 2025-07-14*: It's also possible to block ranges of IP addresses
using [ipset](https://www.linuxjournal.com/content/advanced-firewall-configurations-ipset).
As an example, the IP address of one of the bots hitting Koha
was 47.235.144.217.  I then did a `whois 47.235.144.217` and found that
this machine was in the Alibaba Cloud:

```
...
NetRange:       47.235.0.0 - 47.246.255.255
CIDR:           47.246.0.0/16, 47.240.0.0/14, 47.244.0.0/15, 47.236.0.0/14, 47.235.0.0/16
NetName:        AL-3
NetHandle:      NET-47-235-0-0-1
Parent:         NET47 (NET-47-0-0-0-0)
NetType:        Direct Allocation
OriginAS:       
Organization:   Alibaba Cloud LLC (AL-3)
RegDate:        2016-04-15
Updated:        2017-04-26
Ref:            https://rdap.arin.net/registry/ip/47.235.0.0
...
```

I then used the CIDR information to create an ipset called "badnets" that blocked those
IP addresses:

```bash
ipset create badnets hash:net
ipset add badnets 47.246.0.0/16
ipset add badnets 47.240.0.0/14
ipset add badnets 47.244.0.0/15
ipset add badnets 47.236.0.0/14
ipset add badnets 47.235.0.0/16
```

I tested that the IP address 47.235.144.217 was in the badnets ipset:

```
% ipset test badnets 47.235.144.217
47.235.144.217 is in set badnets.
```

I added badnets to iptables to block those addresses:

```bash
iptables -I INPUT -m set --match-set badnets src -j DROP
```

I had iptables list all of its rules to verity that badnets
was present:

```
% iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       all  --  anywhere             anywhere             match-set badnets src
...
```
