---
title: Hibernate using swap partition on Fedora
date: '2026-08-06'
comments: false
tags:
- linux
- software
---

All of the guides I could find about using hibernate on Fedora assumed
a stock installation with btrfs and no swap partition.  I use ext4 and swap
partitions, but making hibernate work with this setup was reasonably simple
<!--more-->

First, find out the device name of the swap partition:

```
lsblk -p
```

Here is the output on my system:

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
/dev/sda      8:0    0 931.5G  0 disk
├─/dev/sda1   8:1    0  47.5G  0 part /
├─/dev/sda2   8:2    0     1K  0 part
├─/dev/sda5   8:5    0 872.9G  0 part /home
└─/dev/sda6   8:6    0  11.2G  0 part [SWAP]
/dev/zram0  251:0    0     8G  0 disk [SWAP]
```

From this we can see that the swap partition device is `/dev/sda6`.  Ignore
`/dev/zram0`.

Find out the UUID of the swap partition:

```
sudo swaplabel /dev/sda6
```

This will display a UUID consisting of a long sequence of hex digits and
dashes.  Let's say it's `beef-face-1234` (this example is too short for
a real UUID but I'm using it for brevity).

Enable the swap partition using:

```
sudo swapon -U beef-face-1234
```

To check if the swap partition size is large enough to hold the Linux image,
using this command to print the image size in GB:

```
dc -e "2 k `cat /sys/power/image_size` 1073741824 / p"
```

If this is less than the swap partition size as printed by `lsblk -p`, you're in luck.

As root, edit `/etc/default/grub` and add `resume=UUID=beef-face-1234`
to `GRUB_CMDLINE_LINUX`.

If your system uses the EFI boot method, use this command to rebuild the GRUB menu:

```
sudo grub2-mkconfig -o /etc/grub2-efi.cfg
```

If your system uses the legacy boot method, use this command instead:

```
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

Then reboot the system.  Try hibernating using:

```
sudo systemctl hibernate
```

The system will shut down.  Hit the power button to restart it.  You should
see Fedora rebooting, then after a few seconds, Fedora will restore the saved state.
If a fresh boot happens instead, it may be that
`dracut` (the tool that creates the initramfs) needs to be configured and run.

Check if the `resume` module is in the initramfs:

```
sudo lsinitrd -m | grep resume
```

If this produces no output, as root create the file `/etc/dracut.conf.d/resume.conf`
with the following contents:

```
add_dracutmodules+=" resume "
```

Regenerate the initramfs using this command:

```
sudo dracut --regenerate-all --force
```

Use `lsinitrd -m` again to check that resume got added to the modules.  Hibernate
should work correctly now.
