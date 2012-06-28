---
title: Use LVM on an installation of Ubuntu
permalink: /content/2008/12/16/use-lvm-installation-ubuntu
layout: post
categories:
- Linux
- Ubuntu
- sysadmin
comments: true
sharing: true
footer: true
---
RHEL/CentOS has had support for LVM in setup for quite some time now, but for
whatever reason, Ubuntu has been slow at adopting support for LVM at
installation. Usually, I just grumble and move on with ext3 -- not today.
Convinced that I couldn't be the only person wanting LVM support, I set out to
do just that. Luckily, it wasn't hard at all! As of Intrepid (8.10), the
installer has basic support for LVM in the disk partitioner part of the
installation. It's not pretty, but it works. The key is that the LVM binaries
aren't installed into the image, so the installer won't detect the presence of
the LVM PV's, VG's, and LV's. Here's how to a) create a new LVM setup during
installation, and b) how to use an existing LVM setup during installation.

### Pre-installation Common Steps

You need to do this section no matter what path you are taking.

  * Boot into the Live CD mode - not the direct installation.
  * Once you're looking at your desktop, we need to install LVM. Hit **Alt+F2**, and type in **gnome-terminal**, hit the **OK** button.
  * At the terminal, type **sudo apt-get install lvm2**. Note that this installs the binaries into the ramdisk, not your final installation. We'll need to install LVM to the hard drive later.
  * Once installed, we need to load the device mapper module into the kernel: **sudo modprobe dm-mod**
If you're setting up LVM from scratch, continue with **New LVM Setup** below.
Otherwise, skip to **Use an Existing LVM Setup** further down.

### New LVM Setup

Creating LVM setups from scratch is not a "cookie cutter" operation,
everyone's setup will be different. If you're trying to do LVM on
installation, you likely already know what you're doing here. However, your
general steps should be something like:

  * Use **sudo fdisk /dev/sda** to setup your Linux boot partition and LVM (type 8e) partition(s)
  * Update the kernel with the new partitions by running **sudo partprobe**.
  * I recommend using ext2 on your boot partition. If boot will reside on partition 1, then do a **sudo mkfs.ext2 /dev/sda1** to format the partition with Ext2.
  * Create the physical volume(s) (PV's) on the partitions of type 8e by using **sudo pvcreate /dev/sdaN**.
  * Create a volume group (VG): **sudo vgcreate MyLVMVG /dev/sdaN**
  * Create logical volumes (LV's) within the group: **sudo lvcreate -n root -L 5G MyLVMVG && sudo lvcreate -n swap -L 1G MyLVMVG**
  * Last, we need to put filesystems on the LV's. **sudo mkfs.ext3 /dev/MyLVMVG/root && mkfs.swap /dev/MyLVMVG/swap**
Skip the next section and continue on to **Post-configuration Common Steps**.

### Use an Existing LVM Setup

In my personal case, I was replacing CentOS with Ubuntu. I like CentOS for
it's stability, but my laptop needs a more bleeding edge in order to run the
way I want it. I had setup an efficient LVM configuration already, I just
wanted to reformat it during installation and use what I already had. Here's
what you need to do:

  * If you don't already know it, we need the volume group (VG) names from our current setup. You can obtain that by running **sudo vgscan | grep Found**. In cases where CentOS/RHEL did the setup, you'll likely have a VG name of VolGroup00.
  * We need to tell the running kernel to scan for and activate the current logical volumes (LV's). Using the VG from above, run **sudo lvchange -ay VolGroup00**
  * At this point, your LV's should be found and available to the kernel. You can verify this by running **sudo lvdisplay | grep "LV NAME\|LV Status"**
At this point, your LV's will be visible to the installer. Continue on to
**Post-configuration Common Steps** below.

### Post-configuration Common Steps

Now, you need to launch the installer. You can double-click the icon, or you
can type **ubiquity** in your already open terminal. Continue through the
installer as normal, but make sure you select the **Manual** radio button on
the **Prepare Disk Space** panel of the installer. When you click the
**Forward** button, you'll be presented with a list of devices that includes
your /dev/mapper/VG/LV entries. Go ahead and click on each one, click the
**Edit Partition** button, and set the mountpoint. **Write down or memorize
what LV's are mounted where, and which partition is your boot partition** --
you'll need it later. Format them if you used an existing setup. Continue
through the installer just as you normally would, **but make sure to click
"Continue using the liveCD" at the end of installation!** Failure to do so
will give you a system that won't boot. Here's the only tricky part -- we need
to mount our partitions that we installed to, and install LVM into it. Since
you wrote down everything above, it's not hard. First, we need to make a
mountpoint, and mount our root LV to it:
{% highlight bash %}
sudo su - mkdir /mnt/chroot/
mount /dev/VolGroup00/root /mnt/chroot
{% endhighlight %}
Now,
everyone will need to do this for the /boot partition, but you may need to
mount /var, /home/, etc., if you created separate mount points for them.
Here's what I had to do in my particular setup:
{% highlight bash %}
mount /dev/VolGroup00/home /mnt/chroot/home
mount /dev/sda3 /mnt/chroot/boot
{% endhighlight %}

Now, we need to chroot into our environment, and install LVM.
{% highlight bash %}
chroot /mnt/chroot apt-get update apt-get install lvm2
exit
{% endhighlight %}

At this point, you can restart the system by clicking
System->Shut Down->Restart. If you're paranoid you can unmount the partitions,
but the live cd will do that for you.

### Conclusion

While it's not that hard to use LVM during installation of Ubuntu, it's still
harder than it should be. It looks like something the Ubuntu devs are working
on, as the ubiquity installer already has rudimentary support for it. Maybe
9.04 will have it -- if not, check back here for a post on how to do it there
too!

