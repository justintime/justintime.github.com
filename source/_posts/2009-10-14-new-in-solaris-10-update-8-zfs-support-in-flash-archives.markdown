---
title: New in Solaris 10 Update 8 - ZFS Support in Flash Archives
permalink: /content/2009/10/14/new-solaris-10-update-8-zfs-support-flash-archives
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/solaris.gif)The[ release of Solaris 10 10/09 (Update
8)](http://www.sun.com/aboutsun/pr/2009-10/sunflash.20091008.3.xml) has come
and gone, and without too much fanfare from my point of view. In my opinion,
there is one new feature that will really help propel root ZFS installations
into the enterprises where there was resistance before. You see, many larger
corporations have invested a lot of time and money into using Flash Archive
coupled with Jumpstart to be able to deploy golden images to many machines in
a small amount of time. However, up until now, ZFS and Flash Archive were
incompatible, meaning you were forced to use UFS root file systems if you
wanted to use Flash Archive installs. Some have [even went to great lengths to
hack solutions
together](http://blogs.sun.com/scottdickson/entry/a_much_better_way_to), but I
doubt they made many in-roads into the enterprise. Read on for a quick
overview of Flash Archive and ZFS support in the latest update of Solaris 10.

From [Sun's ZFS Administration
Guide](http://docs.sun.com/app/docs/doc/819-5461/githk?l=en&a=view), here's
some potential "gotcha's":

  * Only a JumpStart installation of a ZFS Flash archive is supported. You cannot use the interactive installation option of a Flash archive to install a system with a ZFS root file system. Nor can you use a Flash archive to install a ZFS BE with Solaris Live Upgrade.

  * You can only install a system of the same architecture with a ZFS Flash archive. For example, an archive that is created on a sun4u system cannot be installed on a sun4v system.

  * Only a full initial installation of a ZFS Flash archive is supported. You cannot install differential Flash archive of a ZFS root file system nor can you install a hybrid UFS/ZFS archive.

  * Existing UFS Flash archives can still only be used to install a UFS root file system. The ZFS Flash archive can only be used to install a ZFS root file system.

  * Although the entire root pool, minus any explicitly excluded datasets, is archived and installed, only the ZFS BE that is booted when the archive is created is usable after the Flash archive is installed. However, pools that are archived with the flar or flarcreate command's **-R** rootdir option can be used to archive a root pool other than the one that is currently booted.

  * A ZFS root pool name that is created with a Flash archive must match the master root pool name. The root pool name that is used to create the Flash archive is the name that is assigned to the new pool created. Changing the pool name is not supported.

  * The flarcreate and flar command options to include and exclude individual files are not supported in a ZFS Flash archive. You can only exclude entire datasets from a ZFS Flash archive.

  * The flar info command is not supported for a ZFS Flash archive.

There's a few constraints in there that might cause a few people problems, but
overall Sun has done a good job opening up yet another in-road to the
enterprise folks to let them experience the joy that is administering ZFS.

I have yet to setup Flash Archive and ZFS myself, but once I do, you can bet
I'll post about it!

