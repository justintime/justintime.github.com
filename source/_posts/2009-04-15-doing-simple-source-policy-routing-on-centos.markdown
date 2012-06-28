---
title: Doing Simple Source Policy Routing on CentOS
permalink: /content/2009/04/15/doing-simple-source-policy-routing-centos
layout: post
categories:
- Linux
- sysadmin
comments: true
sharing: true
footer: true
---
I'm not for sure when they did it, but the RHEL folks made it a bunch easier
to setup simple source policy routing. By using source policy routing, we fix
the issue of firewalls freaking out when the reply packet to a host leaves a
multihomed host on a different interface than what the request came in on. In
prior versions, you had to setup some custom scripts, but that's no longer the
case - all the hooks are there in the OS now.  In this example, imagine a
CentOS host with two nics. 192.168.0.2/24 is on eth0, and 10.0.0.2/24 is on
eth1. The default gateway is set to 192.168.0.1. Any host accessing 10.0.0.2
from any subnet that isn't on 10.0.0.0/24 will have it's reply packets sent
out via 192.168.0.1. Some firewalls drop this type of traffic *cough* Cisco
ASA's *cough*. Thanks to the iproute2 package in Linux, this is easy enough to
fix. RedHat has made it even easier now - we can do this in 3 steps (all
performed as root):

### Step 1: Create a table

We need to create a table for iproute2. Name it anything you want, and add it
to /etc/iproute2/rt_tables, like so: {% highlight bash %} echo -e
"200\tCorpNet" >> /etc/iproute2/rt_tables {% endhighlight %}

### Step 2: Create a route

We need to create a route for eth1 that says to use our CorpNet table defined
in Step 1. {% highlight bash %} echo "default table CorpNet via 10.0.0.1" >
/etc/sysconfig/network-scripts/route-eth1 {% endhighlight %}

### Step 3: Create a rule

We need to create a rule for eth1 that says to use our route above for traffic
received on eth1. {% highlight bash %} echo "from 10.0.0.2 table CorpNet" >
/etc/sysconfig/network-scripts/rule-eth1 {% endhighlight %}

### Step 4: Restart networking

{% highlight bash %} /etc/init.d/network restart {% endhighlight %} That's it.
Fire up a packet sniffer and verify your config!

