---
title: Put Firefox Cache in RAM
date: '2025-10-20'
tags:
- linux
- software
- firefox
---

The Firefox browser is constantly writing large amounts of data to its cache,
which is a concern when your storage device is an SSD.  The solution is
to put the Firefox cache in RAM.  The procedure is much simpler
than it is for the [Brave browser](/posts/2023-10-10-brave-cache-in-ram/),
because it doesn't involve using a RAM disk.
<!--more-->

The procedure is described [here](https://easylinuxtipsproject.blogspot.com/p/ssd.html#ID9.2)
 but in case that site goes away, here it is:

In Firefox, visit the `about:config` page and click through the warning.

Set the value of `browser.cache.disk.enable` to `false`.

Set the value of `browser.cache.memory.enable` to `true`, if it's not already set.

Set the value of `browser.cache.memory.capacity` to some large number that is suitable
for the amount of RAM on your system.  I chose 524288, which is 512 MB.

Close Firefox and restart it.  Visit the `about:cache` page to verify that the cache
is no longer on the disk.


