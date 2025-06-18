---
title: Make Firefox Disable the Screensaver
date: '2025-03-26 07:24:00 +0000'
tags:
- software
- linux
- firefox
---

After switching back to Firefox for Linux Mint (version 135),
I noticed right away that doesn't disable the screensaver
when watching videos (e.g., YouTube).  This appears to be
an old problem that was never fixed.  It's a confusing
problem on Mint with the Mate desktop, because there are two parts of the screensaver
settings in Mate:
<!--more-->

* the "normal" settings, where you select all sorts of fancy
screen saver themes
* the Power Management settings, where you force the
display to go into sleep mode after a timeout

In order to make Firefox turn off the screensaver, I first had
to disable the "normal" settings, i.e., uncheck "Activate screensaver
when computer is idle".  I left the Power Management settings alone,
which put the display into sleep mode after five minutes of idle time.

Then I ran [this Python script](https://github.com/dglava/firefox-dpms/blob/master/bin/firefox-dpms)
in a terminal session and left it running.
It would also be possible to set up a shortcut on the desktop to invoke
the script.  To get the script to work on Mint 21, I had to change the first line of the script to
the following:

    #!/usr/bin/env python3

The script requires the python `pulsectl` package, which can be installed
using:

    sudo apt install python3-pulsectl

In case the script disappears from Github, here it
is in its entirety.

```
#!/usr/bin/env python3

# Firefox-DPMS
# Copyright (C) 2018 Dino Duratović <dinomol at mail dot com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import pulsectl
import subprocess
import sys
import signal
import argparse

browsers = ("Firefox", "Firefox Developer Edition", "AudioIPC Server")

def get_options():
    """Parses command line options and returns them."""
    args = argparse.ArgumentParser()
    args.add_argument(
        "-c",
        "--command-on",
        help="command to run when video/audio streams are detected",
        )
    args.add_argument(
        "-o",
        "--command-off",
        help="command to run when all video/audio streams stop"
        )

    return args.parse_args()

def get_events(event):
    """Get the current event."""
    # using a global variable because I did not find a better way
    # to make this available in main(). Also considered a list in main()
    # to which we would append the event information from here.
    global current_event
    current_event = event
    raise pulsectl.PulseLoopStop

def event_wait(pulse):
    """Main pulsectl event loop."""
    pulse.event_mask_set('sink_input')
    pulse.event_callback_set(get_events)
    pulse.event_listen()

def check_firefox(pulse):
    """Verify that Firefox is playing video/sound.

    Queries the current sink-inputs. Checks if a sink-input is Firefox
    by looking for the media and application names.
    """
    for sink in pulse.sink_input_list():
        if sink.proplist["media.name"] == "AudioStream" \
                and sink.proplist["application.name"] in browsers:
            return True

def toggle_dpms(arg):
    """Change DPMS settings."""
    if arg == "on":
        subprocess.run(["xset", "+dpms"])
        print("DPMS turned ON", flush=True)
    elif arg == "off":
        subprocess.run(["xset", "-dpms"])
        print("DPMS turned OFF", flush=True)

def run_command(command):
    """Runs a shell command."""
    err_msg = "Error executing command: {}. Command not found"

    if command:
        try:
            subprocess.run(command.split())
            print("Executing: {}".format(command), flush=True)
        except FileNotFoundError:
            print(err_msg.format(command), file=sys.stderr, flush=True)

def handle_sig(signum, frame):
    """Run upon receiving a signal."""
    toggle_dpms("on")
    sys.exit()

def main(options):
    """Runs the main loop which detects Firefox sound activity.

    The program waits for Pulseaudio events.
    When it detects a "new" event and a Firefox sink is active,
    it turns DPMS off, because that means Firefox is playing back video.
    When it detects a "remove" event and no Firefox sinks are active,
    it turns DPMS on, because that means Firefox stopped playing video.
    """
    # handles SIGTERM and SIGINT
    signal.signal(signal.SIGTERM, handle_sig)
    signal.signal(signal.SIGINT, handle_sig)

    pulse = pulsectl.Pulse()
    DPMS_off = False

    while True:
        event_wait(pulse)
        # wait for a "new" event that creates a Firefox sink
        if current_event.t == "new" and check_firefox(pulse) and not DPMS_off:
            toggle_dpms("off")
            DPMS_off = True
            run_command(options.command_on)
        # wait for a "remove" event and no firefox sinks active
        elif current_event.t == "remove" and not check_firefox(pulse):
            toggle_dpms("on")
            DPMS_off = False
            run_command(options.command_off)

options = get_options()
main(options)
```
