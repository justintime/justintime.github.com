---
title: Don't Reboot After Adding Partitions - partprobe!
permalink: /content/2009/08/20/dont-reboot-after-adding-partitions-partprobe
layout: post
categories:
- Linux
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/gnu-head.png)Another one of those topics where about 50% of
the class bustled in excitement over learning something new and simple came up
today. After running fdisk, you will almost always get an error about the
kernel not using the new partition table you just modified. Before GNU
released parted, you had to reboot in order for the kernel to purge it's cache
and reload the partition table, but now, all you need to do is run
**partprobe** after exiting fdisk. AFAIK, partprobe is included in most all
distros.

