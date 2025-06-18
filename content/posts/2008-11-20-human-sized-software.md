---
title: Human-sized software
date: '2008-11-20 18:55:48 +0000'

tags:
- software
---
The piece of software that I'm most proud of is a tiny real-time kernel that I wrote for the Intel 8080 back in 1979. The 8080 was a very early predecessor to the now-ubiquitous Pentium.  It had specs that seem laughable now: 8-bit data, 16-bit addressing, 2 MHz clock speed.  Obviously, with a chip this slow, efficiency was the name of the game in software.  So I wrote the scheduler and interrupt handler in assembly language, based on the design (but obviously not the actual code) of Intel's own RMX-80 kernel.  I don't have the source code to this kernel, but I recall that it amounted to less than 2K of assembled code.

It seems almost pathetic that I should still be this fond of something I wrote almost thirty years ago, and which, like most software, has been thrown away.  But the fact is that software has grown nearly as fast as the hardware it runs on, doubling in size every couple of years and consuming all available resources.  The result is that it is nearly impossible now for one developer to completely understand a typical piece of personal computer software.

Sure, one can "own" a tiny piece of one these monsters, and understand just that one piece.  That's really the only approach that makes sense, and that's what at I do at my current employer, which has several thousand developers working on software packages whose binary downloads weigh in at over 100 megabytes.  But I miss being able to work on something that is all mine, whose every nook and cranny is known to me, and which is perhaps directly useful to me in some way.

I can imagine that other developers would regard this desire as unrealistic, nostalgic, and egotistical.  But to me it is no different from the desire of a woodworker to produce a single object of beauty in his own woodshop at night, after installing drywall in a mobile home factory all day.  To that end, I've resumed work on a 20 year old personal project that satisfies this desire; more about this later.
