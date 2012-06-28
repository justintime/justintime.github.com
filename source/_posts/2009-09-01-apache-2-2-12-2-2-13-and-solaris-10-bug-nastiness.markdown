---
title: Apache 2.2.12 - 2.2.13 and Solaris 10 Bug Nastiness
permalink: /content/2009/09/01/apache-2212-2213-and-solaris-10-bug-nastiness
layout: post
categories:
- Apache
- Solaris
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/feather.gif)At work, I've been working on an upgrade from a
custom-compiled version of Apache 2.0.x to the Sun-provided [Glassfish
Webstack](http://www.sun.com/software/webstack/index.xml) 1.5. I spent about a
week troubleshooting what I thought was configuration issue, only to finally
find it's a bug way upstream in Apache 2.2.12+. This bug only affects Solaris
10, and is near-impossible to reproduce. If you use Solaris 10 and Apache,
read on so you don't waste a week of your life like I did.

The problem presented itself as Apache intermittently hanging. It didn't
depend on load, or anything else. Sometimes it would happen at 2pm in the
afternoon, other times at 4am. While load isn't required, a lot of
simultaneous connnections helps trigger the bug. The guy I worked with at Sun
had to introduce some sleep times into the Apache source code in order to
trigger it, so my guess is that it's a race condition on the microsecond
level.

Basically, Nagios would alert me that Apache had quit responding. netstat
showed a huge number of connections stuck in a CLOSE_WAIT state. Either
restarting or gracefully restarting Apache would resolve the issue. Luckily, I
found the solution before I had to pull out pstack and truss.

If you think you might be encountering the same bug, the first prerequisite is
that you have multiple **Listen** statements in your config (most everyone
does). If you do, then do the following to your stuck Apache.

  1. # pstack `pgrep httpd` > /tmp/httpd_pstack.txt

  2. Find the pid in apr_pollset_poll(). Looking through httpd_pstack.txt, exactly one process should have this backtrace:  
  

    
    1652: /usr/apache2/2.2/bin/httpd -k start
        feda1167 portfs (6, 13, 835d350, 2, 1, 8047b48)
        feedd302 apr_pollset_poll (835d308, 989680, 0, 8047ba4, 8047ba8, 2) + 126
        08091611 child_main (0, 8090fac, 8047c08, 8091801) + 329
        08091846 make_child (80c8128, 0, 0, 80c4228) + 86
        0809192f startup_children (5, 80c6230, 8047d18, 8091a47) + 43
        08091ab6 ap_mpm_run (80c6230, 80f42e8, 80c8128, 8070831) + 162
        0807083e main (3, 8047ddc, 8047dec, feffb7b4) + 812
        0806f9fd _start (3, 8047e8c, 8047ea7, 8047eaa, 0, 8047eb0) + 7d

  
In this case, the pid is 1652.

  
If you don't find such a pid, you have a different problem.

  3. Run truss against the pid in apr_pollset_poll()  
  

    
    # truss -p 1652 

  
  
It should look like this:

  

    
    
        port_getn(19, 0x0835D350, 2, 1, 0x08047B48) (sleeping...)
        port_getn(19, 0x0835D350, 2, 1, 0x08047B48) = 0 [62]
        port_getn(19, 0x0835D350, 2, 1, 0x08047B48) (sleeping...)

... (over and over)

  
with port_getn() returning about every 10 seconds, and the web side

inaccessible during this time.

If this is what you have, then you are indeed being bitten by this bug.
Initially, I found [a post on the Webstack forums that put me in touch with
Jeff Trawick](http://forums.sun.com/thread.jspa?threadID=5402863). After doing
a bit more digging, I found [the Apache HTTPD bug
report](https://issues.apache.org/bugzilla/show_bug.cgi?id=47645). After
emailing Jeff, he was able to send me a .so file that I could load before
executing Apache that fixes the problem. I don't have the okay to
redistribute, so email Jeff if you need the fix. Sun more than likely won't
release an official update to Glassfish Webstack to resolve the issue, and
going forward Apache 2.2.14 will include Jeff's fix (technically the bug is in
APR and is fixed in APR 1.3.9 which will be included in httpd 2.2.14).

Many thanks to Jeff Trawick for his quick help, as well as the steps on how to
confirm existence of the bug using the steps listed above.

