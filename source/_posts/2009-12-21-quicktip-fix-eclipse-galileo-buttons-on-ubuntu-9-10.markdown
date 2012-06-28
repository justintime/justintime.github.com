---
title: "QuickTip: Fix Eclipse Galileo buttons on Ubuntu 9.10"
permalink: /content/2009/12/21/quicktip-fix-eclipse-galileo-buttons-ubuntu-910
layout: post
categories:
- Code
- sysadmin
comments: true
sharing: true
footer: true
---
There's a nasty upstream bug in GTK present in Ubuntu 9.10 that makes Eclipse
Galileo all but unusable -- specifically it makes clicking many buttons with
the mouse just stop working. You can use tab and spacebar to make it work, but
that's not much of a workaround. All you need to do is set an environment
variable before starting Eclipse:

    
    export GDK_NATIVE_WINDOWS=true

