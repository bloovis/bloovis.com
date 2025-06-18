---
title: Enabling fingerprint reader in Linux Mint 9 / Ubuntu 10.04
date: '2010-06-08 00:15:51 +0000'

tags:
- linux
- linux mint
- thinkpad
- ubuntu
---
It looks like the upgrade to the latest Ubuntu is going to keep me busy solving problems for a while.

Today's second problem has to do with the fingerprint reader in the ThinkPad X41.  There's a good source of information [here](http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader_with_ThinkFinger), but there wasn't a definitive set of instructions for Ubuntu 10.04 that actually worked.  Most of the uproar about the fingerprint reader in Ubuntu 10.04 has to do with a bug where the Enter key has to be pressed after swiping your finger.  I couldn't even get to that point; the trouble was getting logins to prompt for a finger swipe.

As per the instructions at ThinkWiki, I installed and configured the required packages from the standard repository (no PPAs):

```
sudo apt-get install thinkfinger-tools libpam-thinkfinger
sudo /usr/lib/pam-thinkfinger/pam-thinkfinger-enable
```

Then I was able to use `tf-tool --acquire` and `tf-tool --verify` to show that the fingerprint device worked.  But I was not able to use `tf-tool --add-user USERNAME` to create a fingerprint file for use by the authentication system; this build of tf-tool did not support that option.  So I had to set things up manually, by acquiring the fingerprint file and placing it in the proper directory, with the proper name, and with the proper permissions:

```
sudo su    # login as root
cd /etc/pam_thinkfinger
tf-tool --acquire USERNAME.bir
chown USERNAME:root USERNAME.bir
chmod 400 USERNAME.bir
```

In all of these commands, substitute your ordinary user name for USERNAME.  After this is done, authentication prompts, either in a terminal (e.g., with sudo) or in X (e.g., the login screen), should ask for either a password or a finger swipe.  Due the known aforementioned bug, it may also be necessary to hit Enter after the swipe.
