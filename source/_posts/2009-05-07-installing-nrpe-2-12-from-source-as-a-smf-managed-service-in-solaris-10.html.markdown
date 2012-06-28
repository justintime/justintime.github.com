---
title: Installing NRPE 2.12 from source as a SMF managed service in Solaris 10
permalink: /content/2009/05/07/installing-nrpe-212-source-smf-managed-service-solaris-10
layout: post
categories:
- Nagios
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
<p>Installing NRPE on Solaris 10 involves just a bit more than your normal './configure &amp;&amp; make &amp;&amp; make install' routine. However, all the dependencies are likely present on a freshly installed system, you just have to tell NRPE where to find it. There's one file you need to patch, and then it will install. From there it's easy to plug into SMF! <!--break--> First, let's make sure some directories are present, and create our Nagios user:</p>
<pre># mkdir /usr/local
# groupadd nagios
# useradd -m -c "nagios system user" -d /usr/local/nagios -g nagios -m nagios
</pre>
<p>Next, download and extract the source code to NRPE:</p>
<pre>$ cd /tmp/
$ /usr/sfw/bin/wget http://superb-east.dl.sourceforge.net/sourceforge/nagios/nrpe-2.12.tar.gz
$ gzip -dc nrpe-2.12.tar.gz | tar -xvf -
$ cd nrpe-2.12
</pre>
<p>Now, we need to tell the configure script where to find the openssl libraries, and make sure that GCC is in our path:</p>
<pre>$ PATH=$PATH:/usr/sfw/bin:/usr/ccs/bin ./configure --with-ssl=/usr/sfw/ --with-ssl-lib=/usr/sfw/lib/
</pre>
<p>That should run just fine. Before we build, we need to apply a quick fix to nrpe.c. If you don't do this, you'll get an error from make that says "nrpe.c:617: error: 'LOG_AUTHPRIV' undeclared (first use in this function)".</p>
<pre>$ perl -pi -e 's/LOG_AUTHPRIV/LOG_AUTH/; s/LOG_FTP/LOG_DAEMON/' src/nrpe.c
</pre>
<p>Now, we should be okay to build it:</p>
<pre>$ PATH=$PATH:/usr/sfw/bin:/usr/ccs/bin make 
</pre>
<p>Then, install it as root:</p>
<pre># PATH=$PATH:/usr/sfw/bin:/usr/ccs/bin make install
</pre>
<p>Either copy the nrpe.cfg sample included in the source code, or drop your own into /usr/local/nagios/etc/nrpe.cfg. Now, stay logged in as root for the following, now we'll get NRPE setup to run under SMF. First, we need to setup the service and present it to inetd:</p>
<pre>echo "nrpe 5666/tcp # NRPE" &gt;&gt; /etc/services
echo "nrpe stream tcp nowait nagios /usr/sfw/sbin/tcpd /usr/local/nagios/bin/nrpe \
 -c /usr/local/nagios/etc/nrpe.cfg -i" &gt;&gt; /etc/inet/inetd.conf
</pre>
<p>Now, tell SMF to pull in the inetd config:</p>
<pre>inetconv
</pre>
<p>At this point, the SMF service is available, but we want to use TCP wrappers so that only our Nagios server can talk to NRPE (substitute $NAGIOS_IP with the IP of your Nagios server):</p>
<pre>inetadm -m svc:/network/nrpe/tcp:default tcp_wrappers=TRUE
echo "nrpe: LOCAL, $NAGIOS_IP" &gt;&gt; /etc/hosts.allow
echo "nrpe: ALL" &gt;&gt; /etc/hosts.deny
</pre>
<p>Finally, fire up the service:</p>
<pre>svcadm enable nrpe/tcp
</pre>
<p>That's it! Nagios should be able to monitor your Solaris 10 box now. Someday, I'll make a package for this, but you can pretty well copy and paste the code here to get up and running.</p>

