---
title: Fixing high CPU usage in Linux Mint 13 on ThinkPad X200s
date: '2013-05-13 22:14:57 +0000'

tags:
- linux
- linux mint
- thinkpad
- ubuntu
---
One of the first things I noticed on the X200s after installing Mint 13 was that after logging in or after a suspend/resume, CPU usage seemed too high.  The most immediate symptoms were that the mouse and keyboard were very slow to respond.  The `top` command showed that various processes with `kworker` in their names were responsible for hogging nearly all of the CPU.  This high CPU usage would continue for a minute or two before subsiding, but would reoccur at unpredictable times.

As usual, forums offered various solutions.  One popular solution was to find the most frequently occurring interrupt in `/sys/firmware/acpi/interrupts/*` and disable it.  But on the X200s, this didn't fix the problem, and it added a new problem: the special ThinkPad function keys for things like volume control, display brightness, suspend, monitor switching, etc., now responded very slowly, taking what felt like 30 seconds to perform any action.

The solution that actually worked was to disable [kernel mode setting](https://wiki.archlinux.org/index.php/Kernel_Mode_Setting) polling, a kernel feature related to video modes, apparently.  The temporary fix, which I used to see if it would actually work, was to do the following:

```bash
sudo su   # become root
echo N> /sys/module/drm_kms_helper/parameters/poll
```

The permanent solution, which survives suspend or reboot, is:

```bash
sudo su   # become root
echo "options drm_kms_helper poll=N">/etc/modprobe.d/local.conf
```
