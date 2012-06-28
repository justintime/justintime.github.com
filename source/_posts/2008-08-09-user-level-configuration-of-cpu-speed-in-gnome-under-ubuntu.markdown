---
title: User-level configuration of CPU speed in Gnome under Ubuntu
permalink: /content/2008/08/09/user-level-configuration-cpu-speed-gnome-under-ubuntu
layout: post
categories:
- Linux
- QuickTips
- Ubuntu
- sysadmin
comments: true
sharing: true
footer: true
---
When I ran Fedora on my laptop, I loved how I could manually set
the CPU speed in Gnome using the "CPU Frequency Scaling Monitor"
applet.  I noticed that I could not do this under Ubuntu (you can
monitor speed, but you can't change it). It's actually a feature,
not a bug.  In order to change CPU frequency, the binary needs to
be SUID, which Ubuntu doesn't enable by default.  In order to
change this behavior, run the following:
    sudo dpkg-reconfigure gnome-applets

Answer "Yes" to the question regarding cpufreq-selector.  You will
immediately get the ability to change your CPU frequency - no
reboot, no restart of Gnome, not even the applet needs restarted!


