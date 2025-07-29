---
title: Comparing Linode and Digital Ocean
date: '2025-07-29'
tags:
- linux
- software
- apache
- ubuntu
---

On Sunday, Linode had a
[serious outage in their Newark data center](https://status.linode.com/incidents/6yw88b0ft94g),
and the VPS that hosts this web site was down for nearly 24 hours.  The Koha installations for
two of the libraries in Vermont that I support were down for less time, but still
many hours; thankfully these libraries weren't open on Sunday.
After this incident, I decided to look at Digital Ocean as a possible replacement
for Linode.

<!--more-->

## Digital Ocean Localhost Test Results

I spun up a "Droplet" on Digital Ocean with the same specs and pricing as
my Linode VPS: 2 GB RAM, 1 CPU (no special premium CPU), 50 GB disk, 
Ubuntu 22.04 LTS.  Then I installed Apache and ran this simple benchmark test while logged
into the VPS as root:

```
ab -n 10000 http://localhost/index.html
```

This performs 10000 fetches of the default Apache web page.  I ran the test several
times, and here are the relevant results
from the best of these tests:

```
Concurrency Level:      1
Time taken for tests:   2.520 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      109450000 bytes
HTML transferred:       106710000 bytes
Requests per second:    3967.64 [#/sec] (mean)
Time per request:       0.252 [ms] (mean)
Time per request:       0.252 [ms] (mean, across all concurrent requests)
Transfer rate:          42407.99 [Kbytes/sec] received
```

The results varied considerably; the worst of the results was 2017.81 requests per second.

## Digital Ocean Remote Test Results

I then ran a similar test from my laptop, which is located in a rural area
with relatively poor internet service (AT&T U-verse via bonded copper phone lines,
about 25 MB/S download).  Because this access was so much slower, I ran only
100 iterations:

```
ab -n 100 https://do.example.com/
```

Here are the relevant results:

```
Concurrency Level:      1
Time taken for tests:   13.921 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      2812400 bytes
HTML transferred:       2785000 bytes
Requests per second:    7.18 [#/sec] (mean)
Time per request:       139.213 [ms] (mean)
Time per request:       139.213 [ms] (mean, across all concurrent requests)
Transfer rate:          197.29 [Kbytes/sec] received
```

## Linode Test Localhost Test Results

I ran similar tests on my Linode VPS, and here are the relevant results
for the localhost test:

```
Concurrency Level:      1
Time taken for tests:   1.830 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      111920000 bytes
HTML transferred:       109180000 bytes
Requests per second:    5464.51 [#/sec] (mean)
Time per request:       0.183 [ms] (mean)
Time per request:       0.183 [ms] (mean, across all concurrent requests)
Transfer rate:          59725.39 [Kbytes/sec] received

```

As you can see, the localhost tests on Linode were about 40% faster
then on Digital Ocean.

## Linode Test Remote Test Results

As I did with Digital Ocean, I ran a similar test from my laptop.
Here are the relevant results:

```
Concurrency Level:      1
Time taken for tests:   39.205 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      2812400 bytes
HTML transferred:       2785000 bytes
Requests per second:    2.55 [#/sec] (mean)
Time per request:       392.051 [ms] (mean)
Time per request:       392.051 [ms] (mean, across all concurrent requests)
Transfer rate:          70.05 [Kbytes/sec] received
```

The remote test was much slower on Linode than on Digital Ocean.

## Conclusions

I realize this is not an exhaustive test, but it is clear
that for whatever reason (e.g. CPU speed or disk speed), Linode has
a significant speed advantage (around 40%) over Digital Ocean.

But testing web server speed from a remote host (my laptop) gave
a very different story.  Here, Digital Ocean's VPS delivered a web 
page more than twice as quickly as Linode.

Both of the VPSs are located in the same geographical area (SF Bay
Area).  But for some reason, traceroute from my home to the Linode VPS
takes much longer than to the Digital Ocean VPS: 75 ms and 23 hops for Linode, vs.
25 ms and 13 hops for Digital Ocean.  Pings showed nearly identical times.
This could be a major factor
in the difference in performance between the two services.
At some point, I'll need to test this again from a Bay Area location with better internet.

Linode has "warm migration" feature that is missing on Digital Ocean.
After the outage, I migrated my VPS to a data
center closer to home, and there was almost no downtime.  On Digital Ocean,
I would have had to shut down the VPS before doing a migration.
However, since I expect migrations would be very rare, this may
not be a significant issue.

I'll continue to play with the DO droplet, and will do more tests
from different locations before deciding whether to switch services.
