---
title: CapsLock as Ctrl on a Linux server console
date: '2025-09-19'
tags:
- linux
- fedora
- ubuntu
---

The Ctrl key is now universally placed by keyboard manufacturers in the
wrong place, on the bottom row.  For decades I've been tweaking my Linux
(and even Windows!) installations to make the CapsLock key act as a Ctrl key, since it's
where the Ctrl key used to be (and *should* be) before IBM's bone-headed decision to move
it in the late 1980s on their PS/2 computer.  This is easily done in the popular desktop environments
like Mate and KDE, using their respective keyboard layout configuration tools.
But it's also useful to do the CapsLock-as-Ctrl trick on a server with no GUI,
i.e., only a Linux text console.
<!--more-->

The technique for doing this is something I'd used decades ago but forgotten
until yesterday.  It involves using `loadkeys` to modify the kernel's keyboard mapping tables.
Here's a one-liner that does the job:

```bash
(dumpkeys | head -1 && echo "keycode 58 = Control") | sudo loadkeys
```

Note that this will *not* work in a GUI desktop terminal session; `dumpkeys`
will issue this error:

```
Couldn't get a file descriptor referring to the console.
```

I tested this on Fedora 42 Server running in a VM, and I'm pretty sure
it would work on bare hardware, too.

As long as we're talking about the Linux console, I should mention that
the lack of mouse-based cut, copy, and paste operations can be annoying.  But one
workaround is to use GNU `screen` and its copy/scrollback mode.  It's not
as convenient as using a mouse, but it's certainly usable. The `screen` man page
has the details.
