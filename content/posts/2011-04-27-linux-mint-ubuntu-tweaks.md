---
title: Linux Mint / Ubuntu tweaks
date: '2011-04-27 22:14:45 +0000'

tags:
- linux
- linux mint
- software
- ubuntu
---

Each time I install Linux Mint on a new machine, or upgrade an
installation, I have to perform a set of tweaks to get the system to
look and behave the way I want.  After doing these tweaks yet again
over the weekend, I decided to write them down for posterity.
<!--more-->

* Before IBM introduced the PS/2 in the mid-80s, the Control key on terminals and PCs was always where God intended it: next to the A key.  The PS/2 keyboard moved the Control key to a very inconvenient location on the bottom left corner of the keyboard.  All other PC makers copied this incredible blunder.  Finger tendons have suffered ever since, especially those of Emacs users.  To fix this: Menu / Control Center / Assistive Technologies / Keyboard Accessibility / Layouts / Options / Ctrl key position / Swap Ctrl and CapsLock.
* Make bash the default shell:` sudo dpkg-reconfigure dash`, answer No.
* The compiz window manager provides useless eye candy and doesn't honor some window manipulations, like roll-up.  To disable it: Menu / Control Center / Appearance / Visual Effects / None. This must be done before changing window behavior.
* I like seeing all windows in the task bar when I switch workspaces.  To enable this, open Window List Preferences, and enable Show windows from all workspaces and Restore to native workspace.
* Enable Emacs editing keys in Firefox: `gsettings set org.mate.interface gtk-key-theme 'Emacs'` .
* Install useful Firefox addons: Adblock Plus, Keyconfig, Flashblock, LastPass, ViewSourceWith.
* I dislike having to enter my password when the screensaver comes on after an idle period.  To disable this behavior: Menu / Control Center / Screensaver / uncheck Lock screen when screensaver is active.
* Add the volume control to panel: right-click on panel, select Add to Panel, choose Indicator Applet.
* Install the SSH server to allow remote shell access: `sudo apt-get install openssh-server`
* To enable two-finger scrolling on the touchpad: go to Menu / Preferences / Mouse / Touchpad, where the option can be found.
* Suspend when the lid is closed: Menu / Preferences / Power management / When laptop lid is closed: Suspend.
* My editor has bindings for F1 and F11, but mate-terminal (derived from gnome-terminal) uses these as shortcuts for Help and Full Screen, respectively.  [This page](http://www.mariusv.com/disable-f1-in-gnome-terminal/ ) has the solution.  To disable F1 in mate-terminal: Edit / Keyboard Shortcuts.  Select action Contents, click on F1, hit Backspace to change the binding to Disabled.  Do the same for F11.
* Install a bunch of useful packages: keepassx, openssh-server, dvdbackup, flac, vorbis-tools, ruby, rubygems1.8, ruby-dev, libtcltk-ruby, cdparanoia, tkdiff, sun-java6-bin, sun-java6-jdk, sun-java6-plugin, sun-java6-jre.

