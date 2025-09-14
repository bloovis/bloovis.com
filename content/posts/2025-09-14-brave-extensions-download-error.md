---
title: Brave browser download error installing extensions
date: 2025-09-14
tags:
- linux
- software
- brave
- fedora
---

For some reason, on Fedora 42 KDE, the most recent Brave browser (version 1.82.166) is unable
to install extensions from the Chrome Web Store, always giving an
error saying "Download error: Download interrrupted."  The workaround solution is
to manually load the CRX file for the extension.
<!--more-->

I ran into a similar problem when I was using Ungoogled Chromium.  There's a
[wiki section](https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore)
for that browser that describes the solution.  Essentially, you extract the extension
ID from the URL for the extension, insert it into another long URL, and use wget
to fetch that URL.  I have written a simple shell script to do this:

```bash {filename="get-crx"}
#!/bin/sh

# Download a Chrome extension CRX file, given the extension's
# URL in the Google Chrome Web Store. This is based on the information here:
# https://ungoogled-software.github.io/ungoogled-chromium-wiki/faq#can-i-install-extensions-or-themes-from-the-chrome-webstore

# set -x

if [ -z "$1" ] ; then
  echo "usage: get-crx <URL of extension in Chrome Web Store>"
  echo "This script downloads a Chrome extension CRX file, which is useful when the"
  echo "browser says Download Interrupted when you try to install the extension"
  exit 1
fi
url="$1"
id=`echo "$url" | sed -E -e "s#.*/detail/[^/]+/([^?]+)\??.*#\1#"`
version=140.0
wget -O $id.crx "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${version}&x=id%3D${id}%26installsource%3Dondemand%26uc"
echo Extension saved to $id.crx
```

{{< callout type="info" >}}
You may need to edit the value of `version` in this script.  I obtained the value in Brave
by using the hamburger menu, clicking on Help, then About Brave, then copying the first
two numbers from the Chromium version number.
{{< /callout >}}

Run this script, passing it the URL of the extension in the Chrome Web Store.  The script will save
the extension in the file `ID.crx`, where ID is the very long extension ID.

Now you have to load the extension into Brave.  Use the hamburger menu, click on Extensions, then
on Manage Extensions.  Enable Developer Mode (the slide switch at the upper right corner).  Use
the desktop file browser (Caja on Mate, Dolphin on KDE) and navigate to the directory where
you saved the extension CRX file.  Drag the extension from the file browser window to the
Brave extensions page, and Brave should ask you if you want to install the extension.
