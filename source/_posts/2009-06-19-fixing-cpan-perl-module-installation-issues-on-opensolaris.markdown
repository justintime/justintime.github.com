---
title: Fixing CPAN Perl Module Installation Issues on OpenSolaris
permalink: /content/2009/06/19/fixing-cpan-perl-module-installation-issues-opensolaris
layout: post
categories:
- OpenSolaris
- sysadmin
comments: true
sharing: true
footer: true
---
In OpenSolaris, if you're installing perl modules via CPAN, you might run into
this error:

    
    cc: unrecognized option `-KPIC'
    cc: language ildoff not recognized
    cc: ReadKey.c: linker input file unused because linking not done
    

In order to fix that, edit the file /usr/perl5/5.8.4/lib/i86pc-solaris-
64int/Config.pm, and make the following changes to the existing lines for
'optimize' and 'cccldflags': **UPDATE! Thanks to reader Vesta for his tip. The
original tip I posted will not fix all the issues, for example Apache2::Util
won't install.** This problem occurs because the Sun developers build perl
with the cc from SunStudio, but by default, the first 'cc' found in a user's
path is a symlink to gcc. All you need to do is to install SunStudio, and
prefer it's cc:

    
    
    pfexec pkg install ss-dev
    

Now, edit ~/.profile, and prepend your path with SunStudio's bin directory,
like so:

    
    
    export PATH=/opt/SunStudioExpress/bin/:/usr/gnu/bin:/usr/bin:/usr/X11/bin:/usr/sbin:/sbin
    

You can log out, reboot, source the new .profile, or export a new PATH
variable to make the new settings stick. Now you should be able to install
most any Perl module!

