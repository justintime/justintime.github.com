---
title: ZFS in the Trenches presentation at LISA 09
permalink: /content/2009/12/29/zfs-trenches-presentation-lisa-09
layout: post
categories:
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
Just got the chance to finally sit down and watch [Ben
Rockwood's](http://www.cuddletech.com) presentation at LISA 09: [ZFS in the
Trenches](http://slx.sun.com/1179275886). If you are even thinking about ZFS
and how it works, it's a very informative presentation. There is very little
marketing-speak, and he very specifically targets sysadmins as his audience.
Great stuff! Of interesting note about his comparison of fsstat vs iostat, our
Apache webservers routinely see about 5MB/sec reads being asked of ZFS, but
the actual iostat on the disk shows that almost all of that traffic is being
served up from ARC.

