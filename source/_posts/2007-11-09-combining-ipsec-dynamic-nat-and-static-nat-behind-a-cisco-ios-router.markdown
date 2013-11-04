---
title: Combining IPSEC, Dynamic NAT, and Static NAT behind a Cisco IOS Router
permalink: /content/2007/11/09/combining-ipsec-dynamic-nat-and-static-nat-behind-cisco-ios-router
layout: post
categories:
- Cisco
- Networking
- VPN
- sysadmin
comments: true
sharing: true
footer: true
---
Trying to combine IPSEC, dynamic NAT, & static NAT on a Cisco router? Check
out [Cisco's article on how to do it](http://www.cisco.com/en/US/tech/tk583/tk372/technologies_configuration_example09186a0080094634.shtml) first. If that
doesn't work and you're ready to drop kick the router out of the datacenter
like I was, put away your black belt for a few minutes, and read about how I
worked around a couple of bugs. Let's define our problem first.

  * You have two subnets connected via IPSEC VPN - for the purposes of this article, 192.168.10.0/24 and 192.168.11.0/24. We assume the VPN is already up and functional.
  * You want any host with an IP in the 192.168.11.0/24 subnet to have access to the Internet as well as access to the hosts on the other side of the IPSEC tunnel.
  * You have one host, in this case 192.168.11.5, that you want to have access to the 192.168.10.0/24 subnet, as well as have a static NAT'd IP address when accessing the Internet - in this case, 1.1.1.1.
It took me a couple days, and I still think there's a bug in there somewhere,
but I did finally get it to work. The IOS I was using was 12.4(17). Now,
here's my personal take on what I think happens that causes things to break.
Again, I worked on this for 2 days straight, so I'm a little blurry on
everything, but I do know that this method works. According to [ Cisco's artic
le](http://www.cisco.com/en/US/tech/tk583/tk372/technologies_configuration_example09186a0080094634.shtml), you can get these results by simply using route-maps on your static NAT commands. Almost, but not really. I found two other
requirements had to be in place before the NAT's would work as they were
supposed to:

  * Only one route-map can be used in all of your NAT statements. I think this is a bug, as no one specifies this as being a rule, but I even went as far as to create two identical route-maps with different names, and set up two static NAT's with each NAT rule using one route-map. This would not work until I set both static NAT rules to use the same route-map. The same goes for the dynamic NAT rule, which is why we use an access-list here.
  * Once you use a route-map in your static NAT's, then the order in which the NAT statements are processed is reversed. Again, I think this is a bug. Basically, normal NAT rule processing dictates that the static NAT rules are evaluated before the dynamic ones. In my situation, this was true until I enabled the route-map option on the static NAT. If I eliminated the route-map option, the static NAT worked, but the host being static NAT'd could not access hosts on the other side of the VPN. Once I enabled the static NAT with the route-map option, I could access the hosts on the other side of the VPN, but was getting the dynamic NAT applied instead of the static NAT.
Step One: Configure Dynamic NAT We first need to setup an access list that
will:

    * **NOT NAT** packets from our host that needs static NAT applied.
    * **NOT NAT** packets that traverse the VPN.
    * **NAT** packets from our 192.168.11.0/24 subnet to everywhere else.
    
     ``` 
    ip access-list extended NoNat
     deny   ip host 192.168.11.5 any
     deny   ip 192.168.11.0 0.0.0.255 192.168.10.0 0.0.0.255
     permit ip 192.168.11.0 0.0.0.255 any
     ```
    

Then, we use this command to setup dynamic NAT:

    
    
    ip nat inside source list NoNat interface GigabitEthernet0/0 overload
    

At this point, you should be able to access the Internet from any host with a
192.168.11.x address but not 192.168.11.5, as well as be able to access hosts
on the 192.168.10.0 subnet. Step Two: Setup Static NAT So, right now,
192.168.11.5 can access hosts across the tunnel, but not access anyplace on
the Internet. All other hosts on the 192.168.11.0/24 subnet can access both.
Again, according to the Cisco article above, we shouldn't have to do this, but
I did. Since we have excluded our 192.168.11.5 host from being NAT'd at all,
we need to craft a route-map for him to be static NAT'd, but not NAT'd when
accessing the remote VPN hosts. This boils down to creating an ACL identical
to the one above minus one line:

    
    
    ip access-list extended NoNatStatic
     deny   ip 192.168.11.0 0.0.0.255 192.168.10.0 0.0.0.255
     permit ip 192.168.11.0 0.0.0.255 any
    

Now, create a route-map that points to this ACL:

    
    
    route-map nonat-static permit 10
     match ip address NoNatStatic
    

Finally, setup your static NAT rule:

    
    
    ip nat inside source static 192.168.11.5 1.1.1.1 route-map nonat-static
    

Finally, all your NAT rules should be working perfectly now. In order to add
new static NAT's, you simply need to add the local IP address to the top of
the NoNat ACL, and then create a new static NAT rule the points to the same
route-map. Do not use a different route-map, or you will run into the bug
above. Let me re-iterate that Cisco's article above is cleaner, and that I
tried other cleaner ways of implementing this setup. If you have the time, try
to get your setup working using the article above. However, if you can't get
it to work, try my way and see if you get the results you're looking for.

