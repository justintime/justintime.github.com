---
title: VirtualBox 2.0 Quick Impressions
permalink: /content/2008/09/10/virtualbox-20-quick-impressions
layout: post
categories:
- Linux
- Reviews
- Sun
- Ubuntu
- Virtualization
- sysadmin
comments: true
sharing: true
footer: true
---
I'm not new to the virtualization scene, but I'm no expert either -- I've been
using [VMWare](http://www.vmware.com) Workstation since 1.0,
[VMWare](http://www.vmware.com) Server since 1.0, and
[Xen](http://www.xensource.org) since around 2.0. Well, I needed a Windows XP
install on my laptop, and decided it would be a good time to see how
[VirtualBox](http://www.virtualbox.org) compared. [VirtualBox
2.0](http://www.virtualbox.org) was just released
([changelog](http://www.virtualbox.org/wiki/Changelog)), so I went with the
bleeding edge. Read on for my quick review of
[Virtualbox](http://www.virtualbox.org) 2.0.  My laptop was running Ubuntu
Hardy, but your experience is likely to be the same no matter the distro you
prefer.

### Installation

Not much to say here. I clicked a link on [the download
page](http://www.virtualbox.org/wiki/Downloads), GDebi popped up, and I
installed the deb. Can't get much easier!

### Guest OS Installation

Anyone familiar with VMWare workstation should feel right at home here. Fire
up the gui, click 'New', create a new Windows XP guest machine. I accepted the
defaults of 192MB RAM and 10GB disk. Now, it's been a really long time since
I've installed Windows XP, but I swear that the installation went faster from
within VirtualBox than natively. No metrics to back that up, just a gut
feeling.

### Networking

Worked out of the box. I accepted the default configuration of NAT through the
host. Immediately I ran Windows Update after installation, and went to bed.
The next day, everything had worked as it should have.

### Performance

The changelog states that numerous performance improvements have been made
since 1.0, but since I don't have past experience, I can't speak to how much
better it performs. I can tell you that running Windows XP as a guest under
Virtualbox 2.0 did not feel any faster, nor any slower that running Windows XP
as a guest under VMWare Workstation on the same laptop. While installing SP3
for Windows XP in the guest, I noticed fairly significant host responsiveness
degradation. However, my laptop still has a PATA drive in it, and my XP VM was
using the "hard disk as a file" method instead of a dedicated partition. My
hunch is that support for [NCQ](http://en.wikipedia.org/wiki/NCQ) and
dedicated partitions helps this quite a bit. Also, when using the XP VM under
normal conditions that didn't write to the disk so extensively, the host
machine was still very responsive.

### Hardware Support

Below is the list of what I've tested under my XP VM:

  * **USB:** I'll get to this eventually, but I don't need it yet.
  * **Sound:** Worked flawlessly. 
  * **CD/DVD Drive:** No problems here either.

### Verdict

VirtualBox is an impressive product. Consider me a convert from VMWare
Workstation, VirtualBox does everything I need it to and more, and the cost of
zero is something VMWare Workstation can't begin to compete with!

