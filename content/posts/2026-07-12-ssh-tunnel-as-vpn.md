---
title: "SSH Tunnel as Poor Man's VPN"
date: '2026-07-12'

tags:
- linux
- software
---

If you have a VPS (virtual private server), it's easy to 
use an SSH tunnel as a poor man's VPN for web browsing.  I used
[this article](https://joeldare.com/ssh-tunnels-my-vpn-alternative-for-privacy-on-the-go)
as a guide, but for completeness I'll describe how I used this idea.

<!--more-->

First, it will make life simpler if you set up passwordless login
to your VPS, using public and private keys.  There are many
articles on the web describing how to do this.

Then, to set up the tunnel, use a command like this:

```
ssh -D 8080 joeuser@myvps.example.com
```

Obviously, you must replace the username and hostname with the appropriate
values for your VPS.  Here 8080 is the port that SSH uses to set up a socks proxy tunnel.
The tunnel will stay alive as long as you're logged into your VPS with this
command.  If you exit SSH, the tunnel will disappear.

In your browser, install the FoxyProxy Basic extension.  (I used early versions
of FoxyProxy for six years for a remote job, and it was reliable and simple
to use.)  Pin the extension so that its little icon always appears
on the top line of the browser window.

In the FoxyProxy options, add a new proxy of type SOCKS5.  Set the
host name to `localhost` and the port to 8080.  Give the proxy a name
that will distinguish it from other proxies you may add in the future.

By default, FoxyProxy is disabled.  To enable it, click
on the extension icon and select the new proxy that you just added.  This
will cause all traffic from your browser to go through the SSH
tunnel you set up earlier.

To verify that you're using the SSH tunnel correctly, visit
<https://whatismyipaddress.com/> and confirm that the IP address it
reports is that of your VPS, not your local machine.

There's not much of an advantage to using an SSH tunnel if all of
your web browsing is on secure (https) sites *and* you're using a LAN (ethernet)
or a password-protected wi-fi network (we'll pretend against our better
judgement that wi-fi is secure).
But the tunnel could be useful if you have to use an insecure (password-free)
wi-fi network, or a LAN that isn't completely under your control.

There is a not-terrible speed hit when using the SSH tunnel.  I observed a
slowdown of about 25% in my limited testing, where [Speedtest](https://www.speedtest.net/)
reported a reduction from around 200 Mbps to around 150 Mbps.
