---
title: How to Setup the ALOM card on a Sun Fire v210
permalink: /content/2009/04/23/how-setup-alom-card-sun-fire-v210
layout: post
categories:
- sysadmin
comments: true
sharing: true
footer: true
---
Here's a step-by-step howto on how to configure the ALOM card on a Sun Fire
server so that it's accessible over the network via SSH. It should also work
for Sun Fire V210, V215, V240, V245, V445, V250, V440, and V445 servers as
well.  You must first program the card via the operating system. You can do
this via the serial cable or SSH session.

  * First, cd into the proper directory: 
    
    
    cd /usr/platform/`uname -i`/sbin
    

  * Now, show the current version of firmware on the card: 
    
    ./scadm version

If it's not version 1.6, [download the latest from Sun](https://cds.sun.com
/is-bin/INTERSHOP.enfinity/WFS/CDS-CDS_SMI-Site/en_US/-/USD/ViewProductDetail-
Start?ProductRef=ALOM-1.6-G-F@CDS-CDS_SMI)

    * Current latest version of firmware is 1.6.9, you will download the file ALOM_1.6.9_fw_hw0.tar.gz
    * Run the following commands to update firmware:
    
    
    mkdir /usr/platform/`uname -i`/lib/images
    cd /usr/platform/`uname -i`/lib/images
    gzip -dc ~/ALOM_1.6.9_fw_hw0.tar.gz | tar xvf - 
    /usr/platform/`uname -i`/sbin/scadm download boot alombootfw; echo "done, now sleeping for 60 seconds"; sleep 60
    /usr/platform/`uname -i`/sbin/scadm download alommainfw
    

After a couple minutes, the card should be ready for use.

  * Now display the current configuration like so: 
    
    ./scadm show

You should get output like this:

    
    
    if_network="true"
    if_modem="false"
    if_emailalerts="false"
    sys_autorestart="xir"
    sys_bootrestart="none"
    sys_bootfailrecovery="none"
    sys_maxbootfail="3"
    sys_xirtimeout="900"
    sys_boottimeout="120"
    sys_wdttimeout="60"
    netsc_tpelinktest="true"
    netsc_dhcp="false"
    netsc_ipaddr="0.0.0.0"
    netsc_ipnetmask="255.255.255.0"
    netsc_ipgateway="0.0.0.0"
    mgt_mailhost=""
    mgt_mailalert=""
    sc_customerinfo=""
    sc_escapechars="#."
    sc_powerondelay="false"
    sc_powerstatememory="false"
    sc_clipasswdecho="true"
    sc_cliprompt="sc"
    sc_clitimeout="0"
    sc_clieventlevel="2"
    sc_backupuserdata="true"
    sys_eventlevel="2"
    

  * Let's setup the card so that it can be reached via SSH. Run the following commands, replacing the IP settings with your own: 
    
    
    ./scadm set if_network true
    ./scadm set netsc_tpelinktest true
    ./scadm set netsc_ipaddr 192.168.1.18
    ./scadm set netsc_ipnetmask 255.255.255.0
    ./scadm set netsc_ipgateway 192.168.1.1
    ./scadm set sc_cliprompt srv1-mgmt
    ./scadm set mgt_mailalert "me@my.com 3"
    ./scadm set mgt_mailhost 192.168.1.5
    ./scadm userpassword admin
    ./scadm set if_connection ssh
    ./scadm set if_emailalerts true
    

  * Verify your configuration by doing a 
    
    ./scadm show

When done, you need to reset the SC, like this:

    
    ./scadm resetrsc

You're done!

