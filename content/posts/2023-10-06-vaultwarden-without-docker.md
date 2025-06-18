---
title: Installing Vaultwarden Without Docker
date: '2023-10-06 06:00:00 +0000'

tags:
- linux
- software
---

*Update*: the newer version of the Bitwarden Android app requires
a newer Vaultwarden.  This required some changes in the following procedure,
mainly in using the "latest" docker image instead of the "alpine" image,
and installing the required `libmariadb3` and `libpq5` packages.

I recently switched from using LastPass to [BitWarden](https://bitwarden.com/) as my password manager.
LastPass has always worked well enough in browsers, but there was no easy
way to get it to work on so-called "smart" devices like Android phones, and there
was no Linux application for managing passwords.  I'd been using
[KeePassXC](https://keepassxc.org/) on Linux in parallel with LastPass, but keeping
the two synced up manually was an error-prone annoyance.

Bitwarden solves these problems by providing Linux and Android applications, a web interface,
and browser extensions that synchronize with each other.  But using it still
means being dependent on a third-party service, as with LastPass, and that makes me
uncomfortable.  I have my own domain and Linux server for it, and I've
been using it to self-host this blog, an email server, an RSS reader, and Git repositories, so
I thought it would be a natural next step to host a Bitwarden server
there too.

Fortunately, there's a lightweight Bitwarden-compatible server called
[Vaultwarden](https://github.com/dani-garcia/vaultwarden)
that can be used for self-hosting.  But like Bitwarden
and seemingly every other web service these days, it normally requires Docker
for installation, which I'm trying to avoid.

I understand the motivation behind Docker: it's a clever
way to avoid dependency and build problems in trying to get software to
work on a multitude of different Linux distributions.  But to this old-school
Linux admin, it seems like a terribly wasteful system.  Each application
using Docker has to package all of its dependencies -- both libraries and
related application problems -- into a Docker image.  It's as if each
program comes with multiple copies of its own user-space operating systems.

So I looked for a way to install Vaultwarden without Docker, and I
came across [this forum posting](https://www.reddit.com/r/selfhosted/comments/t6ilc2/can_i_install_vaultwarden_on_a_proxmox_lxc/).
The instructions posted by the user sockrocker were nearly perfect,
with one tiny exception: the `web-vault` directory has to be
moved to `/var/lib/vaultwarden`, not `/opt/vaultwarden`.

## Install Vaultwarden

For completeness, here is what I did to install Vaultwarden on
my server.  All of these commands should be performed as root,
or prefixed with `sudo`.

First, create a directory to store the docker image temporarily:

    mkdir vw-image
    cd vw-image

Obtain the script for extracting the needed pieces of the Docker image:

    wget https://raw.githubusercontent.com/jjlin/docker-image-extract/main/docker-image-extract
    chmod +x docker-image-extract

Extract the Vaultwarden Docker image:

    ./docker-image-extract vaultwarden/server:latest

Create directories where Vaultwarden will be stored on the server:

    mkdir /opt/vaultwarden
    mkdir /var/lib/vaultwarden
    mkdir /var/lib/vaultwarden/data

Create a vaultwarden user and make the Vaultwarden data owned by it:

    useradd vaultwarden
    chown -R vaultwarden:vaultwarden /var/lib/vaultwarden

Move the Vaultwarden server program and data to their final destinations:

    mv output/vaultwarden /opt/vaultwarden
    mv output/web-vault /var/lib/vaultwarden

If things have gone well, remove the unnecessary bits:

    rm -Rf output
    rm -Rf docker-image-extract

Install two packages required by Vaultwarden:

    apt install libmariadb3
    apt install libpq5

## Configure Vaultwarden

Create the hash for a Vaultwarden admin password:

    /opt/vaultwarden/vaultwarden hash

You will be prompted for a password twice.  Save the resulting output somewhere.

Create the file `/var/lib/vaultwarden/.env` with the following contents,
substituting your own user name, domain, and SMTP details:

    DOMAIN=https://www.example.com/vaultwarden/
    ORG_CREATION_USERS=user@example.com
    ADMIN_TOKEN='<hash produced by vaultwarden hash earlier>'
    SIGNUPS_ALLOWED=false
    SMTP_HOST=smtp.example.com
    SMTP_FROM=vaultwarden@example.com
    SMTP_FROM_NAME=Vaultwarden
    SMTP_PORT=587          # Ports 587 (submission) and 25 (smtp) are standard without encryption and with encryption via STARTTLS (Explicit TLS). Port 465 is outdated and us>
    SMTP_SSL=true          # (Explicit) - This variable by default configures Explicit STARTTLS, it will upgrade an insecure connection to a secure one. Unless SMTP_EXPLICIT_>
    SMTP_EXPLICIT_TLS=false # (Implicit) - N.B. This variable configures Implicit TLS. It's currently mislabelled (see bug #851) - SMTP_SSL Needs to be set to true for this o>
    SMTP_USERNAME=user@example.com
    SMTP_PASSWORD=mysmtppassword
    SMTP_TIMEOUT=15
    # Change the following back to true to allow login on the web.
    WEB_VAULT_ENABLED=false
    LOG_FILE=/var/lib/vaultwarden/vaultwarden.log

Create the file `/etc/systemd/system/vaultwarden.service` with the following contents:

    [Unit]
    Description=Bitwarden Server (Rust Edition)
    Documentation=https://github.com/dani-garcia/vaultwarden
    After=network.target

    [Service]
    User=vaultwarden
    Group=vaultwarden
    EnvironmentFile=/var/lib/vaultwarden/.env
    ExecStart=/opt/vaultwarden/vaultwarden
    LimitNOFILE=1048576
    LimitNPROC=64
    PrivateTmp=true
    PrivateDevices=true
    ProtectHome=true
    ProtectSystem=strict
    WorkingDirectory=/var/lib/vaultwarden
    ReadWriteDirectories=/var/lib/vaultwarden
    AmbientCapabilities=CAP_NET_BIND_SERVICE

    [Install]
    WantedBy=multi-user.target

Now you should be able to start the Vaultwarden service and check its status:

    systemctl enable vaultwarden
    systemctl start vaultwarden
    systemctl status vaultwarden | less

The status should say that vaultwarden is running and that it is listening
at `http://127.0.0.1:8000`.

## Configure Apache

Now we have to set up Apache as a reverse proxy, so that it will provide
SSL protection to Vaultwarden, whose internal web server, Rocket, does
not support SSL by default.  I'm assuming that you already have SSL implemented
on your Apache server, perhaps by using Let's Encrypt, and that your
base web site URL is `https://www.example.com/` for illustration purposes.

First, enable the proxy module:

    a2enmod proxy_http

Tell Apache how to redirect the URL `/vaultwarden` from your base web site to
Vaultwarden.  Do this by adding a single line to the `<VirtualHost *:443>`
section of your Apache site configuration.  If you used
Let's Encrypt to obtain your SSL certificates, this configuration file might be at
`/etc/apache2/sites-enabled/000-default-le-ssl.conf`.  The line you
need to add looks like this:

    ProxyPass /vaultwarden/ http://127.0.0.1:8000/vaultwarden/ upgrade=websocket

Restart Apache and check its status:

    systemctl restart apache2
    systemctl status apache2

If all went well, you should be able to visit the admin page of your Vaultwarden site by
going to this URL in a browser:

    https://www.example.com/vaultwarden/admin

You will be prompted for a password, so enter the password you used earlier
when prompted by `vaultwarden hash`.  The configuration page should now
appear.

## Test SMTP

You'll want to make sure that your SMTP settings are correct.  To do this,
click on SMTP Email Settings on the configuration page, fill in your
email address in the Test SMTP form, and click on Send test email.

## User Signup

If, like me, you are installing Vaultwarden for personal use,
it is probably best for security purposes to disallow new signups
in the general settings of the configuration page.  However, you
can send yourself (or trusted friends) an email invitation to sign up.
Find this option in the Users tab; at the bottom of the page is
an Invite User form.

## User Login

When you receive the signup invitation email, you'll can respond to
the invitation in a web browser.  Choose a lengthy, secure password.

(Note: if the Brave browser hangs showing a spinning wheel when you try
to log into the Vaultwarden web interface, it might be due to interference
from browser extensions.  Try removing the tampermonkey and BypassPaywalls
extensions and clearing the browser cache.)

Once you log in to Vaultwarden, you can now import your Bitwarden vault.
First export the vault as a JSON file in the Bitwarden 
browser extension, then import it into Vaultwarden using
the web interface.

To use the Vaultwarden vault in the Bitward browser extension,
log out of the extension in Settings / Account / Log Out.
Then you'll need to create a new account in the extension.  To the right
of "Logging in on:", select "self-hosted" from the drop-down menu.
You'll be prompted for the URL of Vaultwarden, which should
be `https://www.example.com/vaultwarden/`, using the examples above.
A similar process can be used in the Linux Bitwarden app to switch
to the Vaultwarden vault.

## SELinux

An alert reader has informed me that the following things need to be done
if you're using SELinux:

    semanage fcontext -a -t bin_t '/opt/vaultwarden/vaultwarden'
    restorecon -RFv /opt/vaultwarden/vaultwarden
    setsebool -P httpd_can_network_connect on

I don't use SELinux, so I'm unable to try this myself.
