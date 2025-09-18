---
title: Force a Wi-Fi Login Page to Appear
date: '2023-10-09 10:11:00 +0000'

tags:
- linux
- software
- brave
---

Some public wi-fi networks require you to log in to their network using a browser.
This is an annoying feature of hotel wi-fi, in particular.  Some browsers,
like the Brave browser on Android, detect this situation and redirect
you to the login page the first time you try to use the network.

But the Brave browser on Linux doesn't seeem to be able to do this,
and won't bring up the login page.  The solution is to
to visit the web interface of the network's gateway router, which
will then redirect to the login page.

To find the gateway's IP address on Linux, use this command:

    ip route | sed -n -e "s/default via \([0-9.]\+\).*/\1/p"

Then copy and paste the IP address into the address bar of the browser,
and hit Enter.  This should redirect the browser to the login page.
