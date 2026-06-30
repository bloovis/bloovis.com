---
title: Fedora 43 on a ThinkPad X270
date: '2026-06-18'
comments: false
tags:
- linux
- software
---

I recently installed Fedora 43 KDE on a ThinkPad X270, and ran into three problems,
all of which seemed to be related to the TrackPoint.  I think I may have solved
the problems, but time will tell.

<!--more-->

## TrackPoint Buttons Behave as If Sticky

At first, it seemed as if at random times, the TrackPoint buttons would start behaving as
if they were stuck down.  I noticed this in the Fedora installer, and in using
the system after installation.  For example, the middle button would seem to be stuck down,
because moving the TrackPoint would cause a scrolling event, even though the button
was *not* pushed down.  The same thing would happen to other buttons.
I discovered [this post](https://www.reddit.com/r/thinkpad/comments/16ntfjt/i_need_help_with_x270_touchpad/)
on Reddit describing this problem, and you can read my response there.
I'll recap it here in case something goes wrong with Reddit.

The clue was the following message in `/var/log/messages`:

```
2026-06-07T03:20:18.599557-07:00 x270 kernel: psmouse serio1: synaptics: Your touchpad (PNP: LEN2046 PNP0f13) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
```

I took this suggestion, and added `psmouse.synaptics_intertouch=1` to the kernel boot arguments.  To
do this on Fedora, log in as root (`sudo su`) and do the following:

1. Edit the file `/etc/default/grub`.  Add `psmouse.synaptics_intertouch=1` to the value of
`GRUB_CMDLINE_LINUX`. Save the file.

2. Run the command `grub2-mkconfig -o /etc/grub2-efi.cfg`, and reboot the system.

3. After rebooting, check the boot parameters by running this command: `cat /proc/cmdline`.

This seemed to fix the stuck button problem, but another problem kept occurring.

## Random Clicks and Moves

The TrackPoint would occasionally start behaving as if a cat or monkey were randomly and rapidly
pressing buttons and moving the TrackPoint, causing windows or menus to pop up unexpectedly.
After a few seconds the wildness would die down.

I was able to fix this on Fedora by having it do a complete system update, including all Linux
software (such as the kernel), and also the ThinkPad firmware, including the BIOS.  It's not clear
to me whether updating Linux or the BIOS fixed the problem.  (One of the reasons I like Fedora
is that it is able to update the BIOS without having to boot a Lenovo updater from a USB stick.)

## Random Screen Freezes

Yet another problem persisted: at random times, but more frequently soon after a suspend/resume cycle,
the cursor and the screen would appear to freeze for a second or two, and the TrackPoint was
also unresponsive during this freeze.  After some searching,
I found [this post](https://www.reddit.com/r/thinkpad/comments/rhbf8m/solution_thinkpad_short_freezes_on_gnulinux/)
on Reddit where one of the commenters mentioned a touchpad freeze.  Although this freeze
appears to be related to the Intel graphics driver, and although I always disable
the touchpad, I did try the suggested fix, which is similar to similar to the first fix described above.

On Fedora, edit `/etc/default/grub`, and add
`i915.enable_psr=0` to `GRUB_CMDLINE_LINUX` and regenerate the boot system
with `grub2-mkconfig -o /etc/grub2-efi.cfg`.
This seems to have fixed the problem, although as usual time will tell.
