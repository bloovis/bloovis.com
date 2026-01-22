---
title: Using a Raspberry Pi as a USB-tethered Router
date: '2026-01-08'

tags:
- linux
- raspberrypi
---

For several years, when I was living in rural Vermont in a location
that had no wired internet service, I used an Android phone tethered
to a Linux laptop via USB.  This worked well for that laptop, but I
also wanted to share that tethered connection to other machines via
Ethernet.  I used NetworkManager on the laptop to set the ethernet
port to "shared" mode, which effectively turned the laptop into a
router running a DHCP server.  Recently I tried to duplicate this setup
using a Raspberry Pi 4 instead of a laptop, and ran into a problem.

<!--more-->

The latest version of Raspberry Pi OS is a variant of Debian 13 "Trixie", which now
uses NetworkManager, as did that aforementioned laptop years ago, so I assumed that
I could use the same setup on the Pi.  I used `nmtui` to set the ethernet port
to "shared" mode, and that worked perfectly,
but I could not get the Pi to connect to the tethered Android phone correctly.
The Pi saw the phone, and both `ifconfig` and `nmcli` showed the phone as device
`usb0`, but the Pi didn't assign an IP address to `usb0`.

I first tried forcing the Pi to use DHCP, using this command:

```
sudo dhcpcd --waitip=4 usb0
```

That worked, but this obviously was not a permanent solution, because it had to be done whenever
I connected the USB cable to the Pi.  After some pondering on the NetworkManager
man pages, and studying logs with `journalctl`, I realized that on the Pi, NetworkManager
does not manage USB network connections.  This meant that I had to add the USB device to
NetworkManager explicitly, using this command:

```
sudo nmcli con add type ethernet con-name usb-network ifname usb0
```

Now NetWorkManager brought up the connection properly whenever the Android
phone was tethered to the Pi.

I also tried this same approach using an Inseego MiFi X PRO 5G device
in place of the Android phone.  But the MiFi device shows up on the Pi
as `eth1`, not `usb0` or `usb1`, so the following command was
necessary to add it to NetworkManager:

```
sudo nmcli con add type ethernet con-name mifi ifname eth1
```

## Sharing via Ethernet

As mentioned above, the USB tethered connection can be shared via ethernet.
It's simplest to do this using `nmtui`.  In `nmtui`, select "Edit a connection", then select the
ethernet connection ("netplan-eth0" on my Pi), then "Edit...".  Change
"IPv4 Configuration" to "Shared" and hit "OK".

## Sharing via wi-fi

To turn the Pi into a wi-fi hotspot, set it up the first time
using these commands:

```
sudo nmcli radio wifi on
sudo nmcli device wifi hotspot ssid MyCoolSsId password PaSsWoRd
```

Change the ssid and password to the values of your choice.  These commands
need to be run only once; NetworkManager should remember these settings
even after a power cycle.

To disable the hotspot in the future, use this command:

```
sudo nmcli radio wifi off
```

Then to re-enable the hotspot:

```
sudo nmcli radio wifi on
sudo nmcli connection up Hotspot
```

## Leases

You can see which DHCP leases NetworkManager has given out via ethernet using this
command:

```
sudo cat /var/lib/NetworkManager/dnsmasq-eth0.leases
```

Similarly, you can see the wi-fi leases using this command:

```
sudo cat /var/lib/NetworkManager/dnsmasq-wlan0.leases
```

