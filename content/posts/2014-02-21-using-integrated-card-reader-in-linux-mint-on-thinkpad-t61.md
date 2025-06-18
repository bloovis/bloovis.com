---
title: Using integrated card reader in Linux Mint on ThinkPad T61
date: '2014-02-21 18:02:15 +0000'

tags:
- linux
- linux mint
- thinkpad
- ubuntu
---
The ThinkPad T61 has a built-in SD card reader that does not work with Linux Mint 15 out of the box.  When you insert an SD card, dmesg reports thousands of errors looking like this:
```
[166065.569415] mmcblk0: error -84 transferring data, sector 1, nr 7, cmd response 0x900, card status 0x0
```
The solution, which was given at the end of this [forum discussion](http://forums.linuxmint.com/viewtopic.php?f=49&t=78478), is to install the libccid package, using this command:
```
sudo apt-get install libccid
```
After this is installed, the SD card is mounted normally when inserted.

*Update*: The solution given above didn't work after a suspend/resume cycle.  It's necessary to unload and reload two kernel modules.  This can be done manually:
```
sudo modprobe -r sdhci_pci
sudo modprobe -r sdhci
sudo modprobe sdhci_pci
sudo modprobe sdhci
```
But it's better to have this done automatically.  As super-user, edit the file `/etc/pm/config.d/00sleep_module` and add the following line:
```
SUSPEND_MODULES="$SUSPEND_MODULES sdhci_pci sdhci"
```
When I did this, after the next resume it took three tries before inserting the card would cause it to be mounted successfully.  So there is still something more that probably needs to be fixed.
