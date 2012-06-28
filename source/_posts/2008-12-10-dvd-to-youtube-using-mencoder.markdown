---
title: DVD to YouTube using MEncoder
permalink: /content/2008/12/10/dvd-youtube-using-mencoder
layout: post
categories:
- Linux
- sysadmin
comments: true
sharing: true
footer: true
---
Just a quick note for myself. We have a Sony HandyCam that burns video to
DVD's. I recently needed to upload a video of my daughter to YouTube to share
with relatives. After a few iterations, here's what I settled on:
{% highlight bash %}
mencoder -ovc xvid -oac mp3lame -af resample=44100:0:0 -xvidencopts \
bitrate=2200 -o MyVideo.avi dvd://${TITLE} -chapter ${CHAPTER}
{% endhighlight %}
If anyone else has any settings that work better, please share!

