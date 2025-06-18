---
title: Installing and using a new Ruby on Linux Mint 17
date: '2015-12-15 05:48:00 +0000'

tags:
- linux
- linux mint
- ruby
- ubuntu
---
Linux Mint 17 (and its parent, Ubuntu 14.04) ships with Ruby 2.0.0.  This is
a pretty old version of the language, and recent versions, especially 2.2,
have numerous performance improvements.  Fortunately, it's easy to install
and use the latest Ruby, <!--more--> thanks to a couple of shell script packages
by the github user [Postmodern](https://github.com/postmodern).

### ruby-install

The first step is to build and install a new Ruby, using the appropriately
named [ruby-install](https://github.com/postmodern/ruby-install).  Obtain
this script using these commands:

    git clone https://github.com/postmodern/ruby-install.git
    cd ruby-install
    sudo make install

Then it's a simple matter to install the latest Ruby:

    sudo ruby-install ruby

You can install other versions of Ruby besides the latest by specifying a version
number.  All of the installed Rubies will live alongside each other
in `/opt/rubies`.  But how do you select and use a particular version of
ruby?  That's where chruby comes in.

### chruby

The [chruby](https://github.com/postmodern/chruby) shell script package is
a lightweight tool that allows you to switch between your installed Rubies
at any time.  Obtain it using these commands:

    git clone https://github.com/postmodern/chruby.git
    cd chruby
    sudo make install

Then add the following line to both your own .bashrc and root's .bashrc:

    source /usr/local/share/chruby/chruby.sh

The next time you start an interactive shell, chruby will scan `/opt/rubies` for installed
Rubies.  You can list the available Rubies using:

    chruby

Then you can select one of the Rubies.  For example:

    chruby ruby-2.2.3

This will alter some environment variables (including PATH) so that the selected
Ruby and related programs will be used subsequently.

### Gems

It appears that most Ruby users are interested only in Rails, and will probably
use bundles to install the gems required by their application.  But other Ruby
programs, such as the excellent email client [sup](http://supmua.org/), may need
to be installed using system-wide gems.  In this case, you can install the required
gems as root after selecting the appropriate version of Ruby:

    sudo su
    chruby ruby-2.2.3
    gem install ...
