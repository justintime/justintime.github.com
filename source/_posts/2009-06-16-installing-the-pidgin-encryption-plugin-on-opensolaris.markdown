---
title: Installing the Pidgin-Encryption Plugin on OpenSolaris
permalink: /content/2009/06/16/installing-pidgin-encryption-plugin-opensolaris
layout: post
categories:
- OpenSolaris
- sysadmin
comments: true
sharing: true
footer: true
---
You can install Pidgin from the OpenSolaris.org repository, but there's no
package for the Pidgin-Encryption plugin. Once you point it in the right
direction, it's not hard to install the plugin from source.

    
    
    pfexec pkg install SUNWgcc SUNWxorg-headers SUNWgnome-common-devel
    tar -xzvf pidgin-encryption-3.0.tar.gz
    cd pidgin-encryption-3.0
    ./configure --with-nspr-includes=/usr/include/firefox/nspr/ \
      --with-nspr-libs=/usr/lib/firefox/ \
      --with-nss-includes=/usr/include/firefox/nss/ \
      --with-nss-libs=/usr/lib/firefox/ --prefix=/usr
    make
    pfexec make install
    

Restart Pidgin, and go to Tools->Plugins, and enable the Pidgin Encryption
plugin.

