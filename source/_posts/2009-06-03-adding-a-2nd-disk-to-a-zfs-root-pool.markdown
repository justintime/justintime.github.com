---
title: Adding a 2nd Disk to a ZFS Root Pool
permalink: /content/2009/06/03/adding-2nd-disk-zfs-root-pool
layout: post
categories:
- sysadmin
comments: true
sharing: true
footer: true
---
So, let's say you've just completed [migrating to ZFS from UFS using
LiveUpgrade](http://www.sysadminsjourney.com/content/2009/06/02/use-
liveupgrade-migrate-ufs-zfs-minimal-downtime), and now you want use that
leftover disk to make a mirror. Easily done, but there's one caveat -- you
need to make the second disk bootable in case the first fails.  So, starting
off from [where we left
off](http://www.sysadminsjourney.com/content/2009/06/02/use-liveupgrade-
migrate-ufs-zfs-minimal-downtime), you have an old UFS based boot environment
sitting on c1t1d0. First, delete the old environment:

    
    
    ludelete Solaris10 && lustatus
    

That was easy. Now run 'format' on c1t1d0, and make slice 0 encompass the
whole disk. Write out the label, and get back to the prompt. Now, we need to
make our single-disk ZPool into a two-way mirror. This operation is mind-
blowingly simple and is one of the showcases of ZFS and its ease of
management:

    
    
    zpool attach rpool c1t0d0s0 c1t1d0s0
    

This sets up the mirror, and automatically starts the resilvering (syncing)
process. You can monitor its progress by running 'zpool status'. The final
step is to actually make c1t1d0 bootable in case c1t0d0 fails. Here, we use
the 'installboot' program for SPARC:

    
    
    installboot -F zfs /usr/platform/`uname -i`/lib/fs/zfs/bootblk /dev/rdsk/c1t1d0s0
    

or use installgrub if you're on x86:

    
    
    installgrub /boot/grub/stage1 /boot/grub/stage2 /dev/rdsk/c1d0s0
    

That's it, you can now boot from either drive!

