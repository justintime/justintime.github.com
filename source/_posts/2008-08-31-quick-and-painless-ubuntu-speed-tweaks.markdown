---
title: Quick and Painless Ubuntu Speed Tweaks
permalink: /content/2008/08/31/quick-painless-ubuntu-speed-tweaks
layout: post
categories:
- Linux
- Ubuntu
- sysadmin
comments: true
sharing: true
footer: true
---
As far as performance, Ubuntu 8.04 isn't bad out of the box.
However, the developers had to make some performance sacrifices in
order to remain compatible with older machines. If you have a newer
machine with at least 512MB RAM, enabling these tweaks will
significantly speed up your Ubuntu experience. There's a lot of
copy and paste blog posts out there on Feisty, and a lot of
so-called tweaks that I feel are unnecessary.  Where I aim to
differentiate this post is to specialize on tweaks relevant to
8.04, and to cover only the 80/20 rule of performance -- 20% of the
work done tweaking will net you 80% of the speed boost. There's a
lot more that you can tweak, but it really won't net you that much
gain. Here's what I use on all my desktop Ubuntu installs.
### 1. Start your services in parallel at boot.

Instead of starting one service at a time, let's start them all as
fast as possible, and in parallel.  This will actually slow down
older, single core machines, but faster P4's, and multiple core CPU
machines will benefit from this.  Run this command, and reboot:

    sudo perl -i -pe 's/CONCURRENCY=none/CONCURRENCY=shell/' /etc/init.d/rc

### 2. Utilize preload to speed up application startup time.

If you have some extra RAM, look into preload. From the preload
website:

> preload is an adaptive readahead daemon. It monitors applications
> that users run, and by analyzing this data, predicts what
> applications users might run, and fetches those binaries and their
> dependencies into memory for faster startup times.

You can read all about how it does it and how it can be tweaked on
[this article on techthrob.com](http://www.techthrob.com/tech/preload.php),
but you can just "set it and forget it" and it will be fine. Run
the following command:

    sudo apt-get install preload

and bask in the glory of the speed boost!

### 3. Swappiness != Happiness.

If you have enough RAM, you shouldn't ever need to use swap. Heck,
RAM is cheap. If you're short on RAM, stop reading this article and
go buy some.

My best guess is that the Ubuntu devs do this for folks running on
older systems with less RAM, but it doesn't help any on systems
with 512MB or more RAM. Swappiness basically controls the tendency
of the kernel to page memory out to disk. You can read the gory
details [over at kerneltrap.org](http://kerneltrap.org/node/3000),
or just run the following commands:



    sudo sysctl vm.swappiness=5
    sudo su -c 'echo vm.swappiness=5 >> /etc/sysctl.conf'

### 4. Profile your boot process.

This has got to be one of the most undocumented features in
Ubunutu. I found many sites saying to "do this", but none said why.
[A forum post on the Ubuntu site](http://ubuntuforums.org/showthread.php?t=254263)
pointed me in the right direction.

Basically, the second thing to start during boot in Ubuntu is
readahead. The init script is at /etc/rcS.d/S01readahead. It
preloads all the libs that you might need during bootup. The list
of files that this service will load is contained in
/etc/readahead/boot (and /etc/readahead/desktop). It's good to do
this once, then repeat it after you do a major upgrade such as a
dist-upgrade, or significantly change your startup services. Please
note that it will slow the boot process during the profile step, as
it's recording what's needed at boot time. Your next boot will be
much faster.

To start profiling, do the following on bootup:

-   At the bootup menu (GRUB), select your default kernel. You may
    need to press ESC to see this menu.
-   Press e for edit.
-   Choose the first line (it should start with "kernel"). Press e
    again.
-   Move to the end of the line, then add the word profile. Press
    enter.
-   Press b to boot.
-   Let the system boot to the login screen, and wait for all disk
    activity to stop. Remember, during this one bootup, you've told
    Ubuntu to keep track of all disk activity going on, in order to
    build that list. Don't be surprised if it's significantly slower
    than your ordinary bootups -- that's why it's not activated by
    default, remember?
-   Reboot your system, and enjoy the results.

### 5. Don't start unneeded services.

Don't start services that you don't need or use. They eat up RAM,
and consume CPU cycles. The purpose of this post isn't to define
all these services (that may make a nice post in and of itself),
it's to show you how to turn them off.

If you like command line/curses interfaces:

    sudo apt-get install sysv-rc-conf && sudo sysv-rc-conf

If you want a GUI:

    sudo apt-get install bum && gksudo bum

I run a lot of stuff on my laptop, so I couldn't disable too many
things, but here's what I did disable: rsync, nfs-kernel-server,
apmd, apport, and avahi-daemon.

### Noteables

Many of the other posts out there will have you tweaking your own
kernel. While I'm not against this (it makes you learn a lot about
how Linux works), doing it for performance reasons isn't the way to
go. You might speed things up a bit, but if you're that much of a
tweaker, look into [Gentoo Linux](http://www.gentoo.org).

Another item left off the list is the tweaking of the ext3 mount
options in /etc/fstab. For the most part, Hardy comes out of the
box with decent mount options. The one **possible** exception is
the use of noatime. noatime disables the logging of the last access
time of the files, and if you're
**absolutely sure there's nothing you use that needs this**, then
you are okay to replace any occurrence of 'relatime' with 'noatime'
in /etc/fstab. However, if you look at the man page for mount,
you'll see that relatime is a nice compromise between full access
time logging and none at all.

Well, that about wraps it up. If you have your own tweaks you'd
like to share, post it in the comments!



