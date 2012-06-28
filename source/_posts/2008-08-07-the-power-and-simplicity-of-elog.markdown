---
title: The Power and Simplicity of ELOG
permalink: /content/2008/08/07/power-and-simplicity-elog
layout: post
categories:
- Reviews
- sysadmin
comments: true
sharing: true
footer: true
---
Follow the jump to read more about [ELOG](https://midas.psi.ch/elog/), the
best little logbook available!  When I read [the LifeHacker article about how
to simplify troubleshooting with a ChangeLog](http://lifehacker.com/399919
/simplify-troubleshooting-with-a-change-log), I immediately thought about one
of my favorite webapps - [ELOG](https://midas.psi.ch/elog/). Written by Stefan
Ritt, ELOG aims to be simple, self-contained, performant, and extendable. It
achieves all of these goals and surpasses them. ELOG is written in C, and is
it's own webserver. No need to run Apache, it's got it's own. It's single
threaded, but for what it is, one thread is enough. We use it to keep track of
our servers at work, we have a ServerLog logbook. We also use it as a Change
Request management tool. It has done both for us without a hiccup, let alone a
crash in the two years we've used it. A feature request I made to Stefan was
implemented that same week! Anyways, if you're looking for an application to
log entries of data over time, look no further than
[ELOG](https://midas.psi.ch/elog/)!

