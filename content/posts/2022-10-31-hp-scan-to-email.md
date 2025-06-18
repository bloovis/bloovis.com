---
title: Setting up scan to email in HP Color LaserJet printer
date: '2022-10-31 08:41:00'
tags:
- gmail
- printers
---

Our library has a relatively new HP multi-function laser printer that
has scanning and copying functions.  Recently a patron tried unsuccessfully to use
the printer's "scan to email" feature, and I realized we had never
configured the printer to enable this feature.  Here
are the steps I had to take to get this work.

<!--more-->

The scan to email feature requires that you give
the printer information about the email account that will be used
to send scans, including its password and the SMTP server and port.
When I tried to use our library's Gmail account for
this purpose, the printer reported an authentication failure.
Eventually I figured out that due to recent changes in Gmail
security policy, you need a Gmail account that
has two-factor authentication and an "app password".

## Create new Gmail account

So rather than change the library's Gmail account, I chose to
create a new Gmail account for the sole purpose of using
the scan to email feature.

This video explains how to do it: <https://www.youtube.com/watch?v=f5j24P2dy0U> .

Here is a brief summary of the steps:

Tell Gmail that you want to create a new account.  Let's call it `mylibrary@gmail.com`
for this example.  After Google creates the new email account, it will prompt you to
enable two-step authentication.  Do that using a cell phone for text messages.

Click on the circular icon at the upper right (the one with the first letter
of your account name), then click on **Manage your Google Account**.

On left side, click on **Security**.  Scroll down to **App passwords**.  It will say "None",
so click on the '>' to add one.

On the **Select app** dropdown, choose **Other**.  Give it a name like Scan,
and click **GENERATE**.  A popup will appear with a 16 character app password.
Copy this somewhere else and write it down just to be sure.  Don't insert
spaces in the password.

Click **Done**.

## Configure HP printer

Now it's time to tell the HP printer how to use your new Gmail account to
send scan emails.  This video explains how to do it: <https://www.youtube.com/watch?v=OM7PS-5D06A> .
But note that due to Google security changes since that video was made,
you must use the app password instead of the normal login password,
and the SMTP port must be 587.

First, find the IP address of printer.  In our library, we configured the printer
to have a static IP address, so that it wouldn't change if the printer or
the router were rebooted.  You can find the IP address by using the printer's
front panel to examine the network settings.  Let's say your printer's IP address is
`192.168.1.11` in this example.

In a browser on the same network as your printer, visit <https://192.168.0.11> (use the printer's actual IP address,
*not* this one!).  No password is required (!).  Click on **Scan** at
the top, then **Scan To Email Setup** on the left.  Select **Outgoing
E-mail Profiles**.  Click the **New** button.

Enter your sender email address (`mylibrary@gmail.com` in this example).
Give it a short display name (e.g., Scanner).

Set the SMTP Server to `smtp.gmail.com` .  Set the SMTP port to 587.
Check **Always use secure connection**.

Set the SMTP User ID to your sender email address (`mylibrary@gmail.com` in
this example).  Set the SMTP Password to your app password, *not*
your normal login password.  Check **SMTP server requires authentication
for outgoing e-mail messages**.

I didn't fill in the PIN, but if your printer is in a heavily-trafficked
public space, you may want to use a PIN to prevent unwanted usage of
the scan to email feature.

Under the **Auto CC** heading, uncheck **Include sender in all e-mail
messages sent out using this profile**.  This will ensure users' privacy.

Click on **Save and Test**.  This will take several seconds.  If it
reports an authentication error, you'll need to make sure you told the
printer the correct SMTP server, port, email address, and app
password.
