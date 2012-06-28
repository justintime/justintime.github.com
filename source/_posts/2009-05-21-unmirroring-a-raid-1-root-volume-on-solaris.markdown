---
title: Unmirroring a RAID 1 Root Volume on Solaris
permalink: /content/2009/05/21/unmirroring-raid-1-root-volume-solaris
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
It happens fairly often that you need to create a software mirror using SVM on
Solaris. A smaller percentage of the time, you need to create a SVM mirror of
your root partition. It doesn't happen very often at all, but there are cases
where you want to _unmirror_ your root partition on Solaris. I'll get into the
why later, follow the jump for the howto.  First, we need to define the disk
setup of our server. The following table shows the current SVM setup.

**Mount Point**
**Mirror Device**
**c1t0d0 Slice/Submirror**
**c1t1d0 Slice/Submirror**

/

d1

slice 0/d10

slice 0/d11

/usr/local

d2

slice 3/d20

slice 3/d21

/export/home

d3

slice 4/d30

slice 4/d31

/apps

d4

slice 5/d40

slice 5/d41

swap

d5

slice 1/d50

slice 1/d51

-
MetaDB Slices

slice 6

slice 6

As you can see, we have 5 individual mirrors, one of which is for swap. I
don't recommend mirroring swap, but I include it here because there is an
important caveat you need to catch if you do have mirrored swap. We have two
disks: c1t0d0, and c1t1d0. We have the metadb's stored on slice 6 of each
disk. Our end goal is to boot from c1t0d0, and have c1t1d0 available for
whatever we like.

## Disclaimer

I used these instructions, and they worked great for me. I've used them on
both Solaris 9 and Solaris 10. If you embark on such a task, make sure to have
a complete, full backup before you proceed!

## Step One: Detach Submirrors

First, we need to "break" the mirror, by removing all of the submirrors that
are contained on c1t1d0. In our case, we have mirrors 1-5, and the submirror
contained on c1t1d0 is always the same as the mirror device with a trailing 1.
This makes for a nice one liner:

    
    for i in 1 2 3 4 5; do metadetach d${i} d${i}1; done

This code removes submirror 11 from mirror 1, submirror 21 from mirror 2, and
so on.

## Step Two: de-metaroot

The proper way to create a mirrored root volume is to use the metaroot tool to
modify /etc/vfstab and /etc/system for you. The good thing about this is that
you can use the same tool to to de-configure it too. Keeping in mind that we
want our root slice to be c1t0d0s0, we run:

    
    metaroot /dev/dsk/c1t0d0s0

## Step Three: Update vfstab

Now, we need to edit /etc/vfstab and replace all of the mirror device mounts
with their c1t0d0 counterparts. If your original vfstab looked like this:

    
    
    ...
    /dev/md/dsk/d5  -       -       swap    -       no      -
    /dev/dsk/c1t0d0s0  /dev/rdsk/c1t0d0s0 /       ufs     1       no      -
    /dev/md/dsk/d4  /dev/md/rdsk/d4 /apps   ufs     2       yes     -
    /dev/md/dsk/d3  /dev/md/rdsk/d3 /export/home    ufs     2       yes     -
    /dev/md/dsk/d2  /dev/md/rdsk/d2 /usr/local      ufs     2       yes     -
    ...
    

Then your new vfstab should look something like this:

    
    
    ...
    /dev/dsk/c1t0d0s1       -       -       swap    -       no      -
    /dev/dsk/c1t0d0s0  /dev/rdsk/c1t0d0s0 /       ufs     1       no      -
    /dev/dsk/c1t0d0s5  /dev/rdsk/c1t0d0s5 /apps   ufs     2       yes     -
    /dev/dsk/c1t0d0s4  /dev/rdsk/c1t0d0s4 /export/home    ufs     2       yes     -
    /dev/dsk/c1t0d0s3  /dev/rdsk/c1t0d0s3 /usr/local      ufs     2       yes     -
    ...
    

## Step Four: Configure your Dump Device

Here's the caveat for mirrored swap - you're probably using /dev/md/dsk/d5 for
your dump device. Let's fix that now. First run

    
    dumpadm | grep '/md/'

If that returns any output, then run this (using your single-disk slice for
swap):

    
    dumpadm -s /var/crash/`hostname` -d /dev/dsk/c0t0d0s1

## Step Five: Reboot and Verify

Cross your fingers, and do a

    
    init 6

Once you're back up, look at the output of

    
    df -h && swap -l

and make sure there's no references to any 'md' devices.

## Step Six: Remove the Mirrors, Remaining Submirrors, and MetaDB's

Now that we are running in a single disk environment, we need to remove the
mirrors and submirrors. Again, ripe for a one-liner:

    
    
    for i in 1 2 3 4 5; do metaclear -r d${i}; done
    

At this point, 'metastat' should return no mirrors. Now, we can remove the
metadb's from slice 6 on both disks. Only do this if you're not using SVM for
anything else!

    
    
    metadb -df /dev/dsk/c1t1d0s6
    metadb -df /dev/dsk/c1t0d0s6
    

## Summary

Well, that covers the entire process. You should now have a free disk that you
can use for whatever you like!

