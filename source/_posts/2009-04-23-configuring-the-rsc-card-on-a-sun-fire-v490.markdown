---
title: Configuring the RSC card on a Sun Fire v490
permalink: /content/2009/04/23/configuring-rsc-card-sun-fire-v490
layout: post
categories:
- sysadmin
comments: true
sharing: true
footer: true
---
I recently had to setup the RSC card on some v490's to enable remote console access.  Unfortunately, these cards only do telnet, and not SSH, but when you need console access, you have to have it!  If nothing else, at least SSH to a server sitting on the same subnet as the RSC card, then telnet over from there, limiting your exposure.  Follow the jump for a step by step howto on how to configure the RSC.

* You must first program the card via the operating system.  You can do this via the serial cable or SSH session.  Begin by installing the latest SUNWrsc package.</li>
* After installing the package, you need to run the configuration wizard: 
{% highlight console %}
cd /usr/platform/SUNW,Sun-Fire-V490/rsc/
./rsc-config
{% endhighlight %} 

The following is the output from the rsc-config wizard, adapt it to your own settings:
{% highlight console %}

Continue with RSC setup (y|n): y

Set RSC date/time now (y|n|?) [y]: y
Server Hostname [bkeapp1]: 
Edit customer info field (y|n|?) [n]: 
Enable RSC Ethernet Interface (y|n|s|?) [n]: y
   RSC IP Mode (config|dhcp|?) [dhcp]: config
   RSC IP Address []: 192.168.1.16
   RSC IP Netmask [255.255.255.0]: 
   RSC IP Gateway []: 192.168.1.1
Enable RSC Alerts (y|n|s|?) [n]: y
   Enable Email Alerts (y|n) [n]: y
      SMTP Server IP address []: 192.168.1.5
      Setup Backup SMTP Server (y|n) [n]: n
      Email address []: me@my.com
Enable RSC Serial Port Interface (y|n|s|?) [n]: y
   Serial port baud rate (9600|19200|38400|57600|115200) [9600]: 
   Serial port data bits (7|8) [8]: 
   Serial port parity (even|odd|none) [none]: 
   Serial port stop bits (1|2) [1]: 
Setup RSC User Account (y|n|?) [y]: y
   Username []: admin
   User Permissions (c,u,a,r|none|?) [cuar]: 



Verifying Selections


General Setup
  Set RSC date now  = y
  Server Hostname   = serverhostname
  Set Customer Info = n

  Is this correct (y|n): 



Ethernet Setup
  IP Mode      = config
  IP Address   = 192.168.1.16
  IP Netmask   = 255.255.255.0
  IP Gateway   = 192.168.1.1

  Is this correct (y|n): y



Alert Setup
  Email Enabled      = y
  Email Address      = me@my.com
  SMTP Server        = 192.168.1.5

  Is this correct (y|n): y


Serial Port Setup
  Serial Port Baud      = 9600
  Serial Port Data Bits = 8
  Serial Port Parity    = none
  Serial Port Stop Bits = 1


  Is this correct (y|n): y



User Setup
  User Name        = admin
  User Permissions = cuar

  Is this correct (y|n): y



This script will now update RSC, continue? (y|n): y
Updating flash, this takes a few minutes
........................................
........................................
........................................
........................................
........................................
........................................
........................................
...........................
Download completed successfully

Resetting RSC (takes about 90 seconds): DONE
Setting up server to update RSC date on boot: DONE
Setting up server hostname: DONE
Setting up ethernet interface: DONE
Setting up e-mail alerts: DONE
Disabling pager alerts: DONE
Disabling modem interface: DONE
Setting up serial port interface: DONE
Adding user to RSC:

A valid password is between 6 and 8 characters, has at least
two alphabetic characters, and at least one numeric or special
character.  The password must differ from the user's login name
and any reverse or circular shift of that login name.
Setting User Password Now ...

Password: 
Re-enter Password: 
User has been added to RSC
Resetting RSC (takes about 90 seconds):
Are you sure you want to reboot RSC (y/n)?  y

DONE
Setting up RSC date: DONE

*******************************
RSC has been successfully setup
*******************************

{% endhighlight %}

* If you haven't already, make the next reboot a reconfigure reboot by running `touch /reconfigure`
* Now that the RSC is setup, you need to tell OpenBoot to send output to it.
{% highlight console %}
eeprom input-device=rsc-console eeprom output-device=rsc-console
{% endhighlight %} 

That's it!!! You should now be able to telnet to the RSC (these things are old
enough that there is no SSH support).

