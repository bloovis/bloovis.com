---
title: Using ssh on Termux
date: '2025-09-30'
tags:
- linux
- android
---

[Termux](https://wiki.termux.com/wiki/Main_Page) is an app that brings
a terminal emulator and a full-fledged Linux development environment to
Android (version 12 and below).  It's easily installed from
[F-Droid](https://f-droid.org/en/).  But once it's installed, you
will probably want to bring files from your normal Linux machine
(say, a laptop) into the Termux environment, and that can be done with ssh.
<!--more-->

Connect the Android device to your local network, and install
Termux using the F-Droid app.  (I use GrapheneOS on my Android device,
and prefer using F-Droid to the Google Play Store.)

Then start Termux, and install the ssh package using:

```
pkg install openssh
```

Now create a new ssh key for Termux:

```
ssh-keygen
```

If you don't need a passphrase for your key (I didn't), just hit Enter
at the prompt.

If your Linux laptop doesn't have a DNS entry on your local network,
you will need to find its IP address.  Run this script on the laptop:

```
ip -o route get 8.8.8.8 | sed -e 's/^.* src \([^ ]*\) .*$/\1/'
```

Now you need to allow other systems to ssh into your laptop using a password.
As root on the laptop, edit the file `/etc/ssh/sshd_config` and 
add a line like this:

```
PasswordAuthentication true
```

Then restart the ssh server:

```
sudo systemctl restart ssh
```

Back in Termux, export your new ssh key to the laptop.  If your user
name on the laptop is `joeuser`, and its IP address is 192.168.1.10,
you would use a command like this in Termux:

```
ssh-copy-id joeuser@192.168.1.10
```

`ssh-copy-id` will prompt you for `joeuser`'s password, then will append the Termux public ssh key to `~/.ssh/authorized_keys` on the laptop.
This will allow you to ssh from Termux to the laptop in the future without having to
enter a password.

In Termux, there's no way to edit `/etc/hosts` to add an entry for the laptop.
But you can add an entry to `~/.ssh/config` for the laptop.  If that file
doesn't exist, create it.  Then add lines like the following:

```
Host laptop
    HostName 192.168.1.10
    User joeuser
```

Now you should be able to ssh to the laptop from Termux using this:

```
ssh laptop
```

Or you can copy files from the laptop into Termux, for example:

```
scp laptop:.bashrc .
```

This is just a small sampling of the kinds of things you can do in Termux.
I installed rsync, clang (C compiler), and make, and used them to
bring in the source code for my [MicroEMACS variant](https://github.com/bloovis/microemacs.mirror)
and build it.  I also installed ruby, my favorite scripting language.  All of this
works as you'd expect in Linux.

