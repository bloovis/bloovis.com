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
(say, a laptop) into the Termux environment, or ssh from Termux to another machine,
or ssh into Termux from another machine.

<!--more-->

## Initial Setup

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

## Outgoing SSH

Let's say you want to ssh from Termux to your Linux laptop.
You need to configure the ssh server (`sshd`) on the laptop to allow other systems to ssh into
it.  As root on the laptop, edit the file `/etc/ssh/sshd_config` and
add a line like this:

```
PasswordAuthentication yes
```

Then restart the ssh server:

```
sudo systemctl restart ssh
```

Back in Termux, export your new ssh key to the laptop.  If your user
name on the laptop is `joeuser`, and the laptop's IP address is 192.168.1.10,
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

## Incoming SSH

You can also run the ssh server on Termux, allowing you to ssh from your laptop
into Termux.  This makes using the terminal on the phone much more convenient.
The procedure is described [here](https://wiki.termux.com/wiki/Remote_Access)
fairly well.  But for completeness, here's what I did:

On Termux, edit the file `$PREFIX/etc/ssh/sshd_config`.  Then uncomment the `PrintMotd`
and `PasswordAuthentication` lines by removing the '#' character, so that they look
like this:

```
PasswordAuthentication yes
...
PrintMotd yes
```

Start the ssh server using the `sshd` command.
Later, when you're done using the ssh server, stop it using `pkill sshd`.

Set a password using the `passwd` command.

Get your Termux user ID by using the `id` command.  Let's say it's `u0_a149`.

Find your Termux IP address by using the same command that you used
on the laptop earlier:

```
ip -o route get 8.8.8.8 | sed -e 's/^.* src \([^ ]*\) .*$/\1/'
```

Or run `ip -o route get 8.8.8.8` by itself, without the pipe to sed,
and examine the output for the IP address.

Then on the laptop, ssh into Termux using this command (change `192.168.0.119`
to the actual IP address of Termux that you learned earlier):

```
ssh -p 8022 u0_a149@192.168.0.119
```

Enter the password you set earlier, and you should now be logged into Termux.

In order to avoid having to enter a password in the future, do this
on the laptop:

```
ssh-copy-id -p 8022 u0_a149@192.168.0.119
```

You'll be prompted for the Termux password, but after that you shouldn't
be prompted again.

## Conclusion

This is just a small sampling of the kinds of things you can do in Termux.
I installed rsync, clang (C compiler), and make, and used them to
bring in the source code for my [MicroEMACS variant](https://github.com/bloovis/microemacs.mirror)
and build it.  I also installed ruby, my favorite scripting language.  All of this
works as you'd expect in Linux.

