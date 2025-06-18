---
title: Koha on Linode
date: '2017-01-18 11:01:00 +0000'

tags:
- linux
- software
- debian
- koha
---

[Koha](https://koha-community.org/) is an open source library system
that is used widely throughout the world, and especially in Vermont.  For various reasons
(including financial) our library was not able to join either of the two consortia
of Koha users in Vermont.  So I installed Koha on Linode for the exclusive
use of our library.

[Linode](https://www.linode.com/) is a hosting service that provides low-cost
Linux virtual servers, called "Linodes".  Installing Koha in a Linode is
a straightforward process, but it does require that you to be somewhat comfortable
with typing commands at a command prompt.

<!--more-->

### Initial setup

Most of the following instructions were taken from the following Koha wiki pages, though
some details differ due to the wiki pages being slightly out of date:

* [Koha on Debian](https://wiki.koha-community.org/wiki/Koha_on_Debian) describes the basic installation of Koha on Debian
* [Troubleshooting Koha as a Z39.50 server](https://wiki.koha-community.org/wiki/Troubleshooting_Koha_as_a_Z39.50_server) describes setting up Koha as a Z39.50 server
* [Plack](https://wiki.koha-community.org/wiki/Plack) describes how to enable Plack, which greatly speeds up Koha
* [Commands provided by the Debian packages](https://wiki.koha-community.org/wiki/Commands_provided_by_the_Debian_packages) describes the commands provided by the Koha package

When I set up my Linode instance for Koha, I selected the lowest cost plan, which provides
2 GB of RAM.  So far, that seems adequate for our library.  If necessary in the
future, the Linode instance can be resized without loss of data.  The amount of RAM
is the most important factor affecting Koha performance.  If in the future we feel
that performance is not adequate, doubling the RAM size to 4 GB should help considerably.

(Disk size is only important for very large libraries. The 25 GB disk size provided
for the lowest cost Linode plan appears to be more than enough for our library.
It is remotely possible that in the distant future, the ever-enlarging circulation records
and acquisitions might require a disk size upgrade.)

Koha is most easily installed in a host running the Debian 8 distribution of Linux.
Fortunately Linode provides pre-made Debian 8 installations; simply select the
64-bit variant of Debian 8 when setting up your Linode.  This process takes
only a few short minutes.

Once Debian 8 is deployed in your Linode instance, use the Remote
Access tab on the Linode dashboard to determine the ssh command you
need to use to connect to your Linode instance as root (superuser).
When you log in with ssh, you'll need to use the root password that
you set up when you created your Linode instance.  For simplicity, I
used the same password for my Linode account and my root account on my
Koha Linode instance.

If you are unlucky enough to be stuck with a Windows computer, you can
use the add-on [PuTTY](http://www.putty.org/) program as your ssh client.

All of the following commands assume that you are logged into your Linode as root
using ssh.

### Install Koha

We are going to install Koha from prebuilt Debian-compatible packages.
First set up the package source:

    wget -q -O- http://debian.koha-community.org/koha/gpg.asc |
       apt-key add -
    echo 'deb http://debian.koha-community.org/koha stable main' |
       tee /etc/apt/sources.list.d/koha.list

(Note that the two commands shown above have been split into two lines each for formatting
in this post.  You should type these commands on single lines, not split as shown.)

The second command above chooses the most recent stable release of Koha (16.11 as of this writing).
If you want to use the previous stable release, replace "stable" with "oldstable" in that command.

Now update the package list and install the Koha package:

    apt-get update
    apt-get install koha-common

This will take several minutes as apt-get installs a large number of prerequisite packages
needed by Koha.

Now you need to install the MySQL database:

    apt-get install mysql-server

During the installation, MySQL will ask you for a root password.  For simplicity,
use the same password that you chose for your Linode account and ssh access.

### Configure Koha defaults

Before you create a Koha instance for your library, you can change
the default settings for Koha.  Do this by editing the file
`/etc/koha/koha-sites.conf` with your favorite editor (nano
is a good choice for a simple, ssh-friendly editor).

First, you may want to change the settings for the site names and port
number in the lines starting with `DOMAIN` and ending with
`OPACSUFFIX`.  The comment preceding those lines explains how your
catalog's URL will be formed from the values in those lines.

If you don't have a domain name yet, you can just set DOMAIN to ".linode.com"
and use the IP address of your Linode to access Koha (more on that below).

In the case of our library, we already had an informational web page
that would eventually be moved to the Linode.  Since the default port
number for web pages is 80, I chose to use ports 81 and 82 for the OPAC
("OPACPORT") and staff client ("INTRAPORT") to avoid conflicts.

I also chose to enable Memcached, which is a web page caching mechanism
that speeds up access.  To do this, change the value of `USE_MEMCACHED`
from "no" to "yes".

Finally, save the file and exit the editor.

### Set up Apache

Apache is the web server used by Koha.  Before starting Koha, we need to
change some of Apache's settings.  First, we need to tell Apache to listen on the correct ports.
Edit the file `/etc/apache2/ports.conf`.  There should already be a line like
this in the file:

    Listen 80

Below that line, add these two lines:

    Listen 81
    Listen 82

If necessary, change these port numbers to the same ones you chose earlier when
editing `/etc/koha/koha-sites.conf`.  Then save the file and exit the editor.

Next, we need to enable certain Apache modules, then restart it:

    a2enmod rewrite
    a2enmod cgi
    a2enmod headers proxy_http
    service apache2 restart

### Create a Koha instance

Now it is time to create a Koha instance for your library.  In the following
command, replace `LIBRARYNAME` with the name of your library (typically, an
easy-to-type abbreviation):

    koha-create --create-db --use-memcached LIBRARYNAME

### Access the web interface

To complete the Koha installation, you will need to access the web interface
from Firefox on another machine.  To do this, you'll need to know the domain name
for your Linode host.  If you don't have a domain name yet, you can use
its IP address.  To determine the IP address, run this command:

    ifconfig eth0 | grep "inet addr:"

The output will look something like this:

    inet addr:12.345.67.89  Bcast:23.239.9.255  Mask:255.255.255.0

The IP address is the first set of four numbers (12.345.67.89 in this
made-up example).

To determine the user name and password that you will need to log into
Koha, type the following commands:

    xmlstarlet sel -t -v 'yazgfs/config/user'
       /etc/koha/sites/LIBRARYNAME/koha-conf.xml && echo
    xmlstarlet sel -t -v 'yazgfs/config/pass'
       /etc/koha/sites/LIBRARYNAME/koha-conf.xml && echo

(Note that the two commands shown above have been split into two lines each for formatting
in this post.  You should type these commands on single lines, not split as shown.
Be sure to change LIBRARYNAME to the name you chose when you created your
Koha instance earlier.)

In Firefox, enter the URL of your new Koha instance, which will be "http://",
followed by domain name or IP address of the Linode, followed by ":" and the port
number you chose for "INTRAPORT" earlier when editing `/etc/koha/koha-sites.conf`.
Using the example above, the URL would be: `http://12.345.67.89:82/`

Koha will prompt you for a user name and password.  Enter the values
you obtained earlier using xmlstarlet.  Once you've logged in, Koha
will ask you a number of questions about your installation.  It's safe
to stick with the defaults, but you might want to install the optional
Z35.90 servers and sample item types and locations to get you started.

### Enable Plack

Plack is a piece of software that speeds up the connection between the web server
(Apache) and Koha (which is largely written in Perl, a popular scripting language).
According to [benchmark tests](https://wiki.koha-community.org/wiki/Benchmark_for_16.11),
it can improve Koha's response time by a factor of three in some common operations.

Enabling plack is now quite simple in Koha.  Run these commands:

    koha-plack --enable LIBRARYNAME
    koha-plack --start  LIBRARYNAME
    service apache2 restart

As always, change LIBRARYNAME to the name you chose when you created your
Koha instance earlier.  It's possible that `koha-plack` may require you to
install some prerequisites, but it should tell you how to do that, and afterwards
you can rerun `koha-plack`.

### Enable Memcached

If you neglected to tell Koha to enable Memcached when you ran the `koha-create` command
earlier, it can still be done manually
after installation.  It used to be sufficient
to add the following lines to both VirtualHost sections of
`/etc/apache2/sites-available/LIBRARYNAME.conf`:

    SetEnv MEMCACHED_SERVERS "127.0.0.1:11211"
    SetEnv MEMCACHED_NAMESPACE "koha"

But now those lines seem to be ignored, apparently due to a bad interaction
with Plack (see [this bug](https://bugs.koha-community.org/bugzilla3/show_bug.cgi?id=11921)
for more information).  The
solution is to add the following lines to the `<config>` section of
`/etc/koha/sites/LIBRARYNAME/koha-conf.xml`:

    <memcached_servers>127.0.0.1:11211</memcached_servers>
    <memcached_namespace>koha</memcached_namespace>

After making this change, restarting Apache is not sufficient; I rebooted
the machine to get the change to take effect.  In retrospect,
`service memcached restart` may have been sufficient.

You can check if Memcached is working using this command:

    telnet localhost 11211

If Memcached is running, you will get a "Connected to localhost" message.
Exit telnet by hitting Control-], followed by Enter, followed by Control-D.

Now play around with Koha a little by loading different pages.  Then check
if caching is actually taking place using this:

    memcdump --servers 127.0.0.1

You should see a large list of cache items.

If memcdump is not available, install it using:

    sudo apt-get install libmemcached-tools

### Enable Z39.50

Koha can act as a Z39.50 server, so that other libraries can search
your catalog.  To enable Z39.50, edit the file `/etc/koha/sites/LIBRARYNAME/koha-conf.xml`,
where LIBRARYNAME is the name you chose when you created your Koha instance.

Near the top of that file is a line that looks like this:

    <listen id="publicserver">tcp:@:nnn</listen>

Uncomment that line by removing the `<!--` and `-->` lines before and after it.
Then replace `nnn` with an unused port number, preferably something greater
than 1023.  I chose 9998.

Farther down in the file, around line 180, is a section starting with a line that
looks like this:

    <!-- PUBLICSERVER'S BIBLIOGRAPHIC RECORDS -->

Below that is a line that looks like this:

    <server id="publicserver"  listenref="publicserver">

Remove the start-of-comment line (`<!--`) before that line.

Now move down to around line 260, where you will see this line:

    </serverinfo>

Remove the end-of-comment line (`-->`) after that line.

Finally, save the file and exit the editor.

Restart Zebra (the program that handles searches in Koha):

    koha-restart-zebra LIBRARYNAME

where LIBRARYNAME is the name you chose when you created your Koha instance.
Verify that Zebra is now listening on the port you chose (9998 in the
example above) by doing this:

    netstat -pn --tcp --listen | grep 9998

If things are working, you should see a line that looks like this:

    tcp        0      0 0.0.0.0:9998            0.0.0.0:*               LISTEN      6986/zebrasrv   

If things are not working, you won't see any output.

As a final check, you can try making a Z39.50 connection:

    yaz-client tcp:127.0.0.1:9998/biblios

If things are working, you should see a few lines of output, including a line
that looks like this:

    Connection accepted by v3 target.

and then a prompt line:

    Z> 

If things aren't working, you'll see an error message like this:

    Connecting...error = System (lower-layer) error: Connection refused

Exit the `yaz-client` program by hitting Ctrl-D or typing `exit` followed by Enter.

In case of errors, check out the Koha wiki here: [https://wiki.koha-community.org/wiki/Troubleshooting_Koha_as_a_Z39.50_server](https://wiki.koha-community.org/wiki/Troubleshooting_Koha_as_a_Z39.50_server).

If you need to provide your Z39.50 information to other libraries,
such as the [Vermont Department of Libraries](http://libraries.vermont.gov/services/tech/z39.50),
so that they can search your catalog, here is what they need to know:

* Hostname: the fully qualified doman name or IP address of your Koha server
* Database name: biblios
* Port number: 9998

### Enable Template Cache

Enabling a template cache can significantly improve Koha's performance.  To do this,
add the following line to the `<config>` section of
`/etc/koha/sites/LIBRARYNAME/koha-conf.xml`:

    <template_cache_dir>/var/cache/koha/LIBRARYNAME/templates</template_cache_dir>

Then create the template cache directory and make it writeable by Koha:

    mkdir -p /var/cache/koha/LIBRARYNAME/templates
    chown LIBRARYNAME-koha:LIBRARYNAME-koha /var/cache/koha/LIBRARYNAME/templates

Finally, restart Apache and Koha:

    service memcached restart
    service apache2 reload
    koha-plack --restart LIBRARYNAME

As always, change LIBRARYNAME to the name you chose when you created your
Koha instance earlier.

### Daily backups

It is highly recommended that you enable backups for your Linode instance.  This will
allow you to recover your system in the event of some catastrophic disaster.

The Koha installation also performs automatic backups for your Koha database and configuration files.
It performs these backups once a day.

The backup files are stored in the directory `/var/spool/koha/LIBRARYNAME` (where LIBRARYNAME
is the name of your Koha instance).  The names of the files indicate the date they were created.
There are two files for each day's backup: one for the database (with the filename ending
in `.sql.gz`) and one for the configuration files (with the filename ending in `.tar.gz`).
In case of disaster, these files can be used to restore your Koha installation with the
[koha-restore](https://wiki.koha-community.org/wiki/Commands_provided_by_the_Debian_packages#koha-restore) command.

By default, Koha deletes backup files older than two days.  If you would like to increase
the number of days that backups are kept around, edit the file `/etc/cron.daily/koha-common`.
At the bottom of that file, you will see a line that looks like this:

    koha-run-backups --days 2 --output /var/spool/koha

Change the 2 to the number of days you'd like to keep backups, then save the file and
exit the editor.

### Enable email

In order for Koha to send email, you must first set up your Linode's email
server.  If you follow [this tutorial](https://www.linode.com/docs/email/exim/deploy-exim-as-a-send-only-mail-server-on-ubuntu-12-04/)
religiously, your Linode should be able to send email.  When the mail configuration program
asks you for your system's FQDN (fully qualified domain name), enter either of
the following:

* the name for your Linode that you've set up with your domain name service (e.g. `koha.example.com`)
* the Linode-specific hostname, which you can find on the Remote Access tab of your Linode
  Dashboard (e.g. `li123-45.members.linode.com`)

After following the steps in the tutorial, restart the mail server:

    /etc/init.d/exim4 restart

You may have to repeat the "restart" step if you reboot your Linode.

Then enable email for your Koha instance:

    koha-email-enable LIBRARYNAME

Finally, it may be necessary to make sure that Reverse DNS works for your Linode
in both IPV4 and IPV6 modes; otherwise, Gmail may not accept mail from exim4.  See
[this tutorial](https://www.linode.com/docs/networking/dns/setting-reverse-dns)
to learn how to configure Reverse DNS.

Configuring Koha for email is the subject of a separate post.

### Robots.txt

To prevent search engines from indexing your entire OPAC site, include
the bibliographic records, as root create the file `/usr/share/koha/opac/htdocs/robots.txt`
with the following contents:

    Crawl-delay: 60

    User-agent: *
    Disallow: /

    User-agent: Googlebot
    Disallow: /cgi-bin/koha/opac-search.pl
    Disallow: /cgi-bin/koha/opac-showmarc.pl
    Disallow: /cgi-bin/koha/opac-detailprint.pl
    Disallow: /cgi-bin/koha/opac-ISBDdetail.pl
    Disallow: /cgi-bin/koha/opac-MARCdetail.pl
    Disallow: /cgi-bin/koha/opac-reserve.pl
    Disallow: /cgi-bin/koha/opac-export.pl
    Disallow: /cgi-bin/koha/opac-detail.pl
    Disallow: /cgi-bin/koha/opac-authoritiesdetail.pl

See [this bug](https://bugs.koha-community.org/bugzilla3/show_bug.cgi?id=4042)
for a discussion of robots.txt in Koha.

### Future stuff

The Koha installation described above is not quite complete.
Some things that will have to be completed in the future:

* Koha configuration (item types, authorized values, circulation rules, email, etc.).
* Enable SSL on both the OPAC and the staff client.  This will ensure security on the
  connection.  It will have to be done after the DNS records for
  our library are pointed at the Linode.  The tool I'd like to use
  is [certbot](https://certbot.eff.org/#debianjessie-apache) from the Electronic Frontier
  Foundation.
* Configure the information users see on the OPAC home page.

I'll update this post as things progress.
