---
title: "Not So Typical Jumpstart: Part Three - The Jumpstart Profile"
permalink: /content/2009/09/22/not-so-typical-jumpstart-part-three-jumpstart-profile
layout: post
categories:
- Solaris
- Sun
- Jumpstart
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/solaris.gif)In [part two of the series](http://www.sysadminsjourney.com/content/2009/09/21/not-so-typical-jumpstart-part-two), we left off with a non-working Custom Jumpstart setup. By
creating our Jumpstart profile file and a sysidcfg file, we'll have a basic,
but working Custom Jumpstart. The profile contains settings specific to the
installation, where the sysidcfg file contains settings specific to the
machine during and after installation.

## Step One: Create the sysidcfg file

If you've been following along, we specified the path to web1's sysidcfg file
when we generated our dhcpd.conf file in [part one](http://www.sysadminsjourney.com/content/2009/09/18/not-so-typical-jumpstart-part-one). Let's create this file, so that the installer doesn't
have to ask us these questions during the installation:

{% highlight console %}
cd /export/home/jumpstart/configs
mkdir -p sysids/web
cat <<EOD > sysids/web/sysidcfg
keyboard=US-English
system_locale=en_US.UTF-8
security_policy=NONE
nfs4_domain=domain.com
name_service=DNS {domain_name=domain.com name_server=192.168.0.5}
network_interface=bge0 { protocol_ipv6=no
                         primary
                         hostname=bkeweb1
                         ip_address=192.168.0.21
                         default_route=192.168.0.10
                         netmask=255.255.255.0
                        }
terminal=vt100
timezone=US/Central
timeserver=localhost
root_password=8X123/ZkOFICY
service_profile=limited_net
EOD

{% endhighlight %}

You should read the manpage for sysidcfg, but in our example above some of the
not-so-obvious settings are:

  * **security_policy=NONE** is relative to the kerberos security settings during installation.
  * **root_password** the value of root's password as written in a real /etc/shadow file.
  * **service_profile=limited_net** - using limited_net disables unnecessary services and restricts others to localhost access only. I recommend this setting for anyone not in a lab environment.

## Step Two: Create the profile file

There's a huge amount of operations you can configure via the jumpstart
profile - I recommend reading [Sun's documentation on creating a Jumpstart profile](http://docs.sun.com/app/docs/doc/820-7014/preparecustom-53442?l=en&a=view). I also owe a link to the [Keep DaLink](http://kdl.nobugware.com/post/2009/07/28/ultimate-solaris-10-jumpstart-profile/) blog for a nice list of clusters and packages to install. Using this
profile below will result in an installation with pretty much every command
line tool you would need, minus any X11/Gnome packages. Here's the contents of
my Jumpstart profile:

{% highlight console %}
cat <<EOD > webserver
install_type    initial_install
system_type     standalone
#pool           name  size swap dump devices
#pool           rpool auto auto auto mirror c0t0d0s0 c0t1d0s0
pool            rpool auto auto auto any
bootenv         installbe bename s10_u7 
partitioning    default

# base cluster
cluster SUNWCreq
# additional clusters and packages
cluster SUNWCacc add # System accounting utilities
cluster SUNWCadm add # System And Network Administration (showrev etc)
cluster SUNWCcpc add # CPU Performance Counter driver and utilities
cluster SUNWCcry add # Supplemental cryptographic modules and libraries
cluster SUNWCfwcmp add # Freeware Compression Utilities (bzip zip zlib gzip)
cluster SUNWCfwshl add # Freeware Shells (bash tcsh zsh)
cluster SUNWCfwutil add # Freeware Other Utilities (gpatch less rpm)
cluster SUNWCgcc add # GNU binutilis, C compiler, m4 and make
cluster SUNWCged add # Gigabit Ethernet Adapter Software
cluster SUNWCjv add # JavaVM
cluster SUNWCjvx add # JavaVM (64-bit)
cluster SUNWClibusb add # wrapper for libusb; user level usb ugen library
cluster SUNWClu add # Live Upgrade Software
cluster SUNWCntp add # Network Time Protocol
cluster SUNWCopenssl add # the classical super-old Solaris OpenSSL
cluster SUNWCpd add # PCI drivers
cluster SUNWCperl add # perl5
cluster SUNWCpm add # Power Management Software
cluster SUNWCpmgr add # Patch Manager Software
cluster SUNWCpool add # core software for resource pools
cluster SUNWCptoo add # Programming tools and libraries
cluster SUNWCrcapu add # Solaris Resource Capping Daemon
cluster SUNWCsma add # Solaris Management Agent (snmpd)
cluster SUNWCssh add # Secure Shell Client/Server
cluster SUNWCts add # Solaris Trusted Extensions
cluster SUNWCusb add # USB drivers and header files
cluster SUNWCutf8 add # en_US.UTF-8 locale support
cluster SUNWCvld add # Sun Ethernet Vlan Utility
cluster SUNWCvol add # Volume Management
cluster SUNWCwget add # GNU wget
cluster SUNWCzone add # Solaris Zones
package SUNWarc add # Lint Libraries (usr)
package SUNWarcr add # Lint Libraries (root)
package SUNWman add # On-Line Manual Pages
package SUNWdoc add # Documentation Tools
package SUNWsfwhea add # Open Source header files
package SUNWtoo add # Programming Tools
package SUNWhea add # SunOS Header Files
package SUNWxcu4 add # XCU4 Utilities
package SUNWxcu4t add # XCU4 make and sccs utilities
package SUNWxcu6 add # XCU6 Utilities
package SUNWgcmn add # gcmn - Common GNU package
package SUNWggrp add # ggrep - GNU grep utilities
package SUNWgtar add # gtar - GNU tar
package SUNWuium add # ICONV Manual pages for UTF-8 Locale
package SUNWladm add # Locale Administrator (really optional)
package SUNWGlib add # GLIB - Library of useful routines for C programming
package SUNWPython-share add # python
package SUNWPython add # python
package SUNWfss add # Fair Share Scheduler
package SUNWscpr add # /usr/ucb tools
package SUNWscpu add # /usr/ucb tools
package SUNWrsg add # needed by sshd
package SUNWgssdh add # needed by sshd
package SUNWspnego add # needed by sshd
package SUNWbind add # host&dig

# optional clusters and packages
#cluster SUNWCapache add # Apache 1.3.9
#cluster SUNWCapch2 add # Apache 2
#cluster SUNWCpostgr add # PostgreSQL
#cluster SUNWCpostgr-82 add # PostgreSQL 8.2
#cluster SUNWCdhcp add # DHCPv4 Services
#cluster SUNWCtcat add # Tomcat Servlet/JSP Container
#package SUNWmysqlr add # MySQL (Root)
#package SUNWmysqlu add # MySQL (User)

# The following are for webstack dependencies
package         SUNWfontconfig
package         SUNWfreetype2
package         SUNWjpg
package         SUNWpng
package         SUNWxwplt
package         SUNWpostgr-82-libs
EOD
{% endhighlight %}

After running an install with this profile, you will end up with a ZFS root
that contains just under 2GB worth of data. If that's not your desired setup,
then tweak away!

## Step Three: Validate the profile file

The last step in this article is to validate the rules file and its associated
profiles. Run the following:

{% highlight console %}
# ./check
Validating rules...
Validating profile webserver...
The custom JumpStart configuration is ok.
{% endhighlight %}

This process validates your config files, and creates a rules.ok file in the
root of your config server directory. It is this file that the client loads
and parses when starting a Jumpstart installation.

This concludes part three of the series. You should now be able to boot using
PXE for X86 or using 'boot net:dhcp - install' from Sparc, and have a
completely automated installation. However, you likely also have a rather
vanilla installation which we'll remedy in part four of the series.

