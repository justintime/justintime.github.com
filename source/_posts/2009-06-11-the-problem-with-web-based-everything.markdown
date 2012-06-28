---
title: The Problem with Web-based Everything
permalink: /content/2009/06/11/problem-web-based-everything
layout: post
categories:
- Me
- sysadmin
comments: true
sharing: true
footer: true
---
So, I've been tinkering with the free version of [Toodledoo - a web-based GTD
task manager](http://www.toodledo.com/), and I was thinking about upgrading to
a "pro" account. Unfortunately, they had a storm run through last night, which
engaged the generators. When the generators kicked in, something didn't work
right, and power was lost. This in turn caused a database crash, which caused
it to corrupt, and they are still down now.  Here's what their homepage states
right now:  So, here's the story. A big storm went through the city where our
datacenter is located. The datacenter decided to proactively switch to
generators. During the switch, something got screwed up, and the power went
off for a few minutes. As (bad) luck would have it, this caused our database
to get corrupted. We are currently working to bring it back online and
restored from the live backup. The crack team at Rackspace is on the job.
Thanks Rackspace! Unfortunately, the database is so large, that it will take
some time to transfer and verify all the data. Hopefuly not more than a few
hours. We know that this is very bad, and we apologize for any inconvience
that this will cause. Please check the forums when we are back online for a
full report.  Update: Its obviously taking longer than we expected and we are
really sorry for that.  Now, I'm not paying anything for the service, and I'm
fine with the downtime. However, I don't think I'll be upgrading anytime soon
- this outage tells me a few things:

  * They don't use UPS's.
  * They don't use more than one data center.
  * They likely don't manage their own servers.
Again, all of this is fine - it costs money to do all these things, and I
understand the decision to not do it. However, when I pay for software as a
service, I expect the software and the service to be highly available.

