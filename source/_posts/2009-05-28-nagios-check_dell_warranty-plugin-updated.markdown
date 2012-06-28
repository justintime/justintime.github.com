---
title: Nagios check_dell_warranty Plugin Updated
permalink: /content/2009/05/28/nagios-checkdellwarranty-plugin-updated
layout: post
categories:
- Nagios
- sysadmin
comments: true
sharing: true
footer: true
---
It's been blogged about recently how cool the [check_dell_warranty
plugin](http://www.monitoringexchange.org/cgi-
bin/page.cgi?g=Detailed%2F3094.html;d=1) by Erinn Looney-Triggs is. It solves
a very real problem for us - sometimes servers run so well you forget to make
sure that you renew your support contracts. However, it wasn't quite right for
us - we have some older Dells that have RHEL 4 with an older (incompatible)
python on them still. Also, the plugin wouldn't work without configuring sudo.
Well, like any other sysadmin would do, I fixed it!  With a very small amount
of code, I added the ability to specify the serial number on the command line
with a -s parameter. This gives you a lot of flexibility:

  * It lets you run this plugin on older machines with older Python interpreters
  * It eliminates the dependency requiring a recent dmidecode
  * It eliminates the sudo dependency, no need to configure sudo
  * It gives you the ability to have your Nagios server check the warranty status on multiple hosts without using ssh/nrpe/etc.
  * If you don't use the -s flag, the plugin will function like before, using sudo and dmidecode to determine the service tag.
Erinn also found a bug at the same time I did where the check was working
properly, but it would never return a WARNING or CRITICAL state. It's fixed
now, so if you downloaded it before, make sure to get the most recent version.
Erinn was kind enough to include my changes in the main script, so [go
download it](http://www.monitoringexchange.org/cgi-
bin/page.cgi?g=Detailed%2F3094.html;d=1)!

