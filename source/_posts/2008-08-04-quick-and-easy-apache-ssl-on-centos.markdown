---
title: Quick and Easy Apache SSL on CentOS
permalink: /content/2008/08/04/quick-easy-apache-ssl-centos
layout: post
categories:
- Apache
- Linux
- sysadmin
comments: true
sharing: true
footer: true
---
Follow the jump to find out how you can quickly and easily setup
your own SSL certificate and install it into Apache on CentOS/RHEL.
First, we need to install the crypto-utils package, which gives us
the super-handy genkey command.  We'll also pull in mod\_ssl at the
same time:
    yum install crypto-utils mod_ssl

With that out of the way, let's run genkey for our sample domain,
www.mydomain.com:
    genkey --days=3650 www.mydomain.com

1.  Click Next
2.  Highlight "1024", click Next
3.  Click No
4.  Fill in the form fields, making sure that the Common Name is
    the name you'll be typing in your browser's URL bar.  Click Next
5.  Don't select "Encrypt the private key" unless you want to type
    in the passphrase every time you start Apache.  Click Next.

Now, we have our keys generated, we just need to tell Apache to use
them.  **Please note:**The SSLCertificateFile changes the file
extension from **crt**to **cert**!
    SSLCertificateFile /etc/pki/tls/certs/www.mydomain.com.cert
    SSLCertificateKeyFile /etc/pki/tls/private/www.mydomain.com.key

Restart Apache, and test it out!


