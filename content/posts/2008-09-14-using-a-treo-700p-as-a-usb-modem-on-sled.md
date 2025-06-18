---
title: Using a Treo 700P as a USB modem on SLED
date: '2008-09-14 18:16:43 +0000'

tags:
- linux
- suse
- thinkpad
- treo
---
During my frequent trips to Vermont over the last four years, I've discovered that most airports do not offer free WiFi access (Burlington VT and JetBlue at JFK are notable exceptions).  In preparation for an upcoming trip to Vermont and the need to do some telecommuting en route, I figured out how to use my Sprint Treo 700p as an EVDO modem on SLED (SUSE Linux Enterprise Desktop) SP2 on a ThinkPad R61.  I was aided in this by a couple of blog postings: [Treo 700p Tether with Linux](http://suseroot.com/blog/blog.php?postid=75) and [Dialup Networking via Treo 700p and Ubuntu](http://ubuntu-tutorials.com/2007/06/07/dialup-networking-via-treo-700p-and-ubuntu-usb-connection/).  Rather than list only the things I did differently, here is a complete procedure.

**Installation**:

As an ordinary user on Linux:

* Create the directory `usbmodem` somewhere (e.g. in `~/tmp` or `~/Desktop`).  Make it the current directory.
* Download the [USB Modem](http://www.mobile-stream.com/usbmodem.html) zip file.  If you purchased the official version, it'll have a name like `usbmodem_retail_1_60.zip` .
* Unpack the zipfile using `unzip usbmodem_retail_1_60.zip`
* Install `USBModem.prc` on the Treo; you'll find this file in the current directory.  I did this by uploading the file to my web site, and then selecting it in the Treo's web browser.

As the root user on Linux:

  <li>From the usbmodem directory created earlier, run this command:
`cp drivers/linux/ppp-script-evdo-template  /etc/ppp/peers/ppp-script-treo`</li>
  <li>Edit /etc/ppp/peers/ppp-script-treo.  Change the "connect" line to:
`connect '/usr/sbin/chat -s -v "" AT OK ATD#777 CONNECT'`
Change the "user" line to:
`user USERNAME`
where USERNAME is your Treo's user name, as determined from the main phone app, Options / Phone Info, UserName.</li>
  <li>Edit /etc/ppp/pap-secrets, and add this line:
`USERNAME@sprintpcs.com     *`
where USERNAME is the phone's user name as determined in the previous step, and where there is a single tab between USERNAME@sprintpcs.com and the asterisk, not spaces.</li>

**Making a Connection:**

* Turn on the Treo, and connect it to the Linux machine with the USB sync cable.
* Wait a few seconds and verify that the visor kernel module has been loaded with `lsmod | egrep visor`.
* On the Treo, start the USB Modem program and press the "Enable Modem Mode" button.
* Back on Linux, perform the following steps as root.
* Bring down all other networks using `ifdown eth0` or `ifdown eth1` as necessary.
* Verify that the USB modem driver and device are present using `ls -l /dev/ttyACM0`
  <li>Connect to the EVDO network using:
`pppd /dev/ttyACM0 call ppp-script-treo`
You should see messages about the connection being established.  If  you see a message about default route not being overridden, you forgot to bring down all your existing net connections earlier.</li>
* Verify the connection using `route -n`.  You should see two entries for ppp0.  To make really sure the connection is working, try `ping -c3 www.google.com`
* End the connection by pressing the "Disable Modem Mode" button in the USB Modem program on the Treo.  This should automatically bring down the ppp0 connection on Linux.

It should be possible to use KPPP (the KDE dialup connection application) instead of the various command line tools described above, but I have not tried this.

The irony in all this is we can finally do something with our cell phones that we were doing with [Ricochet](http://en.wikipedia.org/wiki/Ricochet_(internet_service)) 13 years ago.
