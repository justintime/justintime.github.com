---
title: Using the Sun StorageTek A1000 under Solaris 10
permalink: /content/2009/05/26/using-sun-storagetek-a1000-under-solaris-10
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
We have an old Sun StorageTek A1000 sitting around that we use as scratch
space for our Amanda backups. Sure, it's old and slow, but it works very well
for what we use it for. After upgrading to Solaris 10, the mountpoints worked,
but I was getting a lot of complaints when loading the rdriver module from the
Raid Manager application.  Upon reboot into Solaris 10, I got a huge amount of
these messages spewed to the console:

    
    
    May 21 23:24:47 myhost krtld: [ID 819705 kern.notice] /kernel/drv/sparcv9/rdriver: undefined symbol
    May 21 23:24:47 myhost krtld: [ID 826211 kern.notice] 'dev_get_dev_info'
    May 21 23:24:47 myhost krtld: [ID 472681 kern.notice] WARNING: mod_load: cannot load module 'rdriver'
    May 21 23:24:47 myhost genunix: [ID 370176 kern.warning] WARNING: forceload of drv/rdriver failed
    

It turns out that the A1000 was EOL before the Solaris 10 release, so I guess
I can't blame Sun for that. But, thanks to [a post over on the Sun
forums](http://forums.sun.com/thread.jspa?threadID=5095232), everything still
works with some configuration. First, you need to tell the system not to load
the rdriver and rdnexus modules:

    
    
    rem_drv rdriver
    rem_drv rdnexus
    

Next, you need to tell the software to not use the multipath features of the
driver (which the A1000 only has one controller, so multipathing is
impossible). Make a backup of /etc/osa/rmparams, then change these two lines:

    
    
    Rdac_SupportDisabled=FALSE
    Rdac_SinglePathSupportDisabled=FALSE
    

to look like these two lines:

    
    
    Rdac_SupportDisabled=TRUE
    Rdac_SinglePathSupportDisabled=TRUE
    

Reboot, and all is well!

