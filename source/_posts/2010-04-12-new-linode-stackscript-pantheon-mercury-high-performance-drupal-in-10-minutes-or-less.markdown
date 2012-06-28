---
title: "New Linode StackScript: Pantheon Mercury (High Performance Drupal in 10 Minutes or Less)"
permalink: /content/2010/04/12/new-linode-stackscript-pantheon-mercury-high-performance-drupal-10-minutes-or-less
layout: post
categories:
- Drupal
- Drupal Planet
- Linode
comments: true
sharing: true
footer: true
---
For those who might not know, [Pantheon
Mercury](http://www.getpantheon.com/mercury/what-is-mercury) is:

> ... a drop-in replacement for your Drupal website hosting service that
delivers break-through performance. Mercury can serve two-hundred times more
pages per second and generate pages three times faster than standard hosting
services.

Mercury achieves this by using open-source technologies like so many
ingredients of a complex dish - a little [Varnish](http://varnish-
cache.org/wiki/LoadBalancing) here, a dash of
[Memcached](http://memcached.org/) there, a hint of [the Alternative PHP
Cache](http://php.net/manual/en/book.apc.php), a healthy dose of
[Tomcat](http://tomcat.apache.org) and [Solr](http://lucene.apache.org/solr/),
all based upon the [Pressflow](http://fourkitchens.com/pressflow-makes-drupal-
scale) distribution of [Drupal](http://drupal.org). None of it is anything you
couldn't do yourself -- many before [Chapter
Three](http://www.chapterthree.com) had done it actually. However, they were
the first to tie it all together using
[BCFG2](http://trac.mcs.anl.gov/projects/bcfg2), and release an Amazon EC2 AMI
image of it. As word spread, many liked the idea of Mercury, but wanted to
brew their own non-EC2 instance. While they [posted a wiki
article](http://groups.drupal.org/node/50408) on how to do it yourself, they
went to work on native support for [RackSpace](http://www.rackspace.com). When
I read [Josh Koenig](http://www.chapterthree.com/blog/josh_koenig)'s post on
the
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
blog stating [he wanted to bring Mercury to
Linode](http://blog.linode.com/2010/02/09/introducing-
stackscripts/#comment-40480?r=c4f79463ba583ec1f15e3307190bda4bda9d65df), I
made a mental note. Some time passed, I became much more involved in Drupal,
and I decided to volunteer to write the [StackScript](http://www.linode.com/stackscripts/view/?StackScriptID=353&r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
. Josh said okay, and put me in touch with [Greg
Coit](http://www.chapterthree.com/blog/greg_coit), their resident sysadmin,
and we went to work. Fast forward a couple weeks, and we've announced a beta!
[The StackScript](http://www.linode.com/stackscripts/view/?StackScriptID=353&r=c4f79463ba583ec1f15e3307190bda4bda9d65df) is quite complete - it supports
Ubuntu Jaunty and Karmic, and can use the current stable branch or the soon-
to-be-released 1.1 development branch. Once Lucid is released, we'll test to
make sure it works there as well. I want to thank Greg for all his help. We
found some bugs in Ubuntu, some quirks in the memcached init script, and fixed
many bugs and added some features to [their BCFG2 bazaar
repo](https://edge.launchpad.net/pantheon/bcfg2). Thanks also go out to Josh
for his oversight and guidance. It was a great time, a great learning
experience, and I came out of it with some new colleagues (and some free beers
at [DrupalConSF](http://sf2010.drupal.org)). Feel free to [read up on my
experiences with Linode](http://www.sysadminsjourney.com/category/linode), and
if you like what you see, click on [one of the many links to
Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
from my blog. If you sign up and stay a customer for 90 days (trust me, you
will), I'll get $20 credited to my account. Feel free to comment below about
the StackScript and let me know about any issues you might find.

