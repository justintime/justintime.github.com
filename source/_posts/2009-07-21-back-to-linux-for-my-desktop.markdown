---
title: Back to Linux for my Desktop
permalink: /content/2009/07/21/back-linux-my-desktop
layout: post
categories:
- Linux
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
Well, it's been just over a month [since I've converted my main workstation
over to OpenSolaris](http://www.sysadminsjourney.com/content/2009/06/16
/plunging-deep-end-running-opensolaris-my-primary-workstation). Unfortunately,
I'm going to abandon the project, and switch back to Linux as my choice as
primary desktop OS.  The main reason? Cost in productivity. It's not that I
can't build things from source, or tweak config files, but I just don't have
the time to anymore. [Unlike
OpenSolaris](http://www.sysadminsjourney.com/content/2009/06/16/fixing-
metacitys-window-placement-dual-head-setups-opensolaris), dual-head works as
expected on Linux. I had to [do
voodoo](http://www.sysadminsjourney.com/content/2009/07/07/making-home-and-
end-work-they-do-linux-opensolaris) to make the home and end keys work in the
gnome-terminal. Little things, like gcc being the first compiler found in
PATH, but most binaries on the system being compiled with SunStudio cc cause
larger issues like [CPAN not working
correctly](http://www.sysadminsjourney.com/content/2009/06/19/fixing-cpan-
perl-module-installation-issues-opensolaris). Certain things just aren't even
there yet, like virtual consoles, which are invaluable when troubleshooting
Xorg issues. Each one of these issues is fixable, but the key is that they
don't exist in the first place when I use Linux. The lack of graphics
acceleration for my card turned out to be more of an issue that I would have
thought (you want your desktop environment to be snappy). Also, not being able
to use the AHCI mode on my SATA controller killed disk I/O. Since OpenSolaris
has far fewer adopters than Linux, binary-only applications often don't
release binaries for OpenSolaris ([Dropbox](http://www.getdropbox.com) for
example). The community is growing, and is very helpful, but it's not near
anywhere as massive as the Linux community. Often times, Google searches
result in no hits when troubleshooting. Don't get me wrong, it's not that I
dislike OpenSolaris, or the direction it's going. The opposite is true - I
love it! ZFS is truly incredible, and SMF is a godsend. IPS, while a long ways
from being as fast and comprehensive as apt-get, is a huge improvement over
the old way. In fact, one of the first things I plan on doing in Linux is
installing VirtualBox and installing OpenSolaris within it. To summarize, when
using OpenSolaris as my primary desktop OS, the "you gotta be kidding me"'s
and the "dammit"'s far outnumbered the "ooh"'s and "ahh"'s. By using Linux as
my desktop OS and OpenSolaris as a VM, I can isolate myself from the
negatives. I just can't afford the impact to my productivity right now. As
long as Oracle doesn't muck too much with the current state of affairs,
there's a good chance that in a year or two, I'll try again and have much
better luck. Until then, OpenSolaris will be on my VM's and Servers, but won't
be on my workstation.

