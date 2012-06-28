---
title: Tracking Drupal's Outbound HTTP Requests using tcpdump
permalink: /content/2010/03/11/tracking-drupals-outbound-http-requests-using-tcpdump
layout: post
categories:
- Drupal
- Drupal Planet
- 400ms average), but on a homepage displaying 25 nodes, that adds
comments: true
sharing: true
footer: true
---
While working on tweaking performance for a client, I was able to
shave 7 seconds of PHP execution time time off the homepage load.
The cause was eventually tracked down to calls out to TinyURL for
every node being rendered. The core problem came from the
[service links](http://drupal.org/project/service_links) module. We
were able to fix it by disabling short URL's in the module, but the
problem has been addressed in the current pre-release 2.x branch by
using caching. We might have ended up discovering this by disabling
module after module one at a time, but that would have taken
forever. In today's world of API's and social media, it's very
common for a module to make calls to outside websites. However,
care should be taken by the module authors when coding in these
features. In our example, each call to TinyURL was fairly fast (300
- 400ms average), but on a homepage displaying 25 nodes, that adds
over 7 seconds page load time. Think of the impact if TinyURL
experienced a large slowdown, or even an outage? As far as I know,
Drupal doesn't give you a way out of the box to track such
requests. However, using the tcpdump binary which is available on
virtually all Unix variants, we can see exactly what's happening.
Note that you need root access to run tcpdump. Let's say that the
IP address of your primary interface is 10.0.0.1. By using this
tcpdump command, we can see all outbound HTTP and HTTPS requests in
real time:
    tcpdump src host 10.0.0.1 and dst port 80 or dst port 443

If you don't get any traffic after a few seconds, go hit your
/cron.php page - this should generate some traffic like this for
you to see:
Here we can see that our host is making a bunch of outbound
requests to master.drupal.org. This is because the "Update Status"
module is checking to see what upgrades are available for us. What
if you see traffic and don't know what module is causing it? grep
to the rescue! In order to find out which module was making the
calls to TinyURL, we ran the following command:
    grep -R 'tinyurl.com' /path/to/drupal/sites/all/modules/\*

This returned one hit, from
/path/to/drupal/sites/all/modules/service\_links/service\_links.module.
By disabling the short links feature within the module we decreased
page load time by 7 seconds!


