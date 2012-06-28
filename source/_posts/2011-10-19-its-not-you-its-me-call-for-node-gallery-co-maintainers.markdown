---
title: "It's not you, it's me: Call for Node Gallery co-maintainers"
permalink: /content/2011/10/19/its-not-you-its-me-call-node-gallery-co-maintainers
layout: post
categories:
- Drupal
- Drupal Planet
comments: true
sharing: true
footer: true
---
There's only a certain amount of bandwidth in a person's day. As you get
older, that bandwidth seems to become more and more constrained. Kids are
extreme bandwidth hogs :) Over the years I've found that I have enough
bandwidth in my life to deal with one obsession that's not part of my day job
at any given time. For the last couple years, that obsession has been with
[Drupal](http://drupal.org) and specifically with [Node
Gallery](http://drupal.org/project/node_gallery). In my very biased opinion,
it's the most user-friendly and integrated gallery experience you can have
with Drupal 6.x. Also IMHO, there's a huge void in Drupal 7 with respect to
butt-kicking gallery modules, one that's begging to be filled with a Node
Gallery 7.x branch. But I just can't bring myself to that one simple git
command. I've had several changes at work in the past year, and I'm no longer
working with Drupal and PHP on a regular basis. I've become enthralled with
Puppet as of late, and that's proven to be the gateway drug to the devops
movement for me. I'm reading books on Kanban, learning a bit of Ruby, building
deployment pipelines, and soaking up anything I can on devops. It seems
sysadmins who can code really do have a place in the world, and it appears to
be in devops. It's not burnout, it's simply a matter of prioritization on
demands for a limited resource. There's just no time left over for Drupal
anymore. Back to the point of this post -- Node Gallery needs a co-maintainer
who can take the module into the 7.x branch. The recently released 6.x-3.x
branch has proven to be quite stable, and would likely require only very
minimal maintenance. You can take it for a spin on the [demo
site](http://ng3demo.sysadminsjourney.com), or read all about it's features on
the [project page](http://drupal.org/project/node_gallery). Here's some quick
points:

  * It has a reported user base of just under 3,800 sites, which puts it at right around #400 on the top modules list.
  * It has a great user base that's proven to be active in the issue queue. Many of the support requests have been resolved by members of the community whom have never written a line of code. It has a strong German presence, and has been translated.
  * It integrates very tightly with [Views](http://drupal.org/project/views), and supports bulk uploading with [Plupload](http://drupal.org/project/plupload). It has it's own access module in [Node Gallery Access](http://drupal.org/project/node_gallery_access), as well as a handful of other modules (all of which are listed on the [project page](http://drupal.org/project/node_gallery)) it integrates with very well.
  * It's been engineered to perform well from the start. If your server can handle the load of 100,000 nodes, there's no reason it should be able to handle 100,000 Node Gallery image nodes -- even if those are all in one gallery.
  * The administration UI aims to provide a working gallery setup out-of-the-box that works for 90% of the users, yet provide enough buttons and knobs for the remaining 10% to be able to tweak what they need.
  * It runs the gamut of technologies in Drupal; making use of caching, Views integration, jQuery and jQuery UI, CCK, Node Access, Batch API, etc.
  * What differentiates Node Gallery from most other gallery modules is that each and every image in a gallery isn't just a field, it's an entire node. This opens up huge possibilities for interactions with other contrib modules. The original reason for me selecting Node Gallery was because it was the only way I could sell individual images using Ubercart.
Who I'm looking for:

  * This module is likely a bit complex for someone who's never maintained a module before. If you've maintained your own Drupal module (either privately or on d.o), take a look at the code and make sure you can understand what's going on.
  * Drupal 7 API experience is a must; experience in migrating D6 modules to D7 is a plus.
  * Ideally, you need to have an "itch that needs scratching" -- in other words, you should probably have a need for an image gallery.
If you'd like to take a crack at bringing Node Gallery to Drupal 7, [contact
me](http://drupal.org/user/99149/contact), or [file an
issue](http://drupal.org/node/add/project-issue/node_gallery) in the issue
queue.

