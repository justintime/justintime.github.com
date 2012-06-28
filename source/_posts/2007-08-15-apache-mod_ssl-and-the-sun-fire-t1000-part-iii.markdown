---
title: Apache, mod_ssl, and the Sun Fire T1000 - Part III
permalink: /content/2007/08/15/apache-modssl-and-sun-fire-t1000-part-iii
layout: post
categories:
- Apache
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
In [part one](http://techadvise.com/2007/08/08/apache-mod_ssl-and-the-sun-
fire-t1000/) of the series, I went over how to compile Apache 2.0 to take
advantage of the T1000 hardware. In [part
two](http://techadvise.com/2007/08/08/apache-mod_ssl-and-the-sun-fire-t1000
-part-ii/), I talked about patching Apache 2.0 to support the
SSLHonorCipherOrder directive. I didn't realize there might be a part three,
but here we are! After finishing the second piece, I sent an email of thanks
to [Jan Pechanec](http://blogs.sun.com/janp/) at Sun for his blog entries
mentioned in part one. In the email, I mentioned that I was running Apache 2.0
in worker mode. He cautioned me that worker mode with Sun's pkcs11 engine
still had outstanding issues with worker mode, and pointed me to [this bug
report on OpenSolaris](http://bugs.opensolaris.org/bugdatabase/view_bug.do?bug
_id=6375348). I hadn't been able to find a reliable load testing tool for
HTTPS, so I was just using the check_http plugin from
[Nagios](http://www.nagios.org). The performance results I were getting were
correct, but I wasn't stressing the server at all. Jan pointed me to
[http_load](http://www.acme.com/software/http_load/), a simple multithreaded
http load tester that supports HTTPS if you compile it against OpenSSL. He was
also kind enough to give me his shell script that he was using to load up
HTTPS connections. I later found the script posted on a bug report, so I'm
assuming it's okay to repost it here: {% highlight bash %} #!/bin/bash [ $#
-ne 4 -a $# -ne 5 ] && echo "$0  []" && exit if [ -n "$5" ]; then
cipher="-cipher $5" fi # for SSL for i in `yes | head -$3`; do printf "."
./http_load $cipher -parallel $2 -fetch $4 $1 & done echo "" # wait for all so
that we can time the script wait {% endhighlight %} You then run the shell
script (named load.sh in this case) like so:

    
    
    time ./load.sh sslurl.txt 10 20 500 RC4-MD5 >/dev/null

This will fork 10 processes, each using 20 threads, to fetch the url contained
within sslurl.txt as fast as possible 500 times. By wrapping the command with
the 'time' command, you get the amount of time it takes to fetch the HTTPS url
5,000 times. Take 5,000 divided by the number of real seconds returned by
time, and you have a requests per second benchmark. To my shock, running this
against my Apache 2.0 worker server never even completed. OpenSSL started to
complain about 'bad mac' errors, and eventually started to time out. Well,
back to the drawing board! I started by recompiling Apache to use the prefork
MPM. See [part one](http://techadvise.com/2007/08/08/apache-mod_ssl-and-the-
sun-fire-t1000/) for the configure options I used. Since I had benchmarks from
a T1000 using worker MPM, a V210 using worker MPM, a T1000 using prefork MPM,
and the [Sun CoolStack package](http://cooltools.sunsource.net/coolstack/)
(Apache 2.2 w/prefork MPM) installed on a T1000, I decided to keep track of
performance and publish some very pretty graphs. First up, a comparison of
reported requests per second from ApacheBench (ApacheBench was used with
keepalives requesting a very small static file): ![ApacheBench Response Time
Chart](http://www.techadvise.com/images/abrs.gif) You can see that the T1000
is much faster than the v210 in all configurations. Interesting to note that
the prefork 2.0 on the T1000 actually was faster than the worker 2.0 on the
same box until extreme loads were placed on the server. Okay, what about
response times? The below graph represents the 95th percentile of the number
of milliseconds all requests were completed in: ![ApacheBench Response Time
Chart](http://www.techadvise.com/images/abrt.gif) Again, it's safe to assume
the T1000 is outperforming the v210. Here, prefork consistently outperformed
worker, and Apache 2.2 is much better at keeping response times to a minimum
under load. Finally, let's look at HTTPS requests per second. The CoolStack
Apache 2.2 isn't present, because I had configuration issues with getting SSL
to work. From the get-go, 2.2 was not an option, as we have a proprietary
proxy module for our application server that does not yet support 2.2. That's
why 2.2 was not tuned, and I didn't spend too much time with it. The T1000
worker for 2.0 is missing because when using pkcs11, it would not complete the
benchmark tests. ![Apache Peak SSL Requests Per
Second](http://www.techadvise.com/images/apsrs.gif) Rather obvious results,
eh? The asterisk after the tuned prefork means that I only got it to perform
this well after applying the Solaris patches to the SUNWCry package. **Quick
Tips and Tricks for Performance**

  * Use noatime on your DocumentRoot partition.
  * Apply all SUNWCry patches
  * Use 'pthread' for your SSLMutex and AcceptMutex
  * Make sure to use the shmcb for your SSLSessionCache
  * Use /dev/urandom for your SSLRandomSeed entries
  * Compile all the modules you might ever need, but only load them if you need them.
**Closing Thoughts**  
The T1000 makes for a strong Apache box. I have a lot going on in my Apache
config that probably drags down my performance - a lot of logging, about 100
mod_rewrite rules, proxies, and whatnot. You might be able to google around
and find people getting 20,000 requests per second and more from Apache, but
they aren't doing that with my configuration. By replacing our v210's with
cheaper T1000's, we've ensured that our webserver layer will not be the
bottleneck in our stack for years to come!

