---
title: Using Sun's Java (jdk) with Eclipse on Ubuntu
permalink: /content/2008/07/21/using-suns-java-jdk-eclipse-ubuntu
layout: post
categories:
- Linux
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
Let's face it, if you're reading this article, you know what
Eclipse is, and what you're trying to do.  Follow the jump for how
to do it. First, install Sun's Java 6 jdk, and Eclipse:
    sudo apt-get install eclipse sun-java6-jdk

Now, set up the newly installed jdk as the system default:
    sudo update-java-alternatives -s java-6-sun

Next, set your default jvm:
    sudo vim /etc/jvm

and add this line at the top of the file:
    /usr/lib/jvm/java-6-sun

Now, that should do the trick, but the Eclipse packaged with Ubuntu
is packaged to prefer GCJ.  Let's fix that:
    sudo vim /etc/eclipse/java_home

and again add this line at the top of the file:
    /usr/lib/jvm/java-6-sun

Finally, while you're at it, bump up your Xms here:
    sudo vim /usr/lib/eclipse/eclipse.ini



