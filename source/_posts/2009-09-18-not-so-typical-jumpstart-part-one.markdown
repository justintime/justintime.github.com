---
title: "Not So Typical Jumpstart: Part One"
permalink: /content/2009/09/18/not-so-typical-jumpstart-part-one
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/solaris.gif)Only in my world do you get a RHCE one week,
and then come back and work on nothing but Solaris Jumpstart for the next
couple of weeks! Oh well, it's always good as long as you're learning. What
started out as a simple upgrade from Apache 2.0 to 2.2 quickly turned into re-
provisioning our web tier. We could have upgraded, but there ended up being so
many dependencies needed I decided that it would be easier to just start fresh
with Solaris 10u7 on all our webservers. Since I knew that I'd be doing this
to all our webservers, it made sense to spend the time up-front on setup up a
completely automated installation. This time spent on the front-end should
save a huge amount of time on the back side when it comes to troubleshooting.
In my case, I learned a lot of undocumented tips and tricks, and stumbled
across a few "gotchas" as well. After going through an exercise like this, I
now know what Puppet is for, and ordered my first book. I'll give a review
once I'm done.

First of all, we already have an ISC DHCPd server running to provide Red Hat
Kickstart installs, so I decided to leverage that. Sun's DHCPd works fine, but
it's a completely different beast when it comes to configuration.

Part one of the series covers setting up your dhcpd.conf.

## Set Up Your ISC DHCP Server

There's not too much involved here, but there is a gotcha or two involved. I
used [this article on BigAdmin](http://www.sun.com/bigadmin/content/submitted/setup_dhcp.jsp) as the
primary source for this info.

When all was said and done, I had added this to my already existing
dhcpd.conf:

{% highlight console %}
# Jumpstart Support
option space SUNW;
option SUNW.root-mount-options code 1 = text;
option SUNW.root-server-ip-address code 2 = ip-address;
option SUNW.root-server-hostname code 3 = text;
option SUNW.root-path-name code 4 = text;
option SUNW.swap-server-ip-address code 5 = ip-address;
option SUNW.swap-file-path code 6 = text;
option SUNW.boot-file-path code 7 = text;
option SUNW.posix-timezone-string code 8 = text;
option SUNW.boot-read-size code 9 = unsigned integer 16;
option SUNW.install-server-ip-address code 10 = ip-address;
option SUNW.install-server-hostname code 11 = text;
option SUNW.install-path code 12 = text;
option SUNW.sysid-config-file-server code 13 = text;
option SUNW.JumpStart-server code 14 = text;
option SUNW.terminal-name code 15 = text;
option SUNW.SbootURI code 16 = text;
# Solaris 10 SPARC 05/09
group {
   use-host-decl-names on;
   next-server 192.168.0.28;
   vendor-option-space SUNW;
   option SUNW.JumpStart-server "192.168.0.28:/export/home/jumpstart/configs";
   option SUNW.install-server-hostname "192.168.0.28";
   option SUNW.install-server-ip-address 192.168.0.28;
   option SUNW.install-path "/export/home/jumpstart/install/s10u7s";
   option SUNW.root-server-hostname "192.168.0.28";
   option SUNW.root-server-ip-address 192.168.0.28;
   option SUNW.root-path-name "/export/home/jumpstart/install/s10u7s/Solaris_10/Tools/Boot";

  host web1 { 
        hardware ethernet 00:14:4f:cb:66:79;
        option SUNW.sysid-config-file-server = "192.168.0.28:/export/home/jumpstart/configs/sysids/web"; 
        }

}

{% endhighlight %}

Things of note:

  * 192.168.0.28 is the IP of our yet-to-be-setup NFS/TFTP server
  * Make note of the hostname you use in the host stanza above (web1 in our case) -- we'll need it later.

### **GOTCHA #1:**

In the [previously mentioned BigAdmin article](http://www.sun.com/bigadmin/content/submitted/setup_dhcp.jsp), you
may get the impression that the SUNW.sysid-config-file-server option is the
path to a file. **It isn't, it's the path to a directory that contains a file
named sysidcfg.** It took a packet sniffer to tell me that one.

### **GOTCHA #2:**

Note how I used IP addresses instead of hostnames in many of the options
above? I also use some abbreviations like s10u7s for "Solaris 10 Update 7
Sparc". This is due to an incompatibility between the ISC DHCP server and the
Solaris DHCP client. If the vendor specific options exceed 255 bytes, then ISC
DHCP will send another packet containing the remainder of the options.
[Solaris' DHCP client doesn't know how to deal with this](http://osdir.com/ml/network.dhcp.isc.dhcp-server/2003-03/msg00176.html).
If you swear you have everything right, but Jumpstart isn't taking off, you
might be getting bit by this. tcpdump/snoop will tell you for sure.

At this point, you should be able to test your DHCP config, and restart your
ISC DHCP server. Next, we'll setup our Solaris TFTP/NFS server with the
necessary media to allow our Jumstart installation to happen.

