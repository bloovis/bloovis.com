---
title: Upgrading from Rails 2.1 to 2.2
date: '2009-02-25 04:32:28 +0000'

tags:
- rails
- ruby
---
I have a small project that I developed at work using Rails 2.1.  After installing the latest version of Rails, 2.2.2, I had to do the following to get my project working again:

* Edit `config/environment.rb` and change the value of RAILS_GEM_VERSION to '2.2.2'.
* Edit `config/environments/development.rb` and comment out the `config.action_view.cache_template_extensions ` line.
* Run `rake rails:upgrade`.  This added a new file, `script/dbconsole`, and modified the following files:
  * `config/boot.rb`
  * `public/javascripts/controls.js`
  * `public/javascripts/dragdrop.js`
  * `public/javascripts/effects.js`
  * `public/javascripts/prototype.js`

