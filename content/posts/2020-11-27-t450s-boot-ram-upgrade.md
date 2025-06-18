---
title: ThinkPad T450s boots slowly after RAM upgrade
date: '2020-11-27 17:13:00 +0000'

tags:
- thinkpad
---

After I installed an 8 GB RAM stick in the single DIMM slot in a ThinkPad T450s,
the system didn't seem to be powering on successfully.  The usual ThinkPad logo
didn't appear within a few seconds.  Instead, the screen remained black for
quite a long time.  I powered off the system and tried reseating the DIMM, but
the problem remained.

It turns out that I wasn't patient enough.  According to a
[Lenovo forum post](https://forums.lenovo.com/t5/ThinkPad-T400-T500-and-newer-T/T450s-ram-upgrade/td-p/3470010),
it may take a couple of minutes for the system to boot the first time after
a RAM upgrade, as it "checks timings and configures the slots."  Subsequent
boots go quickly, as expected.
