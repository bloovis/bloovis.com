---
title: Fixing HP P1006 Printer Out of Paper Error
date: '2022-11-09 07:55:00'
tags:
- linux
- linux mint
- ubuntu
- printers
---

On my Linux Mint 19 system, when the HP P1006 printer runs out of paper, the
printing system (CUPS) refuses to print even after loading paper into
the printer, power-cycling the printer, and disconnecting and reconnecting
the USB cable.  In the end, restarting CUPS
seems to be the only way to eliminate the "out of paper" indicator:

    sudo systemctl restart cups
