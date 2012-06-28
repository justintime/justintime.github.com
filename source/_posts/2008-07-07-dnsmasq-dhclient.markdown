---
title: dnsmasq + dhclient
permalink: /content/2008/07/07/dnsmasq-dhclient
layout: post
categories:
- Linux
- Networking
- VPN
- sysadmin
comments: true
sharing: true
footer: true
---
I needed to be able to use dnsmasq on my laptop so that I could
forward corporate hostname requests to our corporate DNS servers,
but send all other requests to OpenDNS' servers.  Sometimes at a
hotel, you can't use OpenDNS, so I also wanted to fail back to
whatever DNS servers were being sent via DHCP. The trick here is to
get dhclient to update a file other than /etc/resolv.conf.  You
tell dhclient to update a file named /etc/resolv.conf.dhclient,
then point /etc/resolv.conf to use localhost.  Finally, tell
dnsmasq to use /etc/resolv.conf.dhclient as its source.  Here's how
I did that on Ubuntu 8.04: First, install dnsmasq:
{% highlight console %}
sudo apt-get install dnsmasq resolvconf
{% endhighlight %}

Next, set the following in /etc/dnsmasq.conf:
    ...
    resolv-file=/etc/resolv.conf.dhclient
    server=/mycorp.com/10.253.10.83
    ...

Then restart dnsmasq:
    sudo /etc/init.d/dnsmasq restart

Now, configure your local machine to use a hardcoded  DNS server of
127.0.0.1.  I use NetworkManager, so I left click on the NM icon,
and select "Manual configuration...".  Click the DNS tab, then
click the unlock button.  Remove any existing servers in "DNS
Servers", then add 127.0.0.1.  Optionally, add any search domains
you might want to use. Now, we need to tell dhclient to a) prepend
OpenDNS' servers to the nameserver list, and b) write the DNS
config to /etc/resolv.conf.dhclient instead of /etc/resolv.conf. 
First, edit /etc/dhcp3/dhclient.conf, and add the line:
    prepend domain-name-servers 208.67.222.222, 208.67.220.220;

Now, for the part that I couldn't find using Google.  Let's tell
dhclient to update a different file:
{% highlight console %}
sudo cat   > /etc/dhcp3/dhclient-enter-hooks.d/dnsmasq <<EOD
#!/bin/sh

CUSTOM_RESOLV_CONF=/etc/resolv.conf.dhclient

make_resolv_conf() {
  if [ -n "$new_domain_name_servers" ]; then
    /bin/rm $CUSTOM_RESOLV_CONF
    [ -n "$new_domain_name" ] && echo search $new_domain_name >$CUSTOM_RESOLV_CONF
    for nameserver in $new_domain_name_servers; do
      echo nameserver $nameserver >> $CUSTOM_RESOLV_CONF
    done
  fi
}
EOD
{% endhighlight %}
Now, set it to be executable:
    sudo chmod 755 /etc/dhcp3/dhclient-enter-hooks.d/dnsmasq

Now, reboot.  When you reboot, you should have the following setup:
1.  When you get a DHCP lease, the new DNS config will be written
    to /etc/resolv.conf.dhclient
2.  This file will first contain the two OpenDNS servers, then
    whatever the ISP/Router sends as nameservers
3.  /etc/resolv.conf will point to localhost and should never
    change.
4.  Any requests for mycorp.com will go to the 10.x nameservers
    above
5.  Any requests for any other domains will first be tried through
    OpenDNS, then through the ISP's/Router's nameservers.

Hope this helps you as much as it helped me!


