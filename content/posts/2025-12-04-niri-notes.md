---
title: Niri Notes
date: '2025-12-04'
comments: true
tags:
- linux
- software
---

Here are some notes I jotted down while solving some minor problems with
[Niri](https://github.com/YaLTeR/niri?tab=readme-ov-file),
the tiling compositor for Wayland. (I am running Niri
on Fedora 43 KDE Edition.)  I've also included some tips for programs associated with Niri,
including fuzzel and waybar.

<!--more-->

## Niri

Most of the solutions below  involve editing Niri's config file, `~/.config/niri/config.kdl` .

### Make CapsLock be Ctrl

In the `input / keyboard / xkb` section of the config file, uncomment the `options` line, or make it look like this:

```
  options "compose:ralt,ctrl:nocaps"
```

### Toggle laptop screen

To add a command to toggle the laptop screen power, bound to Mod+P, first modify the `off` line
in the section for output eDP-1 so that it has a `// laptop` comment as a marker:

```
  off // laptop
```

Then create the script `toggle-laptop-screen`:

```bash
#!/bin/sh
sed -i -E \
 -e 's#(\s+)//\s*(off\s*//\s*laptop\s*)#\1\2#;t done; s#(\s+)(off\s*//\s*laptop\s*)#\1// \2#;: done' \
 ~/.config/niri/config.kdl
```

Then add this line to the `binds` section of the config file:

```
    Mod+P { spawn "/home/USER/bin/toggle-laptop-screen"; }
```

Change the path to the actual path of the script.

### Niri starts with blank white window

The problem is described [here](https://github.com/YaLTeR/niri/issues/2367).  It's
a window for xwaylandvideobridge, used in KDE.  I decided not to remove it,
since that might mess up some KDE programs.

As mentioned in the above link, you can find all the windows in Niri using `niri msg windows`.
and xwaylandvideobridge is the first one in the list.

### Niri color picker

From a terminal, run `niri msg pick-color` and then click on any point on the screen.
This will print the color at the location.

### Niri background image

Add this line to the config file:

```
spawn-at-startup "swaybg" "-m" "fill" "-i" "/usr/share/wallpapers/Path/contents/images/2560x1600.jpg"
```

Change the path for your favorite background image. Then restart Niri for it to take effect.

### Brave Browser dialogs don't appear

The problem is described [here](https://github.com/YaLTeR/niri/issues/1915).
You have to install and run Nautilus first; then the dialogs will
appear.  After the first run, you can close Nautilus.

## Waybar

### CPU fan widget

[Waybar](https://github.com/Alexays/Waybar/tree/master)
is the status/app bar used by default in Niri.

To add a CPU fan widget for a ThinkPad, add this custom module to the end of`~/.config/waybar/config.jsonc`:

```
    "custom/fan": {
      "exec": "sed -E -n 's/speed:\\s+//p' /proc/acpi/ibm/fan",
      "format": "{} ☢",
      "interval": 5
    }
```

For other laptops, you'll have to determine which proc device gives you the fan speed.
Then add this module to `modules-right` after the temperature widget:

```
    "modules-right": [
        ...
        "temperature",
        "custom/fan",
    ...
    ],
```

### Disappearing waybar tray

At one point, perhaps after running a KDE app, the little tray box on the far right of the waybar
disappeared. (The tray is useful for killing Zoom after a sesson.)  [This issue](https://github.com/Alexays/Waybar/issues/3468)
explains why.  I verified that kded6 had taken over the status notifier using this:

```
busctl --user list|grep -i status
```

The fix was to do this:

```
killall kded6
killall waybar
niri msg action spawn -- waybar
```

I put this in a script called `fixtray`.

## Fuzzel

[Fuzzel](https://codeberg.org/dnkl/fuzzel?ref=mark.stosberg.com) is the app
launcher used by default in Niri.

### Add Sioyek to the list of apps

[Sioyek](https://sioyek.info/) is a very fast and capable PDF viewer that I like
to use sometimes instead of Evince or Okular.  In order to make it visible
to Fuzzel, use the following steps.

Install (and rename) the sioyek appimage file to `/usr/local/bin/sioyek`.

Create the file `~/.local/share/applications/sioyek.desktop`:

```
[Desktop Entry]
Name=Sioyek
Comment=Sioyek PDF viewer
Exec=/usr/local/bin/sioyek %u
GenericName=PDF viewer
Icon=sioyek
StartupWMClass=Sioyek
MimeType=application/pdf;
Terminal=false
Type=Application
Version=2.0.0
Categories=Graphics;Office;Viewer;
```

Create an icon directory:

```
mkdir -p ~/.local/share/icons/hicolor/64x64/apps
```

Convert the viewpdf SVG file to a PNG, rename it, and install it in the directory just created:

```
magick /usr/share/icons/breeze-dark/mimetypes/64/viewpdf.svg ~/.local/share/icons/hicolor/64x64/apps/sioyek.png
```

## Alacritty

[Alacritty](https://github.com/alacritty/alacritty) is the terminal emulator used
by default in Niri.

### Font

The default font in Alacritty is "monospace regular".  To find which font is monospace, use `fc-match monospace`.
On Fedora, this is NotoSansMono.

To display the list of all fonts use `fc-list` .

I prefer using DejaVuSansMono, but it isn't installed by default in Fedora.
Install it using `sudo dnf install dejavu-sans-mono-fonts.noarch`.

Then edit `~/.config/alacritty/alacritty.toml` and add these lines:

```
[font]
size = 11
normal = { family = "DejaVuSansMono", style = "Regular" }
```

## Virtualization

When run under Niri, virt-manager complains that it can't connect to libvirtd.  Running `sudo systemctl status libvirtd`
shows the message:

```
Oct 16 09:35:42 dual libvirtd[4506]: authentication unavailable: no polkit agent available to authenticate action 'org.libvirt.unix.manage'
Oct 16 09:35:42 dual libvirtd[4506]: End of file while reading data: Input/output error
```

The Niri [Important Software](https://github.com/YaLTeR/niri/wiki/Important-Software) page has some
clues about plasma-polkit-agent, but is short on details.  I had to manually start the polkit
as my normal user (*not* root!) after Niri started:

```
systemctl --user start plasma-polkit-agent
```

Then restarted libvirtd:

```
sudo systemctl restart libvirtd
sudo systemctl status libvirtd
```

The status should no longer have the error message about authentication.

I will try to find a way to start this automatically when Niri starts, per the above web page.

## Ghostty

[Ghostty](https://ghostty.org/) is a very fast and capable terminal emulator
that I now use instead of Alacritty.  The config file is `~/.config/ghostty/config`.

For some reason, Ctrl-I and Ctrl-[ aren't mapped to Tab and Esc.  Fix this using:

```
keybind = ctrl+i=text:\x09
keybind = ctrl+[=text:\x1b
```
