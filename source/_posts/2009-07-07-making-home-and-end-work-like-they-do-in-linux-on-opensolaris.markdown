---
title: Making Home and End Work Like They Do In Linux on OpenSolaris
permalink: /content/2009/07/07/making-home-and-end-work-they-do-linux-opensolaris
layout: post
categories:
- OpenSolaris
- sysadmin
comments: true
sharing: true
footer: true
---
In OpenSolaris, the xterm bindings aren't there for the End and Home keys -
they do nothing. Yes, I know, Ctrl+a and Ctrl+e do the same things, but my
laziness has turned into muscle memory. Here's how to fix it:  As your normal
user, run the following:

    
    
    mkdir /tmp/foo
    env TERMINFO=/usr/share/lib/terminfo /bin/infocmp xterm > /tmp/foo/xterm.ti
    echo ' knp=\E[6~, kpp=\E[5~, kend=\EOF, khome=\EOH, '  >> /tmp/foo/xterm.ti
    env TERMINFO=/tmp/foo /bin/tic -v /tmp/foo/xterm.ti
    cd /usr/share/lib/terminfo/x/
    pfexec cp xterm xterm.orig
    pfexec cp /tmp/foo/x/xterm xterm.new
    pfexec cp xterm.new xterm
    

Now your home and end keys will behave like your used to in Linux! All of this
was pretty much copied and pasted from [http://tech.groups.yahoo.com/group/sol
arisx86/message/20027](http://tech.groups.yahoo.com/group/solarisx86/message/2
0027) - thanks to Juergen Keil for the tip!

