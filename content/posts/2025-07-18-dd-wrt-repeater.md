---
title: Using DD-WRT in Repeater Mode
date: '2025-07-18'
tags:
- linux
- network
- dd-wrt
---

I bought my mother an [Opal travel router](https://www.gl-inet.com/products/gl-sft1200/)
so that she could have a private network in her apartment, separate from the public building-wide wi-fi network.
This would improve security and prevent other people from seeing her
devices on the network, including her printer.  The Opal has a Repeater mode
that is easy to set up, it and worked fine for a while.  But the Opal turned out
to be unreliable, crashing at unpredictable times, so I decided to see
if I could replace it with an old
[Linksys WRT54GL router running DD-WRT](https://wiki.dd-wrt.com/wiki/index.php/Linksys_WRT54GL).
<!--more-->

As a starting point, I used [this article about Wlan Repeater mode](https://wiki.dd-wrt.com/wiki/index.php/Wlan_Repeater).
The instructions there are good, but there were a few details that were missing,
or that turned out to be unnecessary or misleading.

First, it should be noted that this old router uses a Broadcom wireless chip set,
which is a good thing, because the article above said that Atheros chip sets
don't support Repeater mode.  I had already installed DD-WRT version V3.0-r44715 std (11/03/20)
a few years ago, and fortunately this version supported Repeater mode.

For completeness, here is the procedure I used, copied and edited slightly from the article
above:

1. It was not necessary to do a hard reset.  The 30-30-30 procedure mentioned in a few
places in the DD-WRT Wiki is non-sensical and can harm some routers.  Instead, it's
only necessary to do a factory reset from the DD-WRT GUI, at
**Administration** {{< icon "arrow-right" >}} **Factory Defaults**.

[![Factory Reset](/images/resized_to_600/factory-defaults.png "Factory reset")](/images/factory-defaults.png)

2. Under **Wireless** {{< icon "arrow-right" >}} **Basic Settings**:

   * Physical interface `wl0`:

     * Wireless mode: Repeater
     * Wireless Network Mode: mixed
     * Wireless Network Name (SSID): match the host (`Redwood City Guest` in my case)
     * Save

   * Virtual interface `wl01`:

     * Add one virtual interface
     * Wireless mode: AP
     * Wireless Network Name (SSID): unique SSID of your choice (`SharkTank` in my case)
     * Save

   * When done, it should look like this:

[![Wireless Basic Settings](/images/resized_to_600/wireless-basic-settings.png "Wireless Basic Settings")](/images/wireless-basic-settings.png)

3. Under **Wireless** {{< icon "arrow-right" >}} **Wireless Security**:

   * Physical Interface `wl0`:

      * Security mode: match the host (WPA2-PSK in my case)
      * WPA Shared Key: match the host
      * Save 

   * Virtual Interface `wl0.1`:

      * The article says to use WPA2-AES, but I used WPA2-PSK
      * WPA Shared Key: enter your unique key
      * The article says to make the two keys the same, but I found this wasn't necessary
      * Save 

   * When done, it should look like this:

[![Wireless Security](/images/resized_to_600/wireless-security.png "Wireless Security")](/images/wireless-security.png)

4. Under **Setup** {{< icon "arrow-right" >}} **Basic Setup**:

   * Network Setup:

      Here you define the repeater's own subnet.
      Set Local IP address to a different subnet from the Host AP you wish to repeat.
      For example, if host AP is 192.168.1.x, set your Local IP Address repeater to 192.168.2.1.
      Set up your DHCP range if you desire.

   * Save
   * When done, it should look like this:

[![Basic Setup](/images/resized_to_600/setup.png "Basic Setup")](/images/setup.png)

5. (Optional but recommended) Under **Security**:

   * Uncheck all items in the "Block WAN Request" section (except Filter Multicast)....THEN disable the SPI firewall
      * Note: If you are very concerned about security, a Repeater might still work okay with the SPI firewall enabled. If you decide to leave it enabled but experience problems, keep this step in mind. 
   * Save 
   * When done, it should look like this:

[![Security](/images/resized_to_600/security.png "Security")](/images/security.png)

6. Recheck each tab and section to ensure that your settings are correct. Then click APPLY to write changes. 
