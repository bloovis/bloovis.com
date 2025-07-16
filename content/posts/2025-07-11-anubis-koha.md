---
title: Blocking Koha Attacks with Anubis
date: '2025-07-11'
tags:
- linux
- software
- koha
- anubis
---

In an [earlier post](/posts/2024-04-05-blocking-koha-attacks/),
I described my attempt to block attacks on our
library's [Koha](https://koha-community.org/) installation.  That attempt
used iptables to block individual attackers.  But this week our Koha
was subject to attacks from nearly 1000 bots, probably out-of-control
AI web scrapers, slowing Koha to a crawl.  The iptables solution would be impractical now, so
instead I installed a new-ish bot blocker called [Anubis](https://anubis.techaro.lol/).
<!--more-->

As a starting point, I used [this article](https://www.koha-support.eu/using-anubis-with-koha/)
about using Anubis with Koha.  But our Koha installation isn't quite a simple
as the one in the article, where the OPAC (user-facing web site)
is bound to port 80.  In our installation, the OPAC is on port 81, and the Intranet (staff client)
is on port 82.  So I had to adapt the article's instructions a bit.

## Anubis Configuration

I installed Anubis from the `...amd64.deb` file in the Assets section of
the latest release [here](https://github.com/TecharoHQ/anubis/releases).
Then I created the Anubis configuration according to the article
linked to above, with only slight changes.  All of the following
commands were run while logged in as root.

In directory `/etc/anubis`, create the following two files:

Create the systemd environment variable file. Note that we are telling Anubis to forward
requests to the unsecured Koha OPAC at port 83; you may want to use a different port,
depending on how Koha is configured (see below).  You should also generate a different key
by using `openssl rand -hex 32`.

```{filename="/etc/anubis/env"}
BIND=localhost:8082
BIND_NETWORK=tcp
DIFFICULTY=4
POLICY_FNAME=/etc/anubis/botPolicies.yaml
TARGET=http://localhost:83
# random, openssl rand -hex 32
ED25519_PRIVATE_KEY_HEX=897077318cbba0b62a6e43494dd69a3485b9a184ebb7b6145d6eecc605ac169d
```

Create the policies file:

```yaml {filename="/etc/anubis/botPolicies.yaml"}
bots:
  - name: "well-known"
    path_regex: "^/.well-known/.*$"
    action: "ALLOW"
  - name: "API"
    path_regex: "^/api/.*$"
    action: "ALLOW"
  - name: "favicon"
    path_regex: "^/favicon.ico$"
    action: "ALLOW"
  - name: "robots-txt"
    path_regex: "^/robots.txt$"
    action: "ALLOW"
  - name: "everyone"
    user_agent_regex: "."
    action: "CHALLENGE"
```

Then create a systemd service file for Anubis:

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

## Apache Configuration Before Anubis

As mentioned above, our Koha installation uses a slightly non-standard port
configuration, with port 81 pointing to the OPAC, and port 82 pointing
to the Intranet.  We're running Apache 2.4 on Debian 10, and we use
Let's Encrypt for https security.

Here are the relevant configuration files as they appeared *before* installing
Anubis, with our domain name changed to example.com, and comments and
other irrelevant information removed.

### 000-default.conf

This file redirects unsecured port 80 to secured port 81 (for the OPAC):

```{filename="/etc/apache2/sites-enabled/000-default.conf"}
<VirtualHost *:80>
   ServerName koha.example.com
   ServerAdmin webmaster@localhost
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
   # Redirect to Koha OPAC
   Redirect permanent / https://koha.example.com:81/
</VirtualHost>
```

### 000-default-le-ssl.conf

This file redirects secured port 443 (the normal https port) to port 81 (for the OPAC):

```{filename="/etc/apache2/sites-enabled/000-default-le-ssl.conf"}
<IfModule mod_ssl.c>
<VirtualHost *:443>
   ServerAdmin webmaster@localhost
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
   SSLCertificateFile /etc/letsencrypt/live/koha.example.com/fullchain.pem
   SSLCertificateKeyFile /etc/letsencrypt/live/koha.example.com/privkey.pem
   Include /etc/letsencrypt/options-ssl-apache.conf
   ServerName koha.example.com
   Redirect permanent / https://koha.example.com:81/
</VirtualHost>
</IfModule>
```

### (koha-instance).conf

Finally, here is the Koha-specific configuration file for
both the OPAC and the Intranet (our Koha instance name is "rpl"):

```{filename="/etc/apache2/sites-enabled/rpl.conf"}
# OPAC
<VirtualHost *:81>
   <IfVersion >= 2.4>
    Define instance "rpl"
   </IfVersion>
   Include /etc/koha/apache-shared.conf
   Include /etc/koha/apache-shared-opac-plack.conf
   Include /etc/koha/apache-shared-opac.conf

   ServerName koha.example.com
   SetEnv KOHA_CONF "/etc/koha/sites/rpl/koha-conf.xml"
   SetEnv MEMCACHED_SERVERS "127.0.0.1:11211"
   SetEnv MEMCACHED_NAMESPACE "koha_rpl"
   AssignUserID rpl-koha rpl-koha

   ErrorLog    /var/log/koha/rpl/opac-error.log
   SSLCertificateFile /etc/letsencrypt/live/koha.example.com/fullchain.pem
   SSLCertificateKeyFile /etc/letsencrypt/live/koha.example.com/privkey.pem
   Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>

# Intranet
<VirtualHost *:82>
   <IfVersion >= 2.4>
    Define instance "rpl"
   </IfVersion>
   Include /etc/koha/apache-shared.conf
   Include /etc/koha/apache-shared-intranet-plack.conf
   Include /etc/koha/apache-shared-intranet.conf
   
   ServerName koha.example.com
   SetEnv KOHA_CONF "/etc/koha/sites/rpl/koha-conf.xml"
   SetEnv MEMCACHED_SERVERS "127.0.0.1:11211"
   SetEnv MEMCACHED_NAMESPACE "koha_rpl"
   AssignUserID rpl-koha rpl-koha

   ErrorLog    /var/log/koha/rpl/intranet-error.log
   SSLCertificateFile /etc/letsencrypt/live/koha.example.com/fullchain.pem
   SSLCertificateKeyFile /etc/letsencrypt/live/koha.example.com/privkey.pem
   Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
```

## Apache Configuration After Anubis

As mentioned in the article linked to above, adding Anubis to Koha
involves redirecting the OPAC to Anubis, with Anubis acting as a
go-between proxy.  As the article states, "[i]n the SSL configuration, we
remove all Koha-specific settings and instead redirect all traffic to
Anubis."  Then Anubis will route the traffic that passes its challenge to the
unsecured Koha OPAC that is accessible only from localhost.

But things are complicated because before we added Anubis, we were
using port 81 as the https port for the OPAC.  For backwards compatibility,
we are forced to put the unsecured OPAC on port 83, and create a configuration for it that
copies the Koha settings from the old port 81 configuration.

Here are the configuration files as they now appear *after*
Anubis has been installed:

### 000-default.conf

In this file, the only thing that has changed is that port 81 has
been removed from the redirection URL:

```{filename="/etc/apache2/sites-enabled/000-default.conf"}
<VirtualHost *:80>
   ServerName koha.example.com
   ServerAdmin webmaster@localhost
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
   # Redirect to Koha OPAC
   Redirect permanent / https://koha.example.com/
</VirtualHost>
```

### 000-default-le-ssl.conf

This file now forwards secured port 443 to Anubis, which is listening
on port 8082:

```{filename="/etc/apache2/sites-enabled/000-default-le-ssl.conf"}
<IfModule mod_ssl.c>
<VirtualHost *:443>
   <IfVersion >= 2.4>
    Define instance "rpl"
   </IfVersion>
   ServerName koha.example.com
   AssignUserID rpl-koha rpl-koha
   ServerAdmin webmaster@localhost
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
   SSLCertificateFile /etc/letsencrypt/live/koha.example.com/fullchain.pem
   SSLCertificateKeyFile /etc/letsencrypt/live/koha.example.com/privkey.pem
   Include /etc/letsencrypt/options-ssl-apache.conf

   # Anubis forwarding
   RequestHeader set "X-Real-Ip" expr=%{REMOTE_ADDR}
   RequestHeader set X-Forwarded-Proto "https"
   ProxyPass / http://localhost:8082/
   ProxyPassReverse / http://localhost:8082/
</VirtualHost>
</IfModule>
```

### (koha-instance).conf

Here is the Koha-specific configuration file for
both the OPAC and the Intranet.  The Intranet is unchanged.
The OPAC now appears on unsecured port 83 and is accessible only
on localhost; this is the OPAC that Anubis uses when it receives
requests redirected to it.  There is also a third VirtualHost
record for port 81, for backwards compatibility with the old
configuration:

```{filename="/etc/apache2/sites-enabled/rpl.conf"}
<VirtualHost localhost:83>
   <IfVersion >= 2.4>
    Define instance "rpl"
   </IfVersion>
   Include /etc/koha/apache-shared.conf
   Include /etc/koha/apache-shared-opac-plack.conf
   Include /etc/koha/apache-shared-opac.conf

   ServerName koha.example.com
   SetEnv KOHA_CONF "/etc/koha/sites/rpl/koha-conf.xml"
   SetEnv MEMCACHED_SERVERS "127.0.0.1:11211"
   SetEnv MEMCACHED_NAMESPACE "koha_rpl"
   AssignUserID rpl-koha rpl-koha
   ErrorLog    /var/log/koha/rpl/opac-error.log
</VirtualHost>

# For compatibility with the old configuration, where port 81 was the OPAC.
<VirtualHost *:81>
   ServerName koha.example.com
   ServerAdmin webmaster@localhost
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined

   SSLCertificateFile /etc/letsencrypt/live/koha.example.com/fullchain.pem
   SSLCertificateKeyFile /etc/letsencrypt/live/koha.example.com/privkey.pem
   Include /etc/letsencrypt/options-ssl-apache.conf

   Redirect permanent / https://koha.example.com/
</VirtualHost>

# Intranet
<VirtualHost *:82>
   <IfVersion >= 2.4>
    Define instance "rpl"
   </IfVersion>
   Include /etc/koha/apache-shared.conf
   Include /etc/koha/apache-shared-intranet-plack.conf
   Include /etc/koha/apache-shared-intranet.conf

   ServerName koha.example.com
   SetEnv KOHA_CONF "/etc/koha/sites/rpl/koha-conf.xml"
   SetEnv MEMCACHED_SERVERS "127.0.0.1:11211"
   SetEnv MEMCACHED_NAMESPACE "koha_rpl"
   AssignUserID rpl-koha rpl-koha

   ErrorLog    /var/log/koha/rpl/intranet-error.log
   SSLCertificateFile /etc/letsencrypt/live/koha.example.com/fullchain.pem
   SSLCertificateKeyFile /etc/letsencrypt/live/koha.example.com/privkey.pem
   Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
```

We need to tell Apache to listen on port 83:

### ports.conf

```{filename="/etc/apache2/ports.conf"}
Listen 80
Listen 81
Listen 82
Listen 83

<IfModule ssl_module>
	Listen 443
</IfModule>

<IfModule mod_gnutls.c>
	Listen 443
</IfModule>
```

Finally, restart Apache:

```sh
systemctl restart apache2
```

Visiting the OPAC in a browser now should bring up the Anubis challenge page for
a few seconds.
