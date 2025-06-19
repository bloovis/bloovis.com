---
title: Creating an encrypted directory on Linux
date: '2008-10-25 19:27:21 +0000'

tags:
- linux
- software
- suse
---
There are a number of ways to encrypt a file system on Linux, and the choices of strategies (single directory or entire partition) and tools (dm-crypt, [LUKS](http://luks.endorphin.org/), losetup) can be bewildering.  I didn't have a spare partition to play with, and I wanted to use what seemed to be regarded as the preferred tool (LUKS).  So here's how I created an small encrypted directory on SLED (SUSE Linux Enterprise Desktop 10 SP2).  (I cobbled together this information from [Encrypted Root File System with SUSE](http://en.opensuse.org/Encrypted_Root_File_System_with_SUSE_HOWTO_10.2) and [File System Encryption](http://www.novell.com/communities/node/4548/file-system-encryption).)  I performed all of these steps as root in root's home directory.

First I created a 100 MB file and filled it with random data:
```
dd if=/dev/zero of=private bs=100M count=1
shred -n 1 -v private
```

I created a loopback device that referred to this file:

```
losetup /dev/loop0 private
```

I loaded various kernel modules required for encryption:

```
modprobe dm-mod
modprobe dm-crypt
modprobe aes
modprobe sha256
modprobe sha1
```

I created an encrypted mapping for the device:

```
cryptsetup -v --key-size 256 luksFormat /dev/loop0
```

At the prompt, I entered a passphrase (which would be used later to open the device).  I verified that the encryption setup had succeeded using:

```
cryptsetup -v luksDump /dev/loop0
```

I opened the encrypted device, and at the prompt typed same the passphrase I had entered earlier:

```
cryptsetup luksOpen /dev/loop0 private
```

This created a mapping device at `/dev/mapper/private`. The next step was to create a file system:

```
mkfs.ext3 /dev/mapper/private
```

Finally, I mounted  the file sytem at `/mnt:`

```
mkdir /mnt/private
mount /dev/mapper/private /mnt/private
```

At this point, I now had a 100MB encrypted directory, mounted at `/mnt/private` and backed by the file `~/private`.

To unmount the file system and close the encrypted device, I did this:
```
umount /mnt/private
cryptsetup luksClose private
```
