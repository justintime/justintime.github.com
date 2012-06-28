---
title: Compiling Nagios Plugins and NRPE on Solaris 10 with Sun Studio
permalink: /content/compiling-nagios-plugins-and-nrpe-solaris-10-sun-studio
layout: post
categories:
- Nagios
- Solaris
- sysadmin
comments: true
sharing: true
footer: true
---
We have some Sun T1000's running Solaris 10 that we are going to deploy as web
servers. By compiling Apache from source using the Sun Studio compilers, you
get a huge boost in performance because of the compiler's built-in
optimizations for the Niagra processor. Before deploying them, I needed to get
NRPE setup, which requires that the Nagios plugins be installed. Once setup on
the client side, I can point our Nagios server at the webserver and get
notified of hardware issues, disk usage, load averages and what not.
Installing NRPE and the plugins using gcc is a no brainer. I thought using Sun
Studio wouldn't be too much harder, but after 5 hours of banging my head
against the wall, I figured out how to make them compile... To compile the
two, first set your PATH variable so that it can find Sun Studio, and the Sun
make binary:

{% highlight bash %}
PATH=/opt/SUNWspro/bin/:/usr/bin:/usr/local/bin:/opt/sfw/bin:/usr/ccs/bin:/usr/local/ssl/bin/
PATH=$PATH:/usr/ucb
export PATH
{% endhighlight %}

Now, the tricky part. Everything I did was failing
with SSL issues. Once I fixed that, check_procs wasn't working properly. Turns
out you need to set some CFLAGS and tell configure how to run ps:

{% highlight bash %}
CFLAGS='-DSSL_EXPERIMENTAL -DSSL_ENGINE -xO4' ./configure --with-ps-command="/usr/bin/ps -eo 's uid pid ppid vsz rss pcpu etime comm args'" --with-ps-format='%s %d %d %d %d %d %f %s %s %n' --with-ps-cols=10 --with-ps-varlist='procstat,&;procuid,&;procpid,&;procppid,&;procvsz,&;procrss,&;procpcpu,procetime,procprog,&pos;'
{% endhighlight %}

Then `make`, `su`, `make
install` as usual. Wash, rinse, and repeat for NRPE.

