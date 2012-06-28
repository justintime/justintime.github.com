---
title: Performing a CentOS Anaconda-based Install on a Linode for Kickstart, Root LVM and SELinux Features
permalink: /content/2010/02/22/performing-centos-anaconda-based-install-linode-kickstart-root-lvm-and-selinux-features
layout: post
categories:
- Hosting
- Virtualization
- RedHat
- Linode
comments: true
sharing: true
footer: true
---
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
rocks. Seriously, read [my
review](http://sysadminsjourney.com/content/2008/08/01/linode-review). I was
talking to a co-worker (whom I converted to
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df) as
well) about how I would pay double the amount to keep my
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
now that I know how much I use it. Don't tell them that, they're cheap :) If
you find this article helpful (or my article about [moving VM's to and from
Linode](http://sysadminsjourney.com/content/2008/11/26/bringing-your-linode-
home-you)), please consider clicking one of the links in this article to sign
up for a
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df) -
if you sign up for 90 days, I'll get $20 credited to my account. I was setting
up a second
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
that was to be a testing ground for some
[StackScripts](http://blog.linode.com/2010/02/09/introducing-stackscripts/)
I'm working on. The new
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
will eventually replace my existing one. For whatever reason, the most recent
version of CentOS they had available was 5.3. Not a big deal, I can 'yum
upgrade' up to 5.4 after installation. Well, after doing so, I found that a
lot of features that I wanted had been stripped out. In Linode's defense, it's
in their best interest to offer very stripped down images for their customers.
The one feature I wanted that I couldn't get enabled was SELinux, and simply
installing the packages still wouldn't let me use 'setenforce 1' to get it
turned on. My best guess as to why is that the Linode kernel didn't support
it, but I honestly didn't troubleshoot it too much. I really wanted root LVM
capabilities as well, so I decided that a full-on anaconda based installation
was the way to go. Plus, I couldn't find anything in the forums about it, so
there was the lure of being the first to do it ;-) Well, thanks to the
flexibility offered by
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df),
not only can you do a anaconda-based installation (with optional Kickstart),
but you can do so using the GUI over VNC if you're so inclined!

### Step 1: Setup Finnix

Finnix is the distro of Linode's choice for 'rescue' operations on your
server. Think of it as a Swiss Army knife - it's a very powerful tool that
takes very little setup. For more on Finnix, checkout the [Linode Library
article](http://library.linode.com/troubleshooting/finnix-recovery). First, we
need to setup a very small, 20MB ext3 disk that will house our installation
kernel and initrd. Set up another ext3 disk of 100MB to be mounted at /boot
for PV-GRUB. Finally, setup your raw disk that will be used for the OS
installation. Since we'll be using LVM, you can easily add to and resize your
disk later, so don't overdo it. I went with 5GB for my root disk. If you're
following along, here's what you should have: ![](/assets/images/linode-
disks.png) Now, setup a Finnix configuration profile. Click on "Create a new
configuration profile", and type "Finnix Rescue" for the label. For the
kernel, select "Recovery - Finnix (kernel)". For /dev/xvda, select the
"Recovery - Finnix (iso)". For /dev/xvdb, select the "Centos 5.4 Install
Disk". For uncompressed initrd image, select "Recovery - Finnix (initrd).
Leave the other settings at defaults, and save the profile. Here's what it
should look like: ![](/assets/images/linode-finnix.png)

### Step 2: Upload the Xen-enabled Kernel and Initrd from the DVD

Next, boot Finnix from your
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
control panel. Click on the console tab, and launch the AJAX console. Once at
the console, we need to mount our install disk, and fetch the xen-enabled
kernel and initrd from your favorite mirror. Mount the installation disk,
change directories, and download the files:

    
    
    mount /dev/xvdb /mnt/xvdb 
    cd /mnt/xvdb
    for f in initrd.img vmlinuz; do
    wget http://mirror.unl.edu/centos/5.4/os/i386/images/xen/${f}
    done
    cd
    umount /mnt/xvdb
    

Now, shutdown Finnix from the
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
control panel.

### Step 3: Setup the CentOS configuration profile

Create a new profile, and name it CentOS 5.4. For the kernel, select "pv-grub-
x86_32". For /dev/xvda, select "CentOS 5.4 PV-GRUB Boot". For /dev/xvdb choose
"CentOS 5.4 OS Disk". For /dev/xvdh, select our "CentOS 5.4 Install Disk".
Point the root device to a custom location: "/dev/mapper/VolGroup00-LogVol00".
Leave the rest as defaults, here's a screenshot: ![](/assets/images/linode-
centos.png)

### Step 4: Boot the CentOS configuration profile and start the installation

Save the profile, and boot it. Note that it won't boot automatically, we have
to point GRUB in the right direction first. You'll be greeted by a scary-
looking 'grubdom>' prompt. Now, we need to tell grub to boot our install
kernel and initrd:

    
    
    root (hd2)
    kernel (hd2)/vmlinuz
    initrd (hd2)/initrd.img
    boot
    

Note that if you want to do a kickstart install, you would append
ks=http://my.com/this.ks to the kernel line above. More on this later. Once
the kernel loads, you'll be presented with the familiar anaconda text-based
installer. Choose your language, and your installation type. I prefer HTTP
from a mirror. If you choose to do the same, use the mirror hostname for the
Web site name, and the path to the directory that contains all the release
notes -- usually it's /centos/5.4/os/i386/. Anaconda will fetch the stage2
image, then launch the installer. Here's where it gets cool - it will give you
a choice to "Start VNC". If you choose this option, you can connect to your
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
via VNC (note it launches on display 1, not 0), and complete the installation
via a GUI. Install as you would any other CentOS installation. **Make note of
where your root directory is at.** The installer may complain about your
/dev/xvdh being a loop device, tell anaconda to ignore it. Exclude /dev/xvda
from any partitioning, we'll set that up manually later.

### Step 5: Modify the CentOS configuration profile and start the operating
system

Once you click the "Reboot" button on the installer, you'll be disconnected
from VNC. Your machine will be restarted, but it will stick at the grubdom
prompt again - that's okay. We'll be stuck at the grubdom> prompt one more
time - use this to tell it to boot CentOS using the boot partition the
installer setup for us:

    
    
    grubdom> root (hd1,0)                                                          
    grubdom> kernel (hd1,0)/vmlinuz-2.6.18-164.el5xen                              
    grubdom> initrd (hd1,0)/initrd-2.6.18-164.el5xen.img                           
    grubdom> boot
    

You will then boot into CentOS - exit the system settings GUI - you can run it
again later by running system-config-securitylevel-tui. Now we need to setup
our boot disk so that pv-grub knows how to boot our kernel so we're not
consistently prompted upon reboot.
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
uses PV-GRUB to boot our kernel, and it's looking for a 'boot' directory
directly on /dev/xvda. For more details, [see the Linode
Wiki](http://www.linode.com/wiki/index.php/PV-GRUB#Partitioning). Run this as
root, and make sure your block devices are aligned with mine before
copy/pasting:

    
    
    mkdir /mnt/newboot
    mkfs.ext3 /dev/xvda
    mount /dev/xvda /mnt/newboot
    rsync -av /boot /mnt/newboot
    cd /mnt/newboot/boot
    ln -s . boot
    cd
    umount /mnt/newboot
    umount /boot
    e2label /dev/xvdb1 oldboot
    e2label /dev/xvda /boot
    

That's it - reboot, and you should be up and running! You can create a LVM
physical volume out of the old boot partition on /dev/xvdb1, or just leave it
around unused.

### Streamlining the process with Kickstart

We can use kickstart to **really** streamline the process. Follow steps 1, 2,
and 3 above, but on step 4, replace the kernel line with this:

    
    kernel (hd2)/vmlinuz ks=http://www.sysadminsjourney.com/assets/files/linode-minimal.ks

That's it! The kickstart file handles partitioning, and setting up the right
boot partition, as well as disabling unneeded services that you don't need for
a Linode. Make sure you check out the file
http://www.sysadminsjourney.com/assets/files/linode-minimal.ks - your root password is there, change it immediately! Stay
tuned for my CentOS [StackScripts](http://blog.linode.com/2010/02/09/introducing-stackscripts/)!

