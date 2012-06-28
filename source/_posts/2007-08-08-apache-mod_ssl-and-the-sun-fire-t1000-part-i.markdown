---
title: Apache, mod_ssl, and the Sun Fire T1000 - Part I
permalink: /content/2007/08/08/apache-modssl-and-sun-fire-t1000-part-i
layout: post
categories:
- Apache
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
I like Apache. A lot. It’s one of the few apps out there that you
can count on in a production environment, and it always does what
you expect it to. However, Apache is only as good as the person
configuring it. \*\*Do not use the worker MPM with the pkcs11
engine!!!!\*\* There is [a bug on OpenSolaris.org][] that
\*\*will\*\* bite you. [In part III I’ll compare performance of
worker vs prefork on the T1000 that will follow up with this
issue][] Since our Apache’s run on Sparc hardware, I like to
compile it from source using Sun Studio compilers tweaked for
performance. It goes against my open source bias, but when you’re
at work, you do what’s best for the bottom line. Anyways, we are in
the process of swapping out our Sun Fire v210’s with Sun Fire
T1000’s for use as our frontend webservers. I did some initial
performance testing in our lab environment. The general gist was
that the v210 and T1000 were almost identical when testing Apache
with a single thread, but the T1000 started to severely outrun the
v210 once the load jumped up. That was what we hoped to see, so we
kept going with our plan to replace the v210’s. Here are the actual
numbers from siege: \*\*v210\*\* siege -c60 -b -r50 -f \~/urls.txt
Transactions: 2999 hits Availability: 99.30 % Elapsed time: 48.50
secs Data transferred: 21.86 MB Response time: 0.38 secs
Transaction rate: 61.84 trans/sec Throughput: 0.45 MB/sec
Concurrency: 23.56 Successful transactions: 2999 Failed
transactions: 21 Longest transaction: 29.85 Shortest transaction:
0.00 \*\*T1000:\*\* siege -c60 -b -r50 -f \~/urls.txt Transactions:
3000 hits Availability: 100.00 % Elapsed time: 6.45 secs Data
transferred: 22.28 MB Response time: 0.11 secs Transaction rate:
465.12 trans/sec Throughput: 3.45 MB/sec Concurrency: 51.91
Successful transactions: 3000 Failed transactions: 0 Longest
transaction: 2.08 Shortest transaction: 0.00 So, like any good
sysadmin, I put the new servers in place in a phased approach. Take
one v210 out of the load balancer, insert the new T1000, and slowly
bring it into service. All went fine, and the load balancer was
even favoring the T1000 over the v210. Then I happened to look at
SSL stats. For some reason, the load balancer was favoring the v210
by a ratio of 3:1 for SSL connections. I knew this couldn’t be
right, as the T1000 has circuitry in the CPU itself that acts as a
hardware crypto accelerator. After Googling for a bit, I found
[Chi-Chang Lin’s blog][]. There, he details a way to performance
test OpenSSL. Read the blog entry for the specifics, but here’s
what I got from the v210 and the T1000: \*\*v210:\*\* sign verify
sign/s verify/s rsa 1024 bits 0.003673s 0.000199s 272.3 5017.1 rsa
2048 bits 0.021869s 0.000625s 45.7 1600.9 \*\*T1000:\*\* sign
verify sign/s verify/s rsa 1024 bits 0.004711s 0.000250s 212.3
4003.2 rsa 2048 bits 0.028339s 0.000814s 35.3 1229.2 For some
reason, my T1000 is indeed not outperforming my v210 in SSL crypto
operations. Also on Chi-Chang’s blog, I discovered that in order to
use the crypto hardware on the UltraSparc T1, you have to either
use Sun’s SSL, or patch the one you have. Aha! As a habit, I always
compile OpenSSL from source and build Apache sources against that.
My Apache on the T1000 was not using the patch, nor Sun’s OpenSSL.
Just to make sure I was barking up the right tree, I ran the same
OpenSSL tests as above, except this time I ran it with Sun’s
OpenSSL. The v210 was virtually the same, but the T1000 - well:
sign verify sign/s verify/s rsa 1024 bits 0.0003s 0.0001s 3175.2
7940.5 rsa 2048 bits 0.0014s 0.0003s 730.1 3284.7 WOW. 1,500%
better numbers. I’d say that it’s worth recompiling Apache for that
kind of benefit. So, I set out and recompiled Apache. For those
wondering, here’s my configure: {% highlight bash %} make distclean
INSTALLDIR=/apps/apache2 LDFLAGS="-L/usr/sfw/lib -R/usr/sfw/lib"
CFLAGS='-DSSL\_EXPERIMENTAL -DSSL\_ENGINE -xO4 -xtarget=ultraT1'
./configure --prefix=$INSTALLDIR --enable-mods-shared=all
--enable-logio --enable-proxy --enable-proxy-connect
--enable-proxy-ftp --enable-proxy-http --enable-cache
--enable-mem-cache --enable-ssl --with-mpm=prefork --enable-so
--enable-rule=SSL\_EXPERIMENTAL --with-ssl=/usr/sfw
--enable-deflate --with-z=/usr LDFLAGS="$LDFLAGS" && dmake -j 64 &&
dmake install {% endhighlight %}
[a bug on OpenSolaris.org]: http://bugs.opensolaris.org/bugdatabase/view\_bug.do?bug\_id=6540060
[In part III I’ll compare performance of worker vs prefork on the T1000 that will follow up with this issue]: http://techadvise.com/2007/08/15/apache-mod\_ssl-and-the-sun-fire-t1000-part-iii/
[Chi-Chang Lin’s blog]: http://blogs.sun.com/chichang1/entry/rsa\_performance\_of\_sun\_fire


