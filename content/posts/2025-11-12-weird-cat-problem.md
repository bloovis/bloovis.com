---
title: A Weird Cat Problem
date: '2025-11-12'
comments: true
tags:
- linux
- software
---

No, this post is not about your pet cat barfing on your pillow or eating aloe plants.
It's about a weird problem I ran into using the `cat` program on Linux,
where it failed, complaining that "input file is output file".  This is a problem
that almost nobody would ever run into, let alone care about.  But I'd
seen this several times since I started using [Niri](https://github.com/YaLTeR/niri?tab=readme-ov-file), and I wanted to
get to the bottom of it.
<!--more-->

I often run `cat` with no arguments, which on the face of it would seem pretty stupid.
Why echo what you're typing right back at you?  But it's handy for seeing
what weird character sequences your terminal software generates when you press
certain key combinations.  I was using it recently to see what [ghostty](https://ghostty.org/)
produces when I hit `Ctrl-;`, which I kept doing accidentally in my text editor.

The weird thing was that in one of my ghostty windows, `cat` produced this error:

```
cat: -: input file is output file
```

Why did it do this in one terminal window, and not the others?

To track down this problem, I ran `cat` with the `trace` utility in both the "good" window
and the "bad" window (`trace` shows you every system call made by
a program).  This way I could see where the two instances diverged.
In this case, it looked like the "bad" `cat` was failing here:

```
fcntl(1, F_GETFL)                       = 0x402 (flags O_RDWR|O_APPEND)
```

whereas the "good" `cat` did this at the same point in its execution:

```
fcntl(1, F_GETFL)                       = 0x2 (flags O_RDWR)
```

Here is where `cat` is getting the file access mode for standard output (see `man fcntl`
for details).  For some reason, standard output on the "bad" `cat` had an extra
flag: `O_APPEND`.  I don't know how or why this would happen, but it seemed to
be the cause of the divergence.  This problem wasn't unique to ghosttty;
I also saw it with [alacritty](https://alacritty.org/).  I don't remember seeing it before
I switched to Niri.

To fix this, I wrote a simple little program that turns off the `O_APPEND` flag
on standard output:

```
#include <stdio.h>
#include <fcntl.h>

struct
{
  int flag;
  const char *name;
} table[] =
{
  { O_APPEND, "O_APPPEND" },
  { O_RDONLY, "O_RDONLY" },
  { O_RDWR,   "O_RDWR" }
};

int
main (void)
{
  int status, flags, i;

  flags = fcntl(1, F_GETFL);
  printf ("standard output file status flags: 0x%x\n", flags);
  for (i = 0; i < sizeof (table) / sizeof (table[0]); i++)
    {
      if (flags & table[i].flag)
        printf ("%s (0x%x)\n", table[i].name, table[i].flag);
    }
  if (flags & O_APPEND)
    {
      flags = flags ^ O_APPEND;
      printf ("Disabling O_APPEND by setting flags to 0x%x\n", flags);
      status = fcntl (1, F_SETFL, flags);
      if (status != 0)
        perror ("Unable to set flags!\n");
    }
  return 0;
}
```
