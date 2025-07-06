---
title: Call forwarding on Tracfone / AT&T
date: '2020-10-30 12:46:00 +0000'

tags:
- android
- cell
---

Recent (at least the last five years) Android phones have a call forwarding
option in the settings of the built-in phone app.  But it's very inconvenient:
once you enable "always forward" and enter a phone number, the phone loses the additional
settings for "when busy", "when unanswered", and "when unreachable".
These settings normally point to the regional voicemail access number.
So when you later turn off "always forward", you have to re-enter those
three addtional settings, by typing the voicemail number three times.
<!--more-->

{{< callout type="warning" >}}
I no longer recommend this procedure.  It worked for a
while, but eventually AT&T permanently forwarded my phone and wouldn't
allow me to disable the forwarding.  Every attempt to do so, either
dialing the special code `#21#` or using the settings menu in the phone
app, resulted in "connection error or invalid MMI code" or "unexpected
response from network".  Buying a new SIM card had no effect.
Tracfone support was unable to help, so I'm being forced to move the
phone to another provider who understands the problem and knows how to
fix it.  This is an emergency phone now, not a primary phone, and it's
turned off 99% of the time, but it's still annoying to have to deal
with this problem.
{{< /callout >}}

A better solution is to use the provider's call forwarding "star
codes", which operate independently of the phone's own settings, and
which preserve the voicemail forwarding settings.  I use Tracfone on
the AT&T network, and it took some trial and error to learn the
correct star codes for call forwarding: many web pages have incorrect
information that didn't work for me.  The one that finally provided the
right information was
[this one](https://faq.its.fsu.edu/communications/cellular-service-and-equipment/att/how-do-i-use-call-forwarding-att)
from Florida State University.  Here's a summary:

To turn on call forwarding, dial `**21*`, followed by the destination ten digit phone number,
followed by `#`, then press Send.  On my phone, this resulted in a confirmation notification,
but then the phone app appeared to freeze.  I had to return to the home screen to unfreeze
the phone app.

To disable call forwarding, dial `#21#`, then press Send.  On my phone, this also resulted in a confirmation
and a freeze of the phone app.

To make this easier to use in the future, I assigned each of these
star code sequences to its own contact in the phone app, one called
"Forward To Home", and the other called "Disable Forwarding".
