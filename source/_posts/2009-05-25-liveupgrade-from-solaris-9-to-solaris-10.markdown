---
title: LiveUpgrade from Solaris 9 to Solaris 10
permalink: /content/2009/05/25/liveupgrade-solaris-9-solaris-10
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
Here's how to leverage LiveUpgrade to safely upgrade from Solaris 9 to Solaris
10 using a spare disk. No data is ever deleted, and to roll back to Solaris 9,
all you need is one command and a reboot.  Let's continue on from the example
in [Unmirroring a RAID 1 Root Volume on
Solaris](http://www.sysadminsjourney.com/content/2009/05/21/unmirroring-raid-1
-root-volume-solaris) - we have two disks, c1t0d0 and c1t1d0. c1t0d0 is our
Solaris 9 disk, c1t1d0 is our spare.

### Phase One: Prepare the Solaris 9 environment

First, we need to prepare the Solaris 9 environment with some packages and
patches. First, check out [Sun's InfoDoc
206844](http://sunsolve.sun.com/search/document.do?assetkey=1-61-206844-1) and
make sure you have all of the patches required installed. Next, for
LiveUpgrade to work properly, you need to install the LiveUpgrade packages
from your Solaris 10 install media to your Solaris 9 box. First, remove the
existing packages:

    
    
    pkgrm SUNWlucfg SUNWluu SUNWlur
    

Then, install the new packages from your Solaris 10 media (if you're using
CD's, it's on disc 2):

    
    
    cd $SOLARIS10MEDIA/Solaris_10/Tools/Installers
    ./liveupgrade20
    

Next, let's copy the disk label from c1t0d0 over to c1t1d0 giving us the exact
same disk layout on the new disk as the old disk:

    
    
    prtvtoc /dev/rdsk/c1t0d0s2 | fmthard -s - /dev/rdsk/c1t1d0s2
    

We now have all the prep work done for getting ready for our LiveUpgrade. Now,
we need to create our boot environment.

### Phase Two: Create the New Boot Environment

First, let's make some assumptions. Since we're upgrading from Solaris 9 to
Solaris 10, we'll be upgrading from UFS to UFS file systems. Also, since we
are upgrading from one disk to another, we will copy all filesystems from
c1t0d0 to c1t1d0 - no filesystems will be shared. In order to create our new
boot environment, we will use the 'lucreate' command. Let's define some
variables:

**Flag**
**Description**

-c
Sets the current boot environment name to this name. In this example, we use
Solaris9

-n
Sets the newly created environment's name to this name. In this example, we
use Solaris10

-m
The -m option is the most critical part of the lucreate command. It specifies
the filesystems in the new environment. To create more than one filesystem,
you use the -m flag more than once. By using different variations on the -m
flag, you can reorganize, resize, and merge filesystems, but that's beyond the
scope of this article. The value to the -m flag is:
_mountpoint:device:fs_options_. From the previous example in [Unmirroring a
RAID 1 Root Volume on
Solaris](http://www.sysadminsjourney.com/content/2009/05/21/unmirroring-raid-1
-root-volume-solaris), we have 5 filesystems: /, /usr/local/, /apps,
/export/home/, and swap.

Using the above options for our scenario, we end up with:

    
    
    lucreate -c Solaris9 -n Solaris10 -m /:/dev/dsk/c1t1d0s0:ufs -m -:/dev/dsk/c1t1d0s1:swap \
    -m /usr/local:/dev/dsk/c1t1d0s3:ufs -m /export/home:/dev/dsk/c1t1d0s4:ufs \
    -m /apps:/dev/dsk/c1t1d0s5:ufs
    

Depending on the number and size of files in your source boot environment,
this may take awhile. The lucreate process gives you output for each step,
letting you know what it's doing.

### Phase Three: Upgrade the New Boot Environment to Solaris 10

Now that phase two is done, we have a bootable copy of our current Solaris 9
environment. Now, we need to apply the upgrade to Solaris 10 to our new boot
environment. For simplicity, I have an exported Solaris 10 install DVD
extracted on another server that I use the automounter to access. Now, we'll
run the 'luupgrade' command and tell it to install the upgrade to the new boot
environment we just created:

    
    
    luupgrade -u -n Solaris10 -s /net/install.mydomain.com/export/jumpstart/install/sparc_10
    

Again, this will take some time, and the process will give you output as it
clicks along.

### Phase Four: Mark the New Boot Environment as Active and Boot Into It

Now, our Solaris 10 boot environment actually has a copy of our Solaris 9
environment with the upgrade to Solaris 10 within it. To boot into that
environment, we need to mark it as active, and reboot. These instructions
cover SPARC machines, for x86/x64, see the Sun documents referred in the
summary of this article - there are a couple of differences. To make our new
boot environment active, we'll use the 'luactivate' command:

    
    
    luactivate Solaris10
    init 6
    

Tricky, huh? ;-) Should something not go completely right during the upgrade,
you can roll back to your previous boot environment simply by specifying
'Solaris9' for 'Solaris10' in the above 'luactivate' command. If something
really went wrong with the upgrade, and you didn't boot successfully, don't
worry. The 'luactivate' command above should have given you some output that
you should copy/paste someplace. Here's an example:

    
    
    In case of a failure while booting to the target BE, the following process 
    needs to be followed to fallback to the currently working boot environment:
    
    1. Enter the PROM monitor (ok prompt).
    
    2. Change the boot device back to the original boot environment by typing:
    
         setenv boot-device disk:a
    
    3. Boot to the original boot environment by typing:
    
         boot
    
    

If that doesn't do it, see the Sun docs in the summary of this article, they
will coach you through booting off the CD/DVD and reactivating the old
environment.

### Summary

As an admin coming from Linux, the LiveUpgrade suite is a breath of fresh air
for giving you an easy upgrade path that's just as easy to undo as it is to
do. We've only begun to scratch the surface of what you can do with
LiveUpgrade. You can use it to migrate from a UFS root to a ZFS root, use it
to install and test patches, install Flash Archives with it, reconfigure and
resize partitions, and on and on. For a much more comprehensive look into what
all LiveUpgrade can do, check out the Solaris Live Upgrade and Upgrade
Planning guide on [http://docs.sun.com](http://docs.sun.com) - the [current
release is for Solaris 5/09](http://docs.sun.com/app/docs/doc/820-7013?l=en).

