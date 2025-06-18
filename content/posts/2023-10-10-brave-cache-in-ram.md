---
title: Put Brave Browser Cache in RAM
date: '2023-10-10 07:40:00 +0000'

tags:
- linux
- software
---

The Brave browser is constantly writing large amounts of data to its cache,
which is a concern when your storage device is an SSD.  The solution is
to put Brave's cache on a RAM disk, i.e., a tmpfs device on Linux.  Some
Linux distros, like Arch, mount `/tmp` as tmpfs, but Linux Mint 21 does not.

## Mount /tmp as tmpfs

So the first step on Mint is to change `/tmp` to tmpfs.  This can be
done with systemd instead of creating a mount point in `/etc/fstab`.
Run this command to create the tmp.mount systemd service:

    sudo cp /usr/share/systemd/tmp.mount /etc/systemd/system

By default, this service creates a `/tmp` RAM disk that takes
up half of all available RAM.  To create a specific size of RAM disk,
edit the file `/etc/systemd/system/tmp.mount` using sudo and your
favorite editor, then change the `size` parameter in the Options line.
As an example, here is what the Options line looks like for a 1GB /tmp file system:

    Options=mode=1777,strictatime,nosuid,nodev,size=1g,nr_inodes=1m

Then enable the tmp.mount service:

    sudo systemctl enable tmp.mount

I rebooted after this step, but you can also
start the service without rebooting:

    sudo systemctl start tmp.mount

Verify that `/tmp` is now mounted as tmpfs:

    mount | grep /tmp

The output should look something like this:

    tmpfs on /tmp type tmpfs (rw,nosuid,nodev,size=1048576k,nr_inodes=1048576,inode64)

## Move Brave cache to /tmp

Shut down Brave before proceeding.  Then remove the existing Brave cache,
and symlink the cache to `/tmp`

    cd ~/.cache
    rm -rf BraveSoftware
    ln -s /tmp BraveSoftware

After restarting Brave, you should now see its cache on `/tmp`

    ls -laF /tmp/Brave-Browser

Occasionally check to see how close `/tmp` is to filling up:

    df -h /tmp

If it's getting full, tell Brave to clear its cache (in Settings / Privacy and security /
Clear browsing data).
