---
title: Installing Rails on SLED
date: '2008-05-14 11:52:34 +0000'

tags:
- ruby
- software
- suse
---
SUSE Linux Enterprise Desktop 10 SP 1 (or SLED), as installed on the ThinkPad R61, is based on SUSE Linux 10.1.  This distro includes a somewhat old version of [Ruby on Rails](http://www.rubyonrails.org/), a popular web development framework.  I wanted to use the latest version of Rails, but before I could do that, I needed to build and install the latest stable versions of Ruby and Rubygems (Ruby's package management system).  This wasn't too difficult, but there were a few non-obvious steps along the way.  (All of the steps described here were performed while logged in as the root user.)

I first used the Software Management tool in Yast2 to delete the existing Ruby packages I'd previously installed.  Then I downloaded the source for ruby 1.8.6 [here](http://rubyforge.org/frs/?group_id=426).  Before building it, I had to unset the RUBYOPT environment variable, which was set to "rubygems" by SUSE.  Then I built the basic Ruby interpreter using these commands:
```
./configure
make
make install
```

This process didn't build or install the tk extension, which I use in a couple of my Ruby scripts to build simple GUIs.  To build that, I first needed to use the Software Management tool in yast2 to install the tcl-devel and tk-devel packages.  Then I built and installed the tk extension using these commands:

```
cd ext/tk
ruby extconf.rb
make install
cd tkutil
ruby extconf.rb
make install
```

Then I downloaded the latest version (1.1.1) of Rubygems  [here](http://rubyforge.org/frs/?group_id=126), and installed it using this command:

```
ruby setup.rb
```

Finally, I was able to install the latest Rails using  Rubygems:

```
gem install rails
```

This installed all of the packages that Rails depends on, such as ActiveRecord.
