---
title: iptables Options in RHEL/CentOS
permalink: /content/2009/08/19/iptables-options-rhelcentos
layout: post
categories:
- RedHat
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/logo_rh_home.png)Today in class we were talking about how
you needed to save your iptables changes using **service iptables save**
before rebooting at the end of the test, or else you'll fail that section of
the test. I brought up the setting IPTABLES_SAVE_ON_STOP to "yes" in
/etc/sysconfig/iptables-config, and no one else knew about that file. There's
some pretty cool settings in there - read on for details.

The file /etc/sysconfig/iptables-config provides a place to configure the
behavior of the iptables initscript in /etc/init.d/iptables. The file is
documented **very** well, so give it a quick read. Here's some of the more
interesting settings:

  * **IPTABLES_SAVE_ON_STOP** - this defaults to "no". When set to "yes", every time the initscript is called with the argument of "stop" (whether via command line or via system shutdown), the initscript will take the current iptables ruleset and dump it into /etc/sysconfig/iptables. Essentially, this is doing a **service iptables save **behind the scenes when you do a **service iptables stop**. This is great for sysadmins who get distracted often and forget to commit their iptables commands to persistent storage often.
  * **IPTABLES_SAVE_ON_RESTART** - defaults to "no". When set to "yes", it does the exact same thing as **IPTABLES_SAVE_ON_START** except this does a save operation when the initscript is called with the "restart" option.
  * **IPTABLES_SAVE_COUNTER** - defaults to "no". Everytime **service iptables save** is called (including in the two cases above), the rule and chain counters are saved to the file, and restored on startup. This prevents your counters from being reset every time you restart the service.
  * **IPTABLES_STATUS_NUMERIC** - defaults to "yes". When you do a **service iptables status**, this will print IP's instead of hostnames when set to "yes". When set to "no", it will do reverse DNS lookups on all the IP's and /etc/services lookups on all ports.
  * **IPTABLES_STATUS_VERBOSE** - prints packet and byte counters in the output of **service iptables status**.

There's a few other settings in there, but these are the ones that I'm usually
interested in. Happy firewalling!

