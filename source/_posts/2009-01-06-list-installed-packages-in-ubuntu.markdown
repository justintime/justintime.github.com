---
title: List installed packages in Ubuntu
permalink: /content/2009/01/06/list-installed-packages-ubuntu
layout: post
categories:
- Linux
- Ubuntu
- sysadmin
comments: true
sharing: true
footer: true
---
I found this over at the [Ubuntu Forums](http://ubuntuforums.org/showthread.php?t=261366), but since it took me
forever to find, I'm dropping notes here. In RPM-based distros, you can do
'rpm -qa > somefile.txt'. In Debian/Ubuntu, do this:
{% highlight bash %}
dpkg --get-selections > machineA.txt
{% endhighlight %}

In true apt fashion, if you
then want to have machine B have all the software machine A has, do this:
{% highlight bash %}
dpkg --set-selections < machineA.txt && dselect
{% endhighlight %}

Enjoy!

