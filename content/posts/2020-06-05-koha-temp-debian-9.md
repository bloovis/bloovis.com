---
title: Koha and Debian 9 and /tmp
date: '2020-06-05 10:05:00 +0000'

tags:
- linux
- software
- debian
- koha
---

I recently upgraded our library's Koha installation to 19.11 (from 19.05), and at the
same time upgraded the operating system from Debian 8 to Debian 9.  This created
a problem with the "Stage MARC records for import" feature in Koha. I could upload
the file, and using ssh I could see the file in `/tmp`.  But then Koha would complain
that the file did not exist when it tried to import it.

<!--more-->

This problem turns out to be the result of two things:

First, Debian 9 uses the PrivateTmp feature of systemd to run the Apache web server,
This means that Apache has its own `/tmp` directory in a private namespace, which
cannot be accessed by other processes.

Secondly, our Koha installation's `koha-conf.xml` configuration file was
missing a `tmp_path` entry.  This meant that by default, Koha uploaded MARC records to `/tmp`,
but Apache could not see them there, because it had its own private `/tmp` directory.

The solution was to add the missing `tmp_path` entry to `koha-conf.xml`, and point it to
somewhere other than `/tmp`.  Here is what the two related entries look like now:

    <upload_path>/var/lib/koha/INSTANCE/uploads</upload_path>
    <tmp_path>/var/lib/koha/INSTANCE/tmp</tmp_path>

Replace INSTANCE with your actual Koha instance name.  Then reboot the server
to make sure that Koha sees and uses the new paths correctly.
