---
title: Forcing NIC Speed and Duplex on Solaris 10
permalink: /content/2008/05/08/forcing-nic-speed-and-duplex-solaris-10
layout: post
categories:
- Networking
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
There are two ways to force duplex & speed on a Solaris 10 box - via the
driver, and via ndd. First, via the driver: {% highlight console %} # cat
<<EOD > /platform/`uname -i`/kernel/drv/bge.conf adv_autoneg_cap=0
adv_1000fdx_cap=0 adv_1000hdx_cap=0 adv_100fdx_cap=1 adv_100hdx_cap=0
adv_10fdx_cap=0 adv_10hdx_cap=0; EOD {% endhighlight %} Note that this sets
all instances of bge to 100Mbit Full Duplex. If you wish to be more selective,
you can do this: {% highlight console %} # cat < /etc/init.d/net-tune
#!/bin/sh # Force to 100FDX NIC=bge for i in 0 1 2 3; do /usr/sbin/ndd -set
/dev/${NIC}${i} adv_1000fdx_cap 0 /usr/sbin/ndd -set /dev/${NIC}${i}
adv_1000hdx_cap 0 /usr/sbin/ndd -set /dev/${NIC}${i} adv_100fdx_cap 1
/usr/sbin/ndd -set /dev/${NIC}${i} adv_100hdx_cap 0 /usr/sbin/ndd -set
/dev/${NIC}${i} adv_10fdx_cap 0 /usr/sbin/ndd -set /dev/${NIC}${i}
adv_10hdx_cap 0 /usr/sbin/ndd -set /dev/${NIC}${i} adv_autoneg_cap 0 done EOD
# chmod 755 /etc/init.d/net-tune # ln -s /etc/init.d/net-tune /etc/rc2.d
/S68net-tune {% endhighlight %} You have to reboot for the kernel config file
to take effect, but you can run the net-tune script at any time to make it
work. You can change the 0 1 2 3 in the for do loop above to set the instances
you need.

