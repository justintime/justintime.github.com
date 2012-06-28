---
title: Fixing Metacity's Window Placement on Dual Head Setups on OpenSolaris
permalink: /content/2009/06/16/fixing-metacitys-window-placement-dual-head-setups-opensolaris
layout: post
categories:
- OpenSolaris
- sysadmin
comments: true
sharing: true
footer: true
---
It took me a few minutes to get dual-head working on OpenSolaris, but once I
did, I immediately found something that greatly annoyed me. Every new window I
opened would launch in the middle of the two heads (half of it on one monitor,
the other half on the other monitor). Also, maximizing a window made it
stretch across both monitors.  It turns out this bug made it just in time for
the OpenSolaris 2009.06 release. To fix the issue, you have to download a
patched metacity binary [referenced in this bug
report](http://defect.opensolaris.org/bz/show_bug.cgi?id=8748). Download the
binary, then run the following:

    
    
    pfexec cp /usr/bin/metacity /usr/bin/metacity.orig
    pfexec cp metacity /usr/bin/metacity
    /usr/bin/metacity --replace
    

Now, metacity should behave itself. Hopefully the devs will push out an update
that resolves this soon.

