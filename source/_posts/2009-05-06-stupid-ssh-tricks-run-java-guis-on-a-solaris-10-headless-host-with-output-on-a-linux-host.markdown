---
title: "Stupid SSH Tricks: Run Java GUI's on a Solaris 10 headless host with output on a Linux host"
permalink: /content/2009/05/06/stupid-ssh-tricks-run-java-guis-solaris-10-headless-host-output-linux-host
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
Running GUI's over an SSH tunnel is nothing new, and not too tricky. However,
I recently had a case where I wanted to run a java-based GUI (dhcpmgr) as root
on a remote host, and have it display on my local Linux box. I hit a couple of
snags, so I thought I'd post them here to hopefully help out others.  First,
we need to configure the Solaris 10 SSH server to allow remote SSH forwarding.
First, make sure you have the following in your /etc/ssh/sshd_config file:

    
    X11Forwarding yes
    X11DisplayOffset 10
    X11UseLocalhost yes
    

If you had to make changes to the file, restart SSH by doing a

    
    svcadm refresh ssh

Now, onto the Linux client. If X11 forwarding in general is working, but you
get a blank window when running Java apps, here's what you need to do. Edit
/etc/ssh/ssh_config and make sure the following is in there:

    
    ForwardX11Trusted yes

Finally, we have both ends setup, now it's time to make the connection. From
the Linux client:

    
    ssh -CX mynonrootuser@solarisbox

The -C option compresses the connection, the -X option sets up X11 forwarding.
Now, we need to run our app as root. Don't do like your fingers want you to do
here! My fingers are so trained to typing 'su -' to become root, but the
trailing dash blows away some important environment variables. Instead, do a

    
    su

**without the trailing dash!** Now, fire up your Java GUI, and bookmark this page. You're a Unix SysAdmin, and you need GUI's so little that you'll surely forget how to do all this when you need it next ;-) 

