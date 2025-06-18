---
title: Sharing a VPN connection on Linux
date: '2010-06-02 15:19:02 +0000'

tags:
- linux
- software
---
My employer's VPN system doesn't allow more than one login at a time.  But there are occasions when I'd like to be able to use the VPN from two different laptops simultaneously.  The solution, most of which I found [here](http://www.sharms.org/blog/2008/11/03/how-to-share-a-vpn-connection-in-ubuntu-intrepid-ibex/), is to use iptables on the machine running the VPN to forward packets from the machine not running the VPN.

In my case, the Juniper VPN software (ncsvc) sets up a connection on the net device `tun0`, and the network address is 10.0.0.0.  So after I start the VPN on one machine, I run the following script on that machine:

```
#!/bin/sh
# Share the VPN connection with other machines on the local net.
# The assumption here is the the VPN network is 10.0.0.0.
if [ `id -u` -ne 0 ] ; then
   echo "You are not root.  Rerunning with sudo..."
   sudo $0
else
   echo "1" > /proc/sys/net/ipv4/ip_forward
   iptables -A FORWARD -i eth0 -d 10.0.0.0/8 -j ACCEPT
   iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
   sysctl net.netfilter.nf_conntrack_acct=1
fi
```

Be sure to replace the network address (`10.0.0.0`), VPN net device (`tun0`) and local net device (`eth0`) with the correct values for your system.

Then on the machine that is not running the VPN, I run the following script:

```
#!/bin/sh
sudo route add -net 10.0.0.0 netmask 255.0.0.0 gw VPNHOST
sudo cp /etc/resolv.conf.vpn /etc/resolv.conf
```

In this script, replace VPNHOST with the hostname of the machine that is running the VPN (i.e., the name of the machine that is running the first script above).  I use static IP addresses on all of my machines, and have added entries for these addresses to `/etc/hosts` on all machines.  I'm not sure how this would work with dynamic IP addresses (DHCP).

The last line of this script is the one new thing I'm doing differently from the scripts at the aforementioned link.  It makes the non-VPN machine's name resolution configuration file identical to that of the VPN machine.  This allows the non-VPN machine to resolve hostnames residing on the VPN. In order for this to work, I had earlier copied `/etc/resolv.conf` from the machine running the VPN to the non-VPN machine, and renamed it to `/etc/resolv.conf.vpn`.
