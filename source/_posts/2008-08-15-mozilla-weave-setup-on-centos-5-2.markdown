---
title: Mozilla Weave Setup on CentOS 5.2
permalink: /content/2008/08/15/mozilla-weave-setup-centos-52
layout: post
categories:
- Apache
- Hosting
- sysadmin
comments: true
sharing: true
footer: true
---
[Mozilla Weave](http://labs.mozilla.com/projects/weave/) is a
project from Mozilla Labs that aims to keep all of your browser
data synced between all of your PC's.  The now defunct Google
Browser Sync used to do this, as does
[Foxmarks](http://www.foxmarks.com/).  Although Weave is still in
it's infancy, it's been very promising thus far.  However, many of
the users of Mozilla's own Weave server complain that the service
is very slow.  The beauty of Weave is that it uses the standard
protocol [WebDAV](http://en.wikipedia.org/wiki/WebDAV) to sync it's
data.  Why does that matter?  Because our good 'ol buddy
[Apache](http://www.apache.org) can speak WebDAV out-of-the box! 
Follow the jump to find out how you can setup your own server that
you can sync to. In our scenario, we'll be setting up Weave to sync
to a [CentOS](http://www.centos.org) 5.2 server running Apache
2.2.  We'll use mod\_ssl to encrypt the communications - and to
conserve IP's and SSL certs, we'll setup Weave as a subdirectory
under the main SSL virtual host.  However, you should be able to
adapt these instructions to any Apache installation where mod\_ssl
and mod\_dav\_fs is installed and available. There's two phases to
the installation:
1.  Setup of the Apache server
2.  Setup of the Firefox client(s)

### Setup of the Apache server

First, make sure that you have mod\_ssl installed:
    yum install mod_ssl

Now, make sure the following lines are present in
/etc/httpd/conf/httpd.conf to enable WebDAV:
{% highlight apache %}
LoadModule dav_module modules/mod_dav.so
LoadModule dav_fs_module modules/mod_dav_fs.so
<IfModule mod_dav_fs.c>
  DAVLockDB /var/lib/dav/lockdb
</IfModule>
{% endhighlight %}

Now, let's setup our directory alias off of the main SSL virtual
host. We'll maintain our configuration in a separate file. Create a
file named /etc/httpd/conf.d/mozilla-weave.include with this in it:
    Alias /weave /apps/mozilla_weave/www
{% highlight apache %}
<Directory /apps/mozilla_weave/www>
  SSLRequireSSL
  Options Indexes FollowSymLinks
  AllowOverride AuthConfig Limit
  Order allow,deny
  Allow from all
  AuthType Basic
  AuthName "WebDAV Restricted"
  AuthUserFile /apps/mozilla_weave/passwords
  require valid-user
</Directory>

<Location /weave>
  DAV On
</Location>
{% endhighlight %}

Now, let's get this file included in the main SSL virtualhost. On
CentOS, edit the file /etc/httpd/conf.d/ssl.conf. Just before the
closing VirtualHost tag, insert the include statement:
    include /etc/httpd/conf.d/mozilla-weave.include
    </VirtualHost>

Now, let's create our directory structure (replace 'myusername'
with whatever username you want to authenticate with):
    cd /apps
    mkdir -p mozilla_weave/www/user/myusername
    chown -R apache:apache mozilla_weave

Now, we'll create our htaccess file - again replace 'myusername':
    echo "require user myusername" > mozilla_weave/www/user/myusername/.htaccess
    chown apache:apache mozilla_weave/www/user/myusername/.htaccess
    htpasswd -c mozilla_weave/passwords myusername

Finally, let's restart Apache:
    /etc/init.d/httpd restart

### Setup of the Firefox client(s)

First, download the latest Weave plugin from
[here](https://people.mozilla.com/~cbeard/weave/dist/latest-weave.xpi).
Go ahead and restart Firefox. It will start the Weave wizard on
startup, but for now click cancel. Click the new Weave icon down in
your status bar, and click on "Preferences".  Now click on the
advanced tab.  You need to change the Server Location field to the
URL that we just set up in Apache.  In my case, I used
https://www.techadvise.com/weave. Now, click on the Account tab,
and click the "Sign In" button.  Click the "Next" button, followed
by "Set Up Another Computer".  Should be self explanatory from here
out - just use the same username and password we set up earlier via
Apache.
The latest versions of Weave require you to use SSL. Since not
everyone has money to throw away, you might be using a self-signed
certificate. When you do, you need to browse to
https://www.yourdomain.com/ and jump through all the hoops to
autmatically accept the certificate before it will work in Weave.
If you don’t do this, Weave will give you the error “Username /
password incorrect”

One PC down, now go to all of your other machines and point them at
your new WebDAV enabled directory. Then enjoy all the synchronized
goodness with great performance!


