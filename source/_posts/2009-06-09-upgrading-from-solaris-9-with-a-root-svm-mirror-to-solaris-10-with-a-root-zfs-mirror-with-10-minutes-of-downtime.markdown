---
title: Upgrading from Solaris 9 with a Root SVM Mirror to Solaris 10 with a Root ZFS Mirror with less than 10 Minutes of Downtime
permalink: /content/2009/06/09/upgrading-solaris-9-root-svm-mirror-solaris-10-root-zfs-mirror-10-minutes-downtime
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
As sysadmins, many times the entire task laid out in front of us has no
documentation. One of the biggest skill an admin can have is the ability to
problem solve, breaking down a large task into smaller sub-tasks. Often times,
you might be able to find documentation on some of those sub-tasks. A perfect
example is upgrading a server from Solaris 9 with root in an SVM mirror to
Solaris 10 with a ZFS mirror. Not only is this large task doable, but thanks
to LiveUpgrade, it can be done with less than 10 minutes of downtime (3
reboots @ roughly 3 minutes each)!  Part of the beauty of Solaris when
compared to Linux is the tools made available to the admin. I didn't even like
working in Solaris until I started learning about zones, ZFS, LiveUpgrade,
DTrace, etc. Now, on the server-side, I can't use it enough. I would be hard-
pressed to do a similar upgrade with Linux - it's almost impossible to do in
10 minutes of downtime on RHEL. Debian might be able to do it, but LiveUpgrade
gives you the ability to roll back to the previous state, which I don't
believe 'apt-get dist-upgrade' allows. Anyways, enough evangelism, onto the
howto! If you're [subscribed to my RSS
feed](http://feeds.feedburner.com/AUnixSysadminsJourney) you may not even have
noticed, but all of the steps have been already laid out over the past few
posts. All that remains is to put them back together into one big chain of
subtasks.

### Step One: Break the SVM Mirror

  * **Total Downtime:** One reboot (3 minutes)
  * **Link to Article:** [Unmirroring a RAID 1 Root Volume on Solaris](/content/2009/05/21/unmirroring-raid-1-root-volume-solaris)

### Step Two: Upgrade Solaris 9 to Solaris 10 using LiveUpgrade

  * **Total Downtime:** One reboot (3 minutes)
  * **Link to Article:** [LiveUpgrade from Solaris 9 to Solaris 10](/content/2009/05/25/liveupgrade-solaris-9-solaris-10)

### Step Three: Migrate from UFS to ZFS root using LiveUpgrade

  * **Total Downtime:** One reboot (3 minutes) - possibly a minute or so service downtime if files are stored on separate UFS filesystems
  * **Link to Article:** [Use LiveUpgrade to Migrate from UFS to ZFS with Minimal Downtime](/content/2009/06/03/use-liveupgrade-migrate-ufs-zfs-minimal-downtime)

### Step Four: Add the Second Disk to a ZFS Root Mirror

  * **Total Downtime:** None
  * **Link to Article:** [Adding a 2nd Disk to a ZFS Root Pool](/content/2009/06/03/adding-2nd-disk-zfs-root-pool)
We've taken a large behemoth of a task that sounds like a large amount of
downtime would have been incurred, and broken it down into smaller, more
manageable substeps. As an added bonus, using Solaris technologies, downtime
is kept to a minimum!

