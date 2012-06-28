---
title: Use lofiadm to mount an ISO in Solaris 10
permalink: /content/2009/05/06/use-lofiadm-mount-iso-solaris-10
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
As a Linux user, I've used 
{% highlight console %}
# mount -o loop -t iso9660 /path/to/file.iso /mnt/tmp 
{% endhighlight %}
more times than I can count. Not
suprisingly, you can do it in Solaris 10 as well, there's just another step
involved:
{% highlight console %}
# lofiadm -a /path/to/file.iso /dev/lofi/1
# mount -o ro -F hsfs /dev/lofi/1 /mnt/tmp
{% endhighlight %}

The first command,
lofiadm, associates the iso file to a block device managed by the kernel
LOopback FIle driver. The second command is the same old mount command you're
used to, you just point it to the lofi device. To unmount:
{% highlight console %}
# umount /mnt/tmp # lofiadm -d /dev/lofi/1
{% endhighlight %}

