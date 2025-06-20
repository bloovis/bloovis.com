---
title: Unblock sound on resume in Linux Mint
date: '2017-05-30 08:43:00 +0000'

tags:
- linux
- software
- linux mint
- ubuntu
---

On the ThinkPad T60p and T61, using Linux Mint 17 and later (and probably Ubuntu
16.04 or later), sound is not properly initialized after a suspend/resume cycle.  The symptom is that after a resume, playing a video
on YouTube produces no sound.  The fix is to play a sound file using the `/usr/bin/play`
utility (part of the `sox` package), which unblocks or reinitializes the audio device.

<!--more-->

On Mint 17, to make the fix run automatically after a resume, become root (`sudo su`)
and create the executable script `/usr/lib/pm-utils/sleep.d/48sound`
with the following contents:

```bash
#!/bin/sh
# sound - play a sound after resume to unblock sound device.

# . "${PM_FUNCTIONS}"

case $1 in
	hibernate|suspend)
		;;

	thaw|resume)
		/usr/bin/play -q /usr/share/sounds/linuxmint-gdm.wav
		echo "48sound resuming!" >/tmp/sound.log
		;;

	*) exit $NA
		;;
esac

exit 0
```

Make the script executable using `chmod +x /usr/lib/pm-utils/sleep.d/48sound`.

On Mint 18 and later, suspend is handled by systemd and the above script won't run.
Instead, create the executable script `/lib/systemd/system-sleep/sound`
as root with the following contents:

```bash
#!/bin/sh

case $1 in
  post)
    /usr/bin/play -q /usr/share/sounds/linuxmint-gdm.wav
    ;;
esac
```

Use `chmod +x /lib/systemd/system-sleep/sound` to make the script executable.

This fix produces an innocuous short beep on resume.
