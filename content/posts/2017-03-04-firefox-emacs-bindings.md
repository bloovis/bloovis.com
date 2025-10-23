---
title: Emacs key bindings in Firefox and Brave
date: '2017-03-04 12:01:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
- fedora
- firefox
- brave
---

Firefox and the Brave browser can use Emacs key bindings in editable text fields,
but the method for enabling this feature has changed over the years.
<!--more-->

## Linux Mint Mate

In the Mate edition of Linux Mint, this
command will do the trick for Firefox:

```
gsettings set org.mate.interface gtk-key-theme 'Emacs'
```

In the Cinnamon edition of Linux Mint, use this for Firefox:

```
gsettings set org.cinnamon.desktop.interface gtk-key-theme 'Emacs'
```

The Brave browser (and presumably other Chromium-based browsers) uses a different setting to achieve
the same effect:

```
gsettings set org.gnome.desktop.interface gtk-key-theme 'Emacs'
```

## Fedora 42 KDE

On Fedora KDE, this command will work for Firefox:

```
gsettings set org.gnome.desktop.interface gtk-key-theme 'Emacs'
```

Unfortunately, Brave on KDE seems to ignore this setting, despite it being
identical to the setting that worked in Mate.  I haven't discovered an easy workaround
for this problem, though there is a rather complicated way using
[xremap](https://github.com/xremap/xremap?tab=readme-ov-file#kde-plasma-wayland)
that I did not try.
