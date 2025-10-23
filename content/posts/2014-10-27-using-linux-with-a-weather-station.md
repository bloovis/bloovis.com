---
title: Using Linux with a weather station
date: '2014-10-27 11:08:24 +0000'

tags:
- linux
- linux mint
- software
- ubuntu
---

We have a Davis VantageVue weather station, which is a pricey but
excellent outdoor weather sensor that communicates with an indoor
console via radio.  The station has survived two Vermont winters so
far, which is a testament to its reliability.  Davis also sells an
optional WeatherLink, which is a data logging card that plugs into the
console.  The card stores weather data and has a USB connector so that
a computer can read the logged data.  The CD that comes with the
WeatherLink is designed for Windows, so it is just another useless
Microsoft tax.  But fortunately there is a fine software package
called [weewx](http://www.weewx.com/) that works with the VantageVue
and many other weather stations.  <!--more--> It reads the logged data from the
console and generates static HTML pages containing data and graphs,
showing weather information for the last day, week, month, or year.
The weewx setup went smoothly and it was able to read the VantageVue
data on the first try. 

The problem with this setup is that the device filename for the
weather station keeps changing, depending on whether other USB devices
(such as our tethered phone) are plugged in, and whether the laptop
hosting the software has been suspended recently.  Sometimes the
device would appear as `/dev/ttyUSB0`, and other times as
`/dev/ttyUSB3`.  Because the device name used by weewx is
hard-coded into the configuration file
`/etc/weewx/weewx.conf`, the weewx daemon is unable to
handle the device name changes and exits when it can't connect to the
weather station.

The solution was to write a special udev rule to create a symbolic
link to the device file.  First, use the lsusb command to determine
the vendor and product IDs of the USB device used by the VantageVue:

```
% lsusb
...
Bus 002 Device 013: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x UART Bridge /
 myAVR mySmartUSB light
...
```

Then as root, create the file `/etc/udev/rules.d/90-vantage.rules` containing the following line using the IDs obtained from lsusb:

```
ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60",
 SYMLINK+="vantage"
```

Then unplug and replug the VantageVue console, and the symbolic link `/dev/vantage` will be created, and this device name can be used in place of `/dev/ttyUSB?` in `/etc/weewx/weewx.conf`.
