---
title: Per-subnet routing with Solaris 10 non-global zones
permalink: /content/2008/05/08/subnet-routing-solaris-10-non-global-zones
layout: post
categories:
- Networking
- Solaris
- Sun
- Virtualization
- sysadmin
comments: true
sharing: true
footer: true
---
<p>I had the chance to finally tinker with Solaris 10 zones the other day. They are impressive - very easy to setup! One of my biggest gripes about Solaris is that they've fallen way behind in the area of advanced IP routing. If you want to do things like policy routing in Solaris, you have to install ipfilter, which is no easy task. There is no alternative to iproute2 in Linux. Read after the jump to find a quick hack to setup proper routing for non-global zones on multiple subnets. <!--break--> <em>Update: If you are using Solaris 10 Update 4 or newer, you may be able to use </em><code>set ip-type=exclusive</code><em> in your zone config. This will give you what I've hacked together here. Note, that you must have a dedicated interface for the zone in order to use it, and there are some other limitations, <a href="http://docs.sun.com/app/docs/doc/817-1592/gepxo?l=en&amp;a=view">described here</a>. Keep an eye on <a href="http://opensolaris.org/os/project/crossbow/">project Crossbow</a>, which will hopefully make all of this go away.</em> In Solaris 10, you set the default gateway at boot time by using /etc/defaultrouter. You can add multiple default routes by adding multiple lines to that file. However, if you do that, the kernel will simply round-robin the packets between the gateways, which will light up any firewall like a Christmas tree. Imagine the following scenario: HostA is a Solaris 10 box with 4 bge interfaces. HostA's IP address is 192.168.20.2/24 and is assigned to bge0. The router for the 192.168.20.0/24 subnet is at 192.168.20.1. HostB is a non-global zone residing on HostA, with an IP address of 192.168.30.2/24 and you've assigned it to bge1 via zonecfg. The router for the 192.168.30.0/24 subnet is at 192.168.30.1. Now, non-global zones don't have their own kernel, they "share" with the global zone. IP routing is handled in the kernel, so the routing configuration for the non-global zone needs to be done in the global zone. The first trick here is to get bge1 to come up on bootup, but not assign it an IP. Do this as root on HostA to establish that:</p>
<pre># echo "0.0.0.0" &gt; /etc/hostname.bge1</pre>
<p>This will plumb and bring up the interface, but it will not be assigned an IP. Now, remember what I said about the kernel round-robin routing packets earlier? It will only do that <strong>if both gateways are reachable</strong>. So, the trick is to make HostB's gateway unreachable from HostA, and HostA's gateway unreachable from HostB. There's a catch-22 here as well, you can only add a default route if the gateway is currently reachable. So how in the world do we get this to work??? With some nice hackery, of course! First, set HostB's configuration so that it does not boot automatically. Don't worry if you need this functionality, we've got a hack for that too:</p>
<pre>root@HostA # zonecfg -z HostB
zonecfg:HostB&gt; set autoboot=false
zonecfg:HostB&gt; verify
zonecfg:HostB&gt; commit
zonecfg:HostB&gt; exit</pre>
<p>Now, we are going to create our own init script that will bring up bge1 temporarily with HostB's IP, set the default route, then remove that IP. By using HostB's IP, we are allowed to set the route, but when we remove the interface, HostB's gateway becomes unreachable from HostA. Finally, we boot HostB, which sees only the default route for it's interface. Let's setup that init script:</p>
<pre># cat &lt;&lt;EOD &gt; /etc/init.d/zoneboot
#!/usr/bin/sh

/usr/sbin/ifconfig bge1 addif 192.168.30.2/24 up
/usr/sbin/route add default 192.168.30.1
/usr/sbin/ifconfig bge1 removeif 192.168.30.2
/usr/sbin/zoneadm -z HostB boot
EOD

# ln -s /etc/init.d/zoneboot /etc/rc3.d/S99zoneboot</pre>
<p>You can of course modify this script to work with more interfaces and zones, but you get the idea. Now, reboot HostA. HostA's routing table looks like so:</p>
<pre># netstat -rn

Routing Table: IPv4
  Destination           Gateway           Flags  Ref     Use     Interface
default              192.168.30.1          UG       1        119
default              192.168.20.1          UG       1        112
192.168.20.2         192.168.20.2          U        1         35 bge0
224.0.0.0            192.168.20.2          U        1          0 bge0
127.0.0.1            127.0.0.1             UH       4        113 lo0</pre>
<p>HostA has two default gateways, but only one of them is reachable. Bingo! HostB's routing table looks like this:</p>
<pre>
Routing Table: IPv4
  Destination           Gateway           Flags  Ref     Use     Interface
default              192.168.30.1           UG      1        112
192.168.30.0         192.168.30.2           U       1         27 bge1:1
224.0.0.0            192.168.30.2           U       1          0 bge1:1
127.0.0.1            127.0.0.1              UH      4        108 lo0:2</pre>
<p>Success! Hope you found this helpful!</p>

