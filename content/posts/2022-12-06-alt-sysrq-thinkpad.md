---
title: Alt+SysRq on a newer ThinkPad
date: '2022-12-06 08:30:00'
tags:
- linux
- linux mint
- thinkpad
- ubuntu
---

In Linux, the magic Alt+SysRq+X keyboard combination can perform emergency
system tasks, like unmounting the disk(s) and rebooting the system, even
if the operating system appears dead or hung.  As an example, here are the SysRq key
combos that I've used to cleanly reboot a hung system (in this order):

1. Alt+SysRq+S: sync the filesystems
2. Alt+SysRq+U: unmount the filesystems
3. Alt+SysRq+B: reboot

Unfortunately, recent ThinkPads eliminated the top keyboard row, where
the SysRq key resided.  But there is a workaround, described in
[this post](https://superuser.com/questions/562348/altsysrq-on-a-laptop/1237766).
Here is the procedure:

1. Press and hold Fn + Alt + S
2. Release both Fn and S
3. Press and release the desired key (e.g. h to show the SysRq help)
4. Release Alt

For example, to send Alt+SysRq+S to a recent ThinkPad, use the above
procedure, and press S in the third step.  I verified that this works
on a ThinkPad T450s.
