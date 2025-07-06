---
title: Self-hosting a CalDAV service
date: '2023-12-30 08:03:00 +0000'

tags:
- linux
- software
- ubuntu
---

One of the common uses of Google's "free" services is the appointment
calendar.  Similar services are provided by other vendors, but as
part of my effort to free myself from Big Tech, I decided to host
a [CalDAV](https://en.wikipedia.org/wiki/CalDAV) service on my
own Ubuntu 22.04 server.  There are two parts to hosting CalDAV:
a server and a web client.
<!--more-->

## Radicale

For a server, I chose to use [Radicale](https://radicale.org/v3.html).
Attempting to install Radicale using the radicale package built into
Ubuntu led to frustration in the configuration: I wasted a lot of 
time trying to get Apache to be happy with it.  It was much simpler
to use the instructions linked to above, which involves
downloading the package using pip (the Python package manager),
and manually creating a config file and a systemd service file.
These steps are mostly documented well, but there were a few ambiguities
that need clarification.

First, the `storage-filesystem-folder` setting in the config file should be the system-wide
value: `/var/lib/radicale/collections`.  Here are the full contents of 
my config file `/etc/radicale/config`:

```
[server]
# Bind all addresses
hosts = 0.0.0.0:5232, [::]:5232

[auth]
type = htpasswd
htpasswd_filename = /usr/local/apache/var/.htpasswd
htpasswd_encryption = md5

[storage]
filesystem_folder = /var/lib/radicale/collections
```

In this example, I used basic authentication to control access
to Radicale.  I had earlier created the `.htpasswd`
file for use with other web pages, using the `htpasswd` command,
and simply reused it for the Radicale server.

Then the appropriate changes need to be made to an Apache2 site configuration.
My site uses Let's Encrypt, so the config file that I needed to edit
was `/etc/apache2/sites-enabled/000-default-le-ssl.conf`.  In this
file, I added the following lines to the `VirtualHost` section:

```
  RewriteEngine On
  RewriteRule ^/radicale$ /radicale/ [R,L]
  <Location "/radicale/">
      ProxyPass        http://localhost:5232/ retry=0 upgrade=websocket
      ProxyPassReverse http://localhost:5232/
      RequestHeader    set X-Script-Name /radicale
  </Location>
```

The [instructions](https://radicale.org/v3.html#linux-with-systemd-system-wide)
for creating a systemd system-wide service file are accurate.
But you must enable and start the radicale systemd service
before attempting to view the radicale web page.  You can check that the service
started correctly by viewing its web interface using w3m (or some other
text-mode browser):

```
w3m http://localhost:5232
```


## InfCloud

For a web client, I chose [InfCloud](https://inf-it.com/open-source/clients/infcloud/).
The installation instructions are slightly hard to read, so here's what I did (all
commands run as root):

Change to the `/var/www` directory, download
the [InfCloud zip file](https://inf-it.com/open-source/download/InfCloud_0.13.1.zip),
and unpack it:

```
wget https://inf-it.com/open-source/download/InfCloud_0.13.1.zip
unzip InfCloud_0.13.1.zip
```

Change to the newly-created `infcloud` directory and use your favorite editor
to edit `config.js`.  Change the `href` value in `globalNetworkCheckSettings`
to the root URL for Radicale.  In my case, the config line looked like this:

```
        href: 'https://www.example.com/radicale/',
```

Then edit the same Apache site configuration file that you edited above,
and add the following lines to the `VirtualHost` section:

```
  Alias /infcloud /var/www/infcloud
  <Directory "/var/www/infcloud">
      AuthType Basic
      AuthName "InfCloud"
      AuthUserFile /usr/local/apache/var/.htpasswd
      Require valid-user
  </Directory>
```

In this example, I used the same basic authentication file (`.htpasswd`)
as in Radicale, described above.

## Try it out

After all this is done, restart Apache:

```
systemctl restart apache2
systemctl status apache2
```

If the status looks good, you should be able to visit Radicale by going to this
URL (of course, substituting your own site name for "example"):

<https://www.example.com/radicale>

Log in using the use name and password that you used when you first
created the `.htpasswd` file.  Then create a calendar and an addressbook;
if you don't do this, InfCloud may have trouble.

Now you should be able to log into InfCloud at this URL:

<https://www.example.com/infcloud/>

You will have to log in twice: once for Apache basic authentication,
and once for the InfCloud login screen.

{{< callout type="warning" >}}
*Note 2024-05-26*: I just discovered that creating a repeating
event like "every third Thursday" doesn't work correctly in
InfCloud.  The repeat will happen on the day before the intended
one (i.e, Wednesday in this example), and if you attempt to delete
the event, Infcloud produces an "Error 400" and refuses to delete
the event.  The only solution is to visit the directory
where the events are stored, which will be something like:

    /var/lib/radicale/collections/collection-root/user/big-huge-number

There you will find a bunch of .ics files.  You'll have to manually
delete the "bad" one, then restart Apache:

    systemctl restart apache2
{{< /callout >}}
