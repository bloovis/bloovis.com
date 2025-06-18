---
title: Enlarging Firefox Bookmark Dialog Box
date: '2025-03-04 06:25:00 +0000'
tags:
- software
- linux
- firefox
---

I recently had to stop using Ungoogled Chromium for various reaasons, the main
one being that it no longer worked with YouTube, and the fix for
that problem broke other web sites.  So I reverted back to Firefox,
which is fine (mostly).  But one annoying problem is that the dialog box
for adding a bookmark is very small, showing only about six
rows.
<!--more-->

I found a solution in
[this post](https://connect.mozilla.org/t5/ideas/add-bookmark-window-ctrl-d-should-be-resizable/idc-p/23500/highlight/true#M12642).
But the details are a bit terse and sketchy.

The first step is to create a `userChrome.css` file in your Firefox Profile.
This [web page](https://www.userchrome.org/how-create-userchrome-css.html)
tells how to do it, but because it's aimed at Windows and Mac users,
it's terribly complicated due to the tedious nature of using a GUI.
It's a lot simpler on the Linux command line.

Find your Firefox profile directory with these commands:

```
cd ~/.mozilla/firefox
egrep Default= profiles.ini
```

That will print something like this:

```
Default=60hdq6qz.default-release-1601810452348
Default=1
```

The first line is the interesting one.

Visit that directory (substituting your actual path):

```
cd 60hdq6qz.default-release-1601810452348
```

Create a `chrome` directory and move to it:

```
mkdir chrome
cd chrome
```

Create a file `userChrome.css` with the following contents:

```
#editBookmarkPanelContent {
    min-width: 47em !important;}
#editBMPanel_folderTree {
min-height: 480px !important;
}
/*remove picture from ctrl-d bookmark menu*/
html #editBookmarkPanelInfoArea {
display: none !important;}
```

Adjust the `min-width` and `min-height` values to your taste and screen size.

Finally, in Firefox, visit the <about:config> page.  In the search box, type `userprof` .
You should see a value called `toolkit.legacyUserProfileCustomizations.stylesheets`.
Change this to `true`.  Then restart Firefox.
