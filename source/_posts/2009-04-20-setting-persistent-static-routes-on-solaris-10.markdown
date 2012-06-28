---
title: Setting Persistent Static Routes on Solaris 10
permalink: /content/2009/04/20/setting-persistent-static-routes-solaris-10
layout: post
categories:
- Solaris
- sysadmin
comments: true
sharing: true
footer: true
---
It used to be that in order to add persistent static routes in Solaris, you
had to whip up your own init script that manually ran 'route add'. Starting
back in Solaris 10 11/06, Sun finally gave us a better way to do it.  From the
**route(1M)** man page:

    
    
         -p
    
             Make changes to  the  network  route  tables  persistent
             across  system restarts. The operation is applied to the
             network routing tables first and, if successful, is then
             applied  to  the  list  of  saved  routes used at system
             startup. In determining whether an  operation  was  suc-
             cessful, a failure to add a route that already exists or
             to delete a route that is not in the  routing  table  is
             ignored. Particular care should be taken when using host
             or network names in persistent routes, as  network-based
             name  resolution  services are not available at the time
             routes are added at startup.
    

So, all you need to do to add a static route for 192.168.0.0/24 to be accessed
via gateway 192.168.1.1 on each boot is this: {% highlight bash %}
/usr/sbin/route -p add 192.168.0.0 192.168.1.1 {% endhighlight %} Currently,
these routes are stored in /etc/inet/static_routes, but Sun doesn't guarantee
it will stay there. I'm not sure I like being forced to use a command when I
could just edit a config file, but it's a definite improvement!

