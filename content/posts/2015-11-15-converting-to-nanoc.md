---
title: Converting from Wordpress to nanoc
date: '2015-11-15 13:17:00 +0000'

tags:
- web
- ruby
- nanoc
---

For seven years this site has been using Wordpress as its main engine.  There are
a number of advantages to using this feature-rich piece of PHP, but I finally decided
that the disadvantages were enough for me to switch to a static web site generator called
[nanoc](http://nanoc.ws/). <!--more--> Some of these disadvantages were:

* Slower than static HTML
* Frequent need to update to latest Wordpress for security reasons
* Occasional emails from Wordpress about comment spam that needed to be marked as such
* Inability to use my favorite editor to write posts
* Posts are a funny mix of manually and automatically generated HTML
* Need to have an internet connection to write posts

Using nanoc to generate the site has these advantages:

* Very fast serving of pages
* Less storage and CPU usage on the [server](http://nearlyfreespeech.net/), which should lower hosting costs
* Write posts and view the site on a local machine, even without internet connectivity
* Use any editor to write all aspects of the site
* Use [git](https://git-scm.com/) to do versioning and history
* Write posts in Markdown instead of HTML
* All content, including so-called static pages, not just blog posts, will have a consistent appearance

This site has now been converted to use nanoc.  In this effort, I was helped by
the following:

* Dave Clark's information on [basic blog setup](http://clarkdave.net/2012/02/building-a-static-blog-with-nanoc/) using nanoc's blogging features
* Jakub Chodounsk&yacute;'s information on implementing a [search feature](https://chodounsky.net/2015/05/14/full-text-search-on-static-website/)

The one feature that has been lost in the conversion is commenting.  Due to this site's
very low popularity, this is not a great loss.  If you would like to comment on a posting,
please send me a private email (see the About/Contact link to the right) and I'll update
the posting based on your input.

I'll leave the Wordpress engine running for a month or so, so that links on other
sites will not break immediately.
