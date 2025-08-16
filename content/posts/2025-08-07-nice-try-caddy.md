---
title: Nice Try, Caddy
date: '2025-08-07'
tags:
- linux
- software
- anubis
- apache
- caddy
- lighttpd
---

I recently became aware of [Caddy](https://caddyserver.com/),
a relative newcomer (compared to Apache)
in the field of web servers.  It had a number of attactive features: a single
executable, easy-to-understand configuration language, and automatic SSL
using Let's Encrypt.  I gave it a good try as an Apache replacement, but
it failed in two areas: Anubis and WebDAV.
<!--more-->

## Anubis

At first glance, Caddy seemed great.  I was able to quickly cobble together
a configuration that would serve the static files of this blog, along
with reverse proxies for the other web services that I use, like Radicale,
Fossil, and XBrowserSync.

But when it came time add [Anubis](https://anubis.techaro.lol/)
to the mix, I failed to get a working
system.  I was using Caddy for two sites: the public-facing HTTPS site,
and the localhost HTTP site that actually served files, with Anubis
in between these two.  This configuration was working perfectly with
Apache, but with Caddy, I would always get back a zero-length web page
after the Anubis challenge passed.

Apparently, the standard way to get Anubis to work with Caddy is to
use Docker to run two entirely separate instances of Caddy.  But I was
trying to get this all to work without Docker.  I ran a number
of workaround tests in an attempt to run two instances of Caddy from terminal
sessions, even using a different `storage file_system` directive
for the second Caddy, in case sharing storage between the two was
somehow a problem.  But nothing worked; I was still getting zero-length
web ages.

Then I hit on the idea of using a different server for the backend, i.e.,
the localhost static file server.  I brought up [lighttpd](https://www.lighttpd.net/),
and configured it to serve `/var/www/html` from `localhost:8083`.  Now things were
working.  Caddy handled HTTPS for the public site, and lighttpd
handled the static files.  I was also able to use Caddy's `reverse_proxy`
for my various web services.

## WebDAV

Then I remembered that I wanted to use WebDAV for [Joplin](https://joplinapp.org/)
synchronization.  I used xcaddy to build caddy with the
[webdav plugin](https://github.com/mholt/caddy-webdav).  Then I started
Caddy with this configuration for my existing webdav directory:

```
handle_path /webdav/* {
	root /var/www/webdav
	basic_auth {
	  joeuser <very long authentication string>
	}
	file_server
	webdav
}
```

I also made sure that the directory `/var/www/webdav` was
accessible to Caddy:

```
chown -R caddy:caddy /var/www/webdav/
```

Things seemed OK for a simple test, fetching a file from the webdav directory
using a URL like `https://www.example.com/webdav/webdav-testfile.txt`.  This
exact URL worked on Apache, and it was working on Caddy.  That seemed promising.
But Joplin was unhappy, complaining that it couldn't find `Joplin/locks`:

```
Error: href /Joplin/locks/ not in baseUrl https://www.example.com/webdav/Joplin
nor relativeBaseUrl /webdav/Joplin
```

That was obviously wrong. Why were there two `Joplin` strings in there?
I tried adding this line to the Caddy configuration for webdav:


```
uri strip_prefix /webdav
```

I had used a similar trick for Radicale, but it didn't work here, and I wasn't surprised,
because now my previous simple test with `webdav-testfile.txt` didn't work.  Joplin
gave the same error as before.

Despite my misgivings about this, in Joplin's settings I removed the suffix `/Joplin` from
its WebDAV URL, and after I let it go through with its "sync target needs to be
upgraded" restart, it now gave the same error, but without the `/Joplin` suffix.

```
href /locks/ not in baseUrl https://www.example.com/webdav
nor relativeBaseUrl /webdav
```

This obviously meant that changing Joplin's configured WebDAV URL was a mistake.

As an extra check, I ran [litmus](http://www.webdav.org/neon/litmus/)
against the Caddy WebDAV implementation, 
and there were many errors that didn't occur when I ran the same test
on Apache:

```
% litmus https://www.example.com/webdav/ joeuser mypassword
-> running `basic':
 0. init.................. pass
 1. begin................. pass
 2. options............... pass
 3. put_get............... pass
 4. put_get_utf8_segment.. pass
 5. put_no_parent......... pass
 6. mkcol_over_plain...... pass
 7. delete................ pass
 8. delete_null........... pass
 9. delete_fragment....... pass
10. mkcol................. pass
11. mkcol_again........... pass
12. delete_coll........... pass
13. mkcol_no_parent....... pass
14. mkcol_with_body....... pass
15. finish................ pass
<- summary for `basic': of 16 tests run: 16 passed, 0 failed. 100.0%
-> running `copymove':
 0. init.................. pass
 1. begin................. pass
 2. copy_init............. pass
 3. copy_simple........... FAIL (simple resource COPY:
409 Conflict)
 4. copy_overwrite........ FAIL (COPY-on-existing with 'Overwrite: F' MUST fail with 412 (RFC4918:10.6):
409 Conflict)
 5. copy_nodestcoll....... pass
 6. copy_cleanup.......... pass
 7. copy_coll............. FAIL (collection COPY `/webdav/litmus/ccsrc/' to `/webdav/litmus/ccdest/': 403 Forbidden)
 8. copy_shallow.......... FAIL (MKCOL on `/webdav/litmus/ccsrc/': 405 Method Not Allowed)
 9. move.................. FAIL (MOVE `/webdav/litmus/move' to `/webdav/litmus/movedest': 403 Forbidden)
10. move_coll............. FAIL (collection COPY `/webdav/litmus/mvsrc/' to `/webdav/litmus/mvdest2/', depth infinity: 403 Forbidden)
11. move_cleanup.......... pass
12. finish................ pass
<- summary for `copymove': of 13 tests run: 7 passed, 6 failed. 53.8%
See debug.log for network/debug traces.
```

After all this trouble, I had to abandon Caddy and revert back to Apache.
Either I'm not smart enough to get it work, or it's not quite ready to do
everything that Apache can.
