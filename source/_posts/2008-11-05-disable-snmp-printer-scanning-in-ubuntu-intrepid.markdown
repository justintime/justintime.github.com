---
title: Disable SNMP Printer Scanning in Ubuntu Intrepid
permalink: /content/2008/11/05/disable-snmp-printer-scanning-ubuntu-intrepid
layout: post
categories:
- Linux
- Ubuntu
- sysadmin
comments: true
sharing: true
footer: true
---
After installing Ubuntu Intrepid on my laptop, I got a nastygram
from IT saying that my laptop was tripping alerts from their NIDS. 
They could tell me that it was an outbound SNMP request, but they
couldn't supply the OID or anything.  Setting aside the fact that
the NIDS should be configured to disregard SNMP requests for this
particular OID, I set forth to try and figure out what the heck was
causing the traffic. After much tcpdumping, I finally found the
OID: 1.3.6.1.2.1.25.3.2.1.3.1.  Googling told me that this OID
corresponds to a printer name.  At this point, I knew that it was
coming from CUPS.  Now, one would think that there is a simple
on/off switch in CUPS that you could use to disable SNMP scanning. 
Nope!  You can remove the snmp binary from the CUPS distribution,
but the next time CUPS is installed/upgraded, you'll be in the same
boat. On a hunch, I edited /etc/cups/snmp.conf to look like so:
    #Address @LOCAL
    Address 127.0.0.1

Lo and behold, it worked!  Instead of disabling SNMP scanning, I
told CUPS to only scan the localhost IP instead of the entire local
LAN subnet.  After applying this change and restarting CUPS, I
checked with IT.  The NIDS alerts had indeed stopped generating
alerts! **Notes** It turns out the snmp auto-detection stuff had
been removed from previous versions of Ubuntu.  After much
bemoaning from users, the package maintainers put it back in
place.  This is why I have the issue on Intrepid and not on
previous versions. I don't really know what the optimal solution is
here.  The fact that my laptop was broadcasting SNMP requests to
the entire corporate subnet is a little disturbing, if harmless. 
However I see where it would be nice to have in a SOHO
environment.  I personally would prefer a "disabled by default"
approach with a very simple checkbox mechanism to enable it, but
I'm certainly biased. Anyways, hope this helps some people out
there. When I ran into this issue, Google didn't have any help for
me.


