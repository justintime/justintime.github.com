---
title: Create CD's from FLAC files with mp3cd
permalink: /content/2008/12/15/create-cds-flac-files-mp3cd
layout: post
categories:
- Linux
- sysadmin
comments: true
sharing: true
footer: true
---
So, you store all your CD's as FLAC, and [encode FLAC to MP3 on the fly](http://www.sysadminsjourney.com/content/2008/12/11/convert-flac-mp3-fly-mp3fs). Now, you've gone and lost that CD, or in my case, your 3 year old
daughter loses it for you. How do you regenerate a CD from your FLAC's?
[mp3cd](http://outflux.net/software/pkgs/mp3cd/) does just that. I was all set
to code something up myself, but mp3cd is currently maintained, and even
available in the Ubuntu repositories! It has a man page, and it even works --
why reinvent the wheel? Note that if you do use Ubuntu, and you're getting
this error:
{% highlight bash %}
sox soxio: Failed reading `01.wav': unknown file type `auto'
{% endhighlight %}
Then you just need to install some
packages:
{% highlight bash %}
sudo apt-get install libsox-fmt-all
{% endhighlight %}

