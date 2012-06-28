---
title: Use LiveUpgrade to Migrate from UFS to ZFS with Minimal Downtime
permalink: /content/2009/06/03/use-liveupgrade-migrate-ufs-zfs-minimal-downtime
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
Continuing on from [the article on how to use LiveUpgrade to upgrade from
Solaris 9 to Solaris 10](http://www.sysadminsjourney.com/content/2009/05/25
/liveupgrade-solaris-9-solaris-10), we now migrate our Solaris 10 UFS file
systems to ZFS. LiveUpgrade handles the migration of the critical filesystems,
we'll manually migrate three other filesystems from UFS to ZFS using ufsdump
and ufsrestore to minimize downtime.

### Phase One: Delete the Old Solaris 9 Boot Environment

We still have an old Solaris 9 boot environment laying around. It's time to
move on, and blow it away.

    
    
    ludelete Solaris9 && lustatus
    

There -- that felt good now, didn't it?

### Phase Two: Create the Solaris 10 ZFS Boot Environment

Now that we've freed up c1t0d0 by removing the Solaris 9 boot environment, we
can use it for our ZFS boot environment. Before we can do anything, it's a lot
easier to reformat the disk to use just one big slice. Go ahead and use
'format' to reconfigure your slices so that s0 consists of the whole disk.
With our slices in place, we need to create our root pool. Do this by running:

    
    
    zpool create rpool c1t0d0s0
    

With that out of the way, we can now create a new boot environment named
Solaris10ZFS that is a copy of the current one on our newly created ZFS pool
named rpool:

    
    
    lucreate -n Solaris10ZFS -p rpool
    

### Phase Three: Boot Into the Solaris 10 ZFS Boot Environment

The next step is to activate our ZFS boot environment, and boot into it.

    
    
    luactivate Solaris10ZFS
    

**Note:** if that fails with the message '/usr/sbin/luactivate: /etc/lu/DelayUpdate/: cannot create', then you've tripped over a bug [described here](http://docs.sun.com/app/docs/doc/820-7273/installbugs-113?l=en&a=view). To work around it, run the following: 
    
    
    export BOOT_MENU_FILE="menu.lst"
    luactivate Solaris10ZFS
    

You'll get output similar to the following - be sure to print it out, or copy
it someplace you can get to it later:

    
    
    **********************************************************************
    
    The target boot environment has been activated. It will be used when you 
    reboot. NOTE: You MUST NOT USE the reboot, halt, or uadmin commands. You 
    MUST USE either the init or the shutdown command when you reboot. If you 
    do not use either init or shutdown, the system will not boot using the 
    target BE.
    
    **********************************************************************
    
    In case of a failure while booting to the target BE, the following process 
    needs to be followed to fallback to the currently working boot environment:
    
    1. Enter the PROM monitor (ok prompt).
    
    2. Change the boot device back to the original boot environment by typing:
    
         setenv boot-device /pci@1c,600000/scsi@2/disk@1,0:a
    
    3. Boot to the original boot environment by typing:
    
         boot
    
    **********************************************************************
    
    Modifying boot archive service
    Activation of boot environment  successful.
    

When ready, run

    
    init 6

to reboot into your ZFS boot environment.

### Phase Four: Migrate Non-Critical UFS Filesystems to ZFS

In our example, I had three UFS filesystems that were not a "critical"
filesystem as marked by Sun:

/apps

/dev/dsk/c1t1d0s5

/export/home

/dev/dsk/c1t1d0s4

/usr/local

/dev/dsk/c1t1d0s3

We will create new ZFS filesystems for these, and use ufsbackup and ufsrestore
to quickly sync them over. You could write a script for this, but scripts that
muck with filesystems make me nervous. Here's a list of steps you'll want to
do for each filesystem you want to migrate. For this example, I'll use the
/apps partition above.

  * First, create the ZFS filesystem under the rpool pool: 
    
    zfs create rpool/apps

  * Next, change to the new ZFS directory: 
    
    cd /rpool/apps

  * Next, we do a backup and restore from UFS to ZFS: 
    
    ufsdump 0uf - /apps | ufsrestore rf -

  * Now, create a temporary mountpoint for the UFS filesystem: 
    
    mkdir /ap/apps
    
    
      * Stop all processes that are accessing the UFS filesystem.  Use 'fuser -c /apps' to make sure it's no longer in use.
    
    
      * Unshare the filesystem from NFS: 
    
    unshare /apps

  * Unmount the UFS filesystem from it's old location: 
    
    umount /apps

  * Mount the UFS slice to the new, temporary location: 
    
    mount /dev/dsk/c1t1d0s5 /a/apps

  * Change to the ZFS directory: 
    
    cd /rpool/apps

  * Run a level one backup/restore. This will only copy over files that have changed since we did the level 0 backup above (and should be very quick): 
    
    ufsdump 1uf - /a/apps | ufsrestore rf -

  * Get out of the ZFS directory: 
    
    cd /

  * Set the mountpoint for the ZFS filesystem to be where the old UFS one was: 
    
    zfs set mountpoint=/apps rpool/apps

  * Start up your daemons and whatnot that were needing access to the filesystem.
  * Unmount the temporary mount, and cleanup the directory: 
    
    umount /a/apps && rmdir /a/apps

  * Edit /etc/vfstab, and comment out the line mounting /apps. ZFS handles mounting for us now.
  * Wash, Rinse, Repeat - repeat this for /usr/local and /export/home.

### Phase Four: Test

First, go ahead and exhale -- holding your breath for that long isn't good for
you! You need to take a look around the system, and make sure everything is
running properly. Check 'dmesg', /var/log/syslog, /var/adm/messages, etc. Run
'mount' and make sure there's no UFS mounts in there that you don't want. I
recommend a reboot, but it's not really needed.

### Summary

Well, you did it! Migrating an entire system from UFS to ZFS isn't as painful
as it could be, thanks to LiveUpgrade. If you have non-critical UFS
filesystems you want to migrate, it requires a little elbow grease, but is
easily done with minimal downtime. Welcome to your new ZFS root!

