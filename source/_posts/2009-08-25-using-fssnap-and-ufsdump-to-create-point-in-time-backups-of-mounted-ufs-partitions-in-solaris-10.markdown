---
title: Using fssnap and ufsdump to create point-in-time backups of mounted UFS partitions in Solaris 10
permalink: /content/2009/08/25/using-fssnap-and-ufsdump-create-point-time-backups-mounted-ufs-partitions-solaris-10
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/solaris.gif)With all the (deserved) hype about ZFS, there's
still a lot of systems that make use of UFS out there. With all the things
that ZFS can do, there's still some things that it can't do (incompatability
with flash archives, and POSIX ACL's are examples). I needed to basically make
an image of a T1000 that had some non-global zones installed, stick it into a
lab for a couple weeks, and then return it to it's previous state. Since this
server had non-global zones, using flar's was questionable. So I decided to
use **fssnap** and **ufsdump** to make my backups.

The best part about UFS is that while it may not have the latest and greatest
features, what features it does have are rock-solid stable and supported.
**ufsdump** has been around for a long time, but only works on unmounted
slices. In order to do a **ufsdump** on your / mount, you either need to boot
to rescue media, or create a snapshot and run **ufsdump** against that.

For this example, we'll assume that you have just two slices -- / and /apps.
The first step is to find out where to store your backing store files. Your
backing store files will be the size not of the entire slice _but of the size
of the changes to the slice since the snapshot was made_. Let's say your /apps
mount is 40GB, but seldom changes - your backing store file will likely be
less than 512MB in size. Nonetheless, your backing store must not reside on
the same partition that you're making a snapshot of. For our example, we'll
assume that we have a third slice available, mounted at /snaps.

Before creating your snapshot, it's best to get the system into a state where
things are as quiet as possible. The best way to do this is to switch to
single user mode, but you can do whatever you like here. Issue the following
two commands to create your snapshots:

    
    # fssnap -F ufs -o bs=/snaps/root.back.file /
    /dev/fssnap/0
    # fssnap -F ufs -o bs=/snaps/apps.back.file /apps
    /dev/fssnap/1

You can see here that it has created two devices for us that represent the
snapshot. Note that these commands may take 20 seconds or so to return to the
shell. Once your snapshot devices are created, you may now return the system
to a normal state. Once you're back to normal, we need to create our UFS
dumps, but use our snapshot devices as the source. In our example, we have a
NFS mount at /mnt/shared that has all the room we need.

Now, let's create our UFS dump files:

    
    
    # ufsdump 0uf /mnt/shared/root.ufsdump /dev/rfssnap/0 
      DUMP: Date of this level 0 dump: Tue Aug 25 08:49:31 2009
      DUMP: Date of last level 0 dump: the epoch
      DUMP: Dumping /dev/rfssnap/0 to /mnt/shared/root.ufsdump.
      DUMP: Mapping (Pass I) [regular files]
      DUMP: Mapping (Pass II) [directories]
      DUMP: Writing 32 Kilobyte records
      DUMP: Estimated 21955062 blocks (10720.25MB).
      DUMP: Dumping (Pass III) [directories]
      DUMP: Dumping (Pass IV) [regular files]
      DUMP: 44.74% done, finished in 0:12
      DUMP: 94.38% done, finished in 0:01
      DUMP: 21955006 blocks (10720.22MB) on 1 volume at 8638 KB/sec
      DUMP: DUMP IS DONE
      DUMP: Level 0 dump on Tue Aug 25 08:49:31 2009
    # ufsdump 0uf /mnt/shared/apps.ufsdump /dev/rfssnap/1 
      DUMP: Date of this level 0 dump: Tue Aug 25 08:49:48 2009
      DUMP: Date of last level 0 dump: the epoch
      DUMP: Dumping /dev/rfssnap/1 to /mnt/shared/apps.ufsdump.
      DUMP: Mapping (Pass I) [regular files]
      DUMP: Mapping (Pass II) [directories]
      DUMP: Writing 32 Kilobyte records
      DUMP: Estimated 80736236 blocks (39421.99MB).
      DUMP: Dumping (Pass III) [directories]
      DUMP: Dumping (Pass IV) [regular files]
      DUMP: 11.32% done, finished in 1:18
      DUMP: 19.82% done, finished in 1:20
      DUMP: 21.32% done, finished in 1:50
      DUMP: 22.99% done, finished in 2:14
      DUMP: 24.85% done, finished in 2:31
      DUMP: 26.69% done, finished in 2:44
      DUMP: 28.71% done, finished in 2:53
      DUMP: 30.93% done, finished in 2:58
      DUMP: 32.57% done, finished in 3:06
      DUMP: 34.46% done, finished in 3:10
      DUMP: 36.08% done, finished in 3:14
      DUMP: 38.21% done, finished in 3:14
      DUMP: 40.29% done, finished in 3:12
      DUMP: 43.34% done, finished in 3:03
      DUMP: 50.89% done, finished in 2:24
      DUMP: 64.35% done, finished in 1:28
      DUMP: 78.02% done, finished in 0:47
      DUMP: 88.56% done, finished in 0:23
      DUMP: 97.63% done, finished in 0:04
      DUMP: 99.83% done, finished in 0:00
      DUMP: 80736126 blocks (39421.94MB) on 1 volume at 3347 KB/sec
      DUMP: DUMP IS DONE
      DUMP: Level 0 dump on Tue Aug 25 08:49:48 2009
    

As you can see, the /apps mount was quite large, but even after the backup,
the backing store file was less that 30MB when I was done. Make sure you
remember to remove your snapshots when you're done with them:

    
    
    # fssnap -d /
    # fssnap -d /apps
    # rm /snaps/*.back.file
    

Stay tuned for how to restore these ufsdump files!

