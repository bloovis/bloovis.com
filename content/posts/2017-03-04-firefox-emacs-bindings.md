---
title: Emacs key bindings in Firefox and Brave on Linux Mint
date: '2017-03-04 12:01:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
---

Firefox can use Emacs key bindings in editable text fields,
but the method for enabling this feature has changed in Mint
over the years.  In the Mate edition of Linux Mint, this
command will do the trick:

    gsettings set org.mate.interface gtk-key-theme 'Emacs'

In the Cinnamon edition of Linux Mint, use this:

    gsettings set org.cinnamon.desktop.interface gtk-key-theme 'Emacs'

*Update 2025-09-05*: The Brave browser (and presumably, other
Chromium-based browsers) use a different setting to achieve
the same effect:

    gsettings set org.gnome.desktop.interface gtk-key-theme 'Emacs'
