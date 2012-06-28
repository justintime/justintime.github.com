---
title: VPS.net review
permalink: /content/2011/11/14/vpsnet-review
layout: post
categories:
- Reviews
- sysadmin
comments: true
sharing: true
footer: true
---
I've been running a single node from [VPS.net](http://vps.net) for about a
year now.  Please note that my specific experience has been in their "Chicago
Zone D data center", but if you check out their [status
page](http://status.vps.net) or search
[Twitter](http://twitter.com/#!/search/%23vpsnet), you'll find a lot of others
having the same issues.  While there's a lot of good things to write about,
where they fail is the most important area to me: availabilty. The pros of
using VPS.net include pricing, control panel, and console level access.  As is
typical for a VPS provider, they give you many "add-on" options such as
backup, etc that you can enable -- I've not investigated them myself.  Perhaps
the one of the nicest features is the ability to add server resources or
"nodes" on the fly with minimal downtime. However, it seems that VPS.net has
made a horrible choice in selecting what SAN they use to back their VM's.
Examine the graphic below: ![](/assets/images/vps-net-availabiltiy.png) As you
can see, I'm getting less than 2 nines worth of uptime from my node.  Each and
everytime there's been an issue, support has been quick to point out that
they've had some sort of SAN issue, and that the SAN is 'resyncing'.  The
problem is that while the SAN is resyncing, I/O to my node is so horrible, I
can't cat a 500 byte file to stdout in less than 10 seconds.  So, the node
will respond to a ping, but it can't serve up a static image via Apache.  For
all intents and purposes, that's down in my book. The [last SAN
synchronization](http://status.vps.net/2011/10/chi-d-cloud/) took the better
part of two days, during which time my node was unusable. In my experience,
the SAN is the most important building block when architecting a service
that's meant to be highly available.  Until VPS.net can address their SAN
issues, they are likely to continue to have prolonged downtimes.  Until that's
been fixed, there's just no way I can recommend their services to anyone.

