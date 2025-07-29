---
title: Protecting a Web Site with Anubis and Apache
date: '2025-07-23'
tags:
- linux
- software
- anubis
- apache
---

In an [earlier post](/posts/2025-07-11-anubis-koha.md/),
I described using [Anubis](https://anubis.techaro.lol/)
to block AI scrapers from our library's [Koha](https://koha-community.org/) installation.
That worked well enough that I decided to try using Anubis
to protect my non-CGI web site that has some static content
and a few Web-based services.
<!--more-->

## The Problem
As a starting point, I used [this article](https://anubis.techaro.lol/docs/admin/environments/apache)
from the official documentation about using Anubis with Apache.
The simple configuration described there worked well for my static content.

But things get complicated with the several web services I also use.
Anubis presents a challenge that can only be solved by a client that can
run Javascript, typically a modern browser.  But some of the web services
I use have non-browser clients, like [Joplin](https://joplinapp.org/)
and the [Bitwarden desktop app](https://bitwarden.com/download/).
So the Apache configuration must be designed to prevent Anubis from
acting as the middleman for these services.

## Anubis Configuration

As I did with the Koha site, install Anubis from the `...amd64.deb` file in the Assets section of
the latest release [here](https://github.com/TecharoHQ/anubis/releases).
Then as root, create the Anubis configuration as follows.

In directory `/etc/anubis`, create two files.  The first is `env`,
the systemd environment variable file. Note that we are telling Anubis to listen
on port 8082, and to forward requests to the unsecured web site at
port 8083; you may want to use different ports
to avoid conflicts with any web services you might be running.
You should also generate a different key by using `openssl rand -hex 32`.

```{filename="/etc/anubis/env"}
BIND=localhost:8082
BIND_NETWORK=tcp
DIFFICULTY=4
POLICY_FNAME=/etc/anubis/botPolicies.yaml
TARGET=http://localhost:8083
#TARGET=https://www.example.com:8083
# random, openssl rand -hex 32
ED25519_PRIVATE_KEY_HEX=727f7501fdbbae467ee95131ca911bb1eedadf009e2886f781a07237c6d4779c
```

Then create the Anubis policies file `botPolicies.yaml`.  Here we are telling Anubis to
allow known good search engine bots and WebDAV requests, but challenge
everything else:

```yaml {filename="/etc/anubis/botPolicies.yaml"}
bots:
  # Search engine crawlers to allow
  - import: (data)/crawlers/_allow-good.yaml
  # Allow common "keeping the internet working" routes (well-known, favicon, robots.txt)
  - import: (data)/common/keep-internet-working.yaml
  - name: allow-webdav
    action: ALLOW
    expression: 'path.startsWith("/webdav/")'
  - name: "everyone"
    user_agent_regex: "."
    action: "CHALLENGE"
```

To make it easier to start and stop Anubis, create a systemd service file for it:

```{filename="/etc/systemd/system/anubis.service"}
[Unit]
Description="Anubis HTTP defense proxy"

[Service]
ExecStart=/usr/bin/anubis
Restart=always
RestartSec=30s
EnvironmentFile=/etc/anubis/env
LimitNOFILE=infinity
DynamicUser=yes
CacheDirectory=anubis/hks3
CacheDirectoryMode=0755
StateDirectory=anubis/hks3
StateDirectoryMode=0755
ReadWritePaths=/run

[Install]
WantedBy=multi-user.target
```

Tell systemd about the new Anubis service and start it:

```sh
systemctl daemon-reload
systemctl enable anubis
systemctl start anubis
systemctl status anubis
```

## Simple Apache Configuration

The Apache configuration to protect static content is fairly simple.
We have a public-facing HTTPS site that forwards requests
to Anubis.  Anubis sends requests that pass its challenge
to a local, non-public HTTP site that does the actual serving
of files.

![Anubis Diagram](/images/anubis-diagram.png)

To implement this scheme, the following Apache configuration creates two sites:

* the local, non-public HTTP site (`VirtualHost localhost:8083`) that serves files in `/var/www/html`
* the public-facing HTTPS site (`VirtualHost *:443`) that forwards requests to Anubis

{{< callout type="info" >}}
In the following examples, the site configuration file uses Let's Encrypt certificates,
hence the filename `000-default-le-ssl.conf`.  The actual filename may be different in your installation.
{{< /callout >}}

First, the following Apache modules must be enabled using `a2enmod`:

* headers
* proxy
* proxy_http
* proxy_uwsgi

Then add the following line to `/etc/apache2/ports.conf`:

```
Listen 8083
```

Finally, edit the site configuration file as follows:

```{filename="/etc/apache2/sites-enabled/000-default-le-ssl.conf"}
# Local HTTP file server
<VirtualHost localhost:8083>
   ServerAdmin webmaster@localhost
   ServerName www.example.com
   DocumentRoot /var/www/html
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# HTTPS listener that forwards to Anubis
<IfModule mod_proxy.c>
<VirtualHost *:443>
   ServerAdmin webmaster@localhost
   ServerName www.example.com
   DocumentRoot /var/www/html
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
   SSLCertificateFile /etc/letsencrypt/live/www.example.com/fullchain.pem
   SSLCertificateKeyFile /etc/letsencrypt/live/www.example.com/privkey.pem
   Include /etc/letsencrypt/options-ssl-apache.conf

   # Anubis forwarding
   RequestHeader set "X-Real-Ip" expr=%{REMOTE_ADDR}
   RequestHeader set X-Forwarded-Proto "https"
   RequestHeader set "X-Http-Version" "%{SERVER_PROTOCOL}s"
   ProxyPass / http://localhost:8082/
   ProxyPassReverse / http://localhost:8082/
</VirtualHost>

```

## Adding Web Services

Now the tricky part begins.  I had the following web services running
before Anubis, and had to figure out how to configure them after
Anubis:

* [Fossil](https://fossil-scm.org/home/doc/trunk/www/index.wiki)
* [Radicale](https://radicale.org/v3.html)
* [WebDAV](https://en.wikipedia.org/wiki/WebDAV)
* [InfCloud](https://inf-it.com/open-source/clients/infcloud/)
* [Password-protected subdirectories](https://httpd.apache.org/docs/2.4/howto/auth.html)
* [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
* [XBrowserSync](https://www.bloovis.com/fossil/home/marka/fossils/xbs/doc/trunk/README.md)

### Web Services Not Protected by Anubis

Configurations for web services that must not be protected by Anubis are
placed in `/etc/apache2/sites-enabled/000-default-le-ssl.conf` in the `<VirtualHost *:443>`
section.

#### Radicale, VaultWarden, XBrowserSync

The Radicale, Vaultwarden, and XBrowserSync web services are used by non-browser apps, so
they must not be protected by Anubis.  This is fine, because they are password-protected.
They are configured in Apache as reverse proxies.  Place the following lines
before the Anubis proxy lines:

```
   RewriteEngine On
   RewriteRule ^/radicale$ /radicale/ [R,L]
   <Location "/radicale/">
       ProxyPass        http://localhost:5232/ retry=0 upgrade=websocket
       ProxyPassReverse http://localhost:5232/
       RequestHeader    set X-Script-Name /radicale
   </Location>

   ProxyPass /vaultwarden/ http://127.0.0.1:8000/vaultwarden/ upgrade=websocket

   ProxyPass /xbs/ http://127.0.0.1:8090/ upgrade=websocket

```

#### WebDAV

The WebDAV service is used by Joplin, so it must also avoid being protected by
by Anubis.  But WebDAV is served by Apache itself, not by a separate service
via a reverse proxy.  In fact, WebDAV will fail if it is protected by Anubis .
So we need to tell Apache to *not* forward
requests to `/webdav/*` to Anubis.  Do this by placing the following
lines before the Anubis
proxy lines.  The ProxyPass line with the "!" parameter is the magic that prevents it
from being included in the Anubis ProxyPass:

```
   Alias /webdav /var/www/webdav
   <Directory "/var/www/webdav">
       DAV On
       AuthType Basic
       AuthName "webdav"
       AuthUserFile /usr/local/apache/var/.htpasswd
       Require valid-user
   </Directory>
   ProxyPass "/webdav/" "!"
```

Here we are using basic authentication (password protection) for WebDAV.
The password file (AuthUserFile) was created using:

```
htpasswd -c /usr/local/apache/var/.htpasswd username
```

You can use the [litmus](http://www.webdav.org/neon/litmus/) program to test the WebDAV service.
On Debian/Ubuntu, install it using:

```
apt install litmus
```

Then use it to test your WebDAV service:

```
litmus https://www.example.com/webdav/ username password
```

### Web Services Protected By Anubis

The configurations for web services that must be protected by Anubis are
placed in `/etc/apache2/sites-enabled/000-default-le-ssl.conf` in the `<VirtualHost localhost:8083>`
section, after the `DocumentRoot` line.  These services include:

* Password-protected directory
* InfCloud
* Fossil

#### Password-protected Directory

To password-protect a directory (`/var/www/private` in this example),
place the following lines after the `DocumentRoot` line:

```
   Alias /private /var/www/private
   <Directory "/var/www/private">
       AuthType Basic
       AuthName "Restricted Content"
       AuthUserFile /usr/local/apache/var/.htpasswd
       Require valid-user
   </Directory>
```

As in the WebDAV example above, the password file (AuthUserFile) was created using:

```
htpasswd -c /usr/local/apache/var/.htpasswd username
```

#### InfCloud

To protect the InfCloud calendar/contact web app,
place the following lines after the `DocumentRoot` line:


```
   <Directory "/var/www/infcloud">
       AuthType Basic
       AuthName "InfCloud"
       AuthUserFile /usr/local/apache/var/.htpasswd
       Require valid-user
   </Directory>
```

#### Fossil

To protect the Fossil server,
place the following line after the `DocumentRoot` line:


```
   ProxyPass /fossil/ http://127.0.0.1:8080/ upgrade=websocket
```

## Restart Apache

After all of this editing of configuration files, test that the
files have the correct syntax:

```
apachectl -t
```

Then restart Apache and check its status:

```
systemctl restart apache2
systemctl status apache2
```
