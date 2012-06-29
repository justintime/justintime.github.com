---
title: Use NetworkManager to launch scripts based on Network Location
permalink: /content/2008/12/18/use-networkmanager-launch-scripts-based-network-location
layout: post
categories:
- Linux
- Ubuntu
- sysadmin
comments: true
sharing: true
footer: true
---
[NetworkManager][] is fast becoming the de facto network provider in
desktop Linux distributions. The reason it’s so popular is that it “does
the right thing” 99% of the time. However, there’s not many examples out
there that extend that functionality. NetworkManager provides hooks in
which you can have scripts launch when network settings change. In
today’s post, I will show you how to launch the [Synergy][] client
whenever you plug into your corporate network.

<!--break-->

I’m lazy. I hate having to fire up my Synergy client on my laptop to
connect to my desktop at work when I get to work everyday. Now, I could
just fire up the Synergy client at boot, but when I’m at home if I have
the VPN connected, Synergy will hook up and I don’t want it to.

I needed a way to fire a script that says “if I’m on this network, then
fire up synergyc, otherwise do nothing”. Writing the script was pretty
easy, but I was stumped on how to get to run not only at bootup, but
whenever I change networks – I very often suspend my laptop at night at
home and resume it at work the next morning.

It turns out that NetworkManager has a piece called
NetworkManagerDispatcher that does all of this for us. Any script in
/etc/NetworkManager/dispatcher.d will be called with two arguments, the
name of the interface, and the status of the interface (up/down).

If a picture is worth a thousand words, scripts are worth a million, so
let’s get to it.

First, a little background is needed. I know that I am on my corporate
network if my eth0 interface has obtained an IP in the 10.0.0.0/8
subnet. Without further ado, I present to you
/etc/NetworkManager/dispatcher.d/99smartsynergy.sh:

``` bash
#!/bin/sh
IF=$1
STATUS=$2
USER=justintime

wait_for_process() {
  PNAME=$1
  PID=`/usr/bin/pgrep $PNAME`
  while [ -z "$PID" ]; do
        sleep 3;
        PID=`/usr/bin/pgrep $PNAME`
  done
}

start_synergy() {
     wait_for_process nm-applet
     /bin/su $USER -c "/usr/bin/synergyc $1"
}

if [ "$IF" = "eth0" ] && [ "$STATUS" = "up" ]; then

        #LAN Subnet at work
        NETMASK="10.0.0.0/8"
        if [ -n "`/sbin/ip addr show $IF to $NETMASK`" ]; then
                ARGS="jentoo.bucklehq.com"
                start_synergy $ARGS
                exit $?
        fi

fi
```

The **IF** and **STATUS** variables are those fed in from
NetworkManager. The **USER** variable is the user that I run synergyc
as. You could add some intelligence here, but it was overkill for my
situation.

The **if** at the bottom states that we are only concerned if the
interface eth0 has changed it’s status to “up”. I then use the
**/sbin/ip** command to determine if eth0 is within the 10.0.0.0/8
subnet. If so, then I call start\_synergy, passing it my desktop’s
hostname.

Within the **start\_synergy()** function we call the
**wait\_for\_process** function, passing it **nm-applet**. We need this
function because if we try to run synergyc before I’ve logged in via
GDM, it will exit (this happens on bootup). By calling
**wait\_for\_process**, we create a way to make synergyc wait until
after the nm-applet (NetworkManager Applet) has started. Finally, once
nm-applet has been detected as running, the script executes synergyc,
and exits.

### TODO’s

-   I should probably create a function that kills the remaining
    synergyc processes when eth0 goes down.
-   If there’s already a synergyc running, we should just exit as the
    client will continue to try to reconnect.

### Conclusion

The purpose of this article wasn’t to show you how to launch synergyc
(although I think it’s really handy), it was to get the creative juices
flowing. Have you already utilized NetworkManagerDispatcher for
something? What would you like to have it do? Comment away!

  [NetworkManager]: http://projects.gnome.org/NetworkManager/
  [Synergy]: http://synergy2.sourceforge.net/

