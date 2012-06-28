---
title: "Set it and forget it: Tether your Windows Mobile 6 Phone to Linux"
permalink: /content/2008/09/06/set-it-and-forget-it-tether-your-windows-mobile-6-phone-linux
layout: post
categories:
- Linux
- Networking
- QuickTips
- Ubuntu
- sysadmin
comments: true
sharing: true
footer: true
---
I have a love/hate relationship with my phone - an HTC PPC6800. I can't live
without it - I can check my work email from anywhere, and surf the web. While
I've tried many PDA's through the years, none of them have stuck, because I
got tired of lugging them around. I **always** have my phone with me, so
therefore my smartphone has made me much more organized. My wife loves it
because I can remember all the upcoming appointments. Yet, I hate it. It's UI
is horrible. It locks up and needs rebooted, and I feel dirty using a M$
product. Well, I found one more reason to like it. I can tether my Ubuntu
laptop to my phone and get Internet access from just about anywhere. This
howto is for Ubuntu, but it should work for any distro that uses bluez-utils.
Note that I briefly tried to get my laptop tethered via USB, but I found
several comments that it wouldn't work without a custom kernel module.
Bluetooth is easier, works out of the box, and is much cooler besides ;-)
First things first, let's install the prerequisites:

    
    
    sudo apt-get install bluez-utils bluetooth bluez-gnome bluez-hcidump
    

Next, enable the bluetooth applet in Gnome. Navigate to
"System->Preferences->BlueTooth Preferences". On the "Devices" tab, click
"Other devices can connect". Now we need to pair your phone to your PC. From
your phone, click Start->Settings. Click on the Connections tab, and click the
Bluetooth icon. Click "Add new device..." and choose the entry for your
computer from the list. You will be asked for a passcode and when you enter it
on your phone, the bluetooth applet will pop up saying that your phone is
trying to connect. Click on the ballon and enter the same passcode.
Congratulations, you have paired your phone to your PC! Now, let's find the
hardware address of your phone:

    
    
    sudo hcitool scan
    

Document the 12 digit hex address somewhere, we'll need it later. Now, open up
**/etc/default/bluetooth** in your favorite text editor. Find the line that
states:

    
    
    PAND_ENABLED=0
    

and change the zero to a one like so:

    
    
    PAND_ENABLED=1
    

Next, find the line which looks like:

    
    
    PAND_OPTIONS=""
    

and change that to:

    
    
    PAND_OPTIONS="--persist --connect XX:XX:XX:XX:XX:XX --role=PANU \
     --devup /etc/bluetooth/pan/dev-up --devdown /etc/bluetooth/pan/dev-down"
    

changing the XX's to the hardware address of your phone. Now, let's run the
following to create the scripts we need: {% highlight console %} sudo sh -c
'mkdir -p /etc/bluetooth/pan && \ echo "iface bnep0 inet dhcp" >>
/etc/network/interfaces && \ for i in up down; do touch
/etc/bluetooth/pan/dev-$i chmod 755 /etc/bluetooth/pan/dev-$i echo
"#!/bin/bash" > /etc/bluetooth/pan/dev-$i echo "/sbin/if$i bnep0" >>
/etc/bluetooth/pan/dev-$i done && \ /etc/init.d/networking restart && \
/etc/init.d/bluetooth restart' {% endhighlight %} Finally, on your phone click
Start->Programs->Internet Sharing. Select "Bluetooth PAN" on the PC Connection
drop-down, and select the appropriate WAN Network Connection. One more note
before you're off and surfing the 'net on your tethered phone: your bluetooth
connection can't be managed by NetworkManager because bluez-utils doesn't make
use of DBUS. So, in order to use your bluetooth connection, right click on
your Network Manager icon, and select "Enable Networking" to disable
NetworkManager. When you're done, right click and reselect "Enable Networking"
to switch things back. Okay, that's out of the way. Click on "Connect" on your
phone. As your phone is connecting, your Linux box will see your phone, and
connect to it. Once the connection is established, your Linux box will get a
DHCP-assigned IP from your phone. To verify all this, run the following
command:

    
    
    /sbin/ifconfig bnep0
    

You should see the interface, and see that it's been assigned an IP. After you
have the address, you can freely browse the Internet. To disconnect, simply
click "Disconnect" on your phone. Don't forget to re-enable networking via
NetworkManager. Props go out to the following places in helping me determine
how to do this in the first place:

  * [InfoSec812's post in the Ubuntu forums](http://ubuntuforums.org/archive/index.php/t-598890.html)
  * [The bluez-utils howto](http://bluez.sourceforge.net/contrib/HOWTO-PAN)
  * The pand manpage, because I always RTFM ;-)
Enjoy! Stay tuned for a post on how to sync your WM6 phone to Linux.

