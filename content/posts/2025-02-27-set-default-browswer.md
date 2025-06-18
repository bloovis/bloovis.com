---
title: Setting Default Browser on Linux
date: '2025-02-27 15:53:00 +0000'
tags:
- software
- linux
---

I've been using [Ungoogled Chromium](https://github.com/ungoogled-software/ungoogled-chromium)
for quite a while now,
but some time in the last few days it stopped played YouTube videos
successfully.  The symptom was that after 19 seconds, the
video would stop playing and a spinner would display forever.
<!--more-->

This turned out to be a [known bug](https://github.com/ungoogled-software/ungoogled-chromium/issues/3012).
The suggested fix was to enable the "Disable WebGL" flag in <chrome://flags>,
i.e. *disable* WebGL features.  This does seem to work, but
I don't know yet how this will affect other web sites that I use.

That's all well and good, but during my experiments,
I had started to use Firefox again (which did not have the YouTube
problem) and I told it to make itself the default
browser.  Then after I discovered the fix for Ungoogled Chromium,
I tried to tell it to make itself the default browser again
in its settings.  But that didn't seem to work.

In an attempt fix the problem, I ran this command:

    sudo update-alternatives --config x-www-browser

That displayed four alternatives, one of which was `/usr/bin/chromium`,
so I selected that.  I tested it by running this command to load
my own web site:

    open https://www.bloovis.com/

But it still ran Firefox to open the site.

There is another way to set the browser in Linux, using
`xdg-settings`.  I ran this:

    % xdg-settings get default-web-browser
    firefox.desktop

and that told me that Firefox was still the default browser.

I was able to verify that a similar desktop file existed for Ungoogled Chromium:

    % locate chromium.desktop
    /usr/share/applications/chromium.desktop
    % tail -1 /usr/share/applications/chromium.desktop
    +Exec=/usr/bin/chromium --incognito
    % ls -laF /usr/bin/chromium 
    lrwxrwxrwx 1 root root 53 Jan 25 07:40 /usr/bin/chromium ->
      /usr/bin/ungoogled-chromium_128.0.6613.119-1.AppImage*

So that told me that the following command would set
the default browser to Ungoogled Chromium:

    xdg-settings set default-web-browser chromium.desktop

And using the `open` command again showed that it did indeed work.



