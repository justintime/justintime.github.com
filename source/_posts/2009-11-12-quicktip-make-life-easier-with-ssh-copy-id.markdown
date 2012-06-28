---
title: "QuickTip: Make life easier with ssh-copy-id"
permalink: /content/2009/11/12/quicktip-make-life-easier-ssh-copy-id
layout: post
categories:
- Linux
- QuickTips
- Solaris
- sysadmin
comments: true
sharing: true
footer: true
---
How many times have you ran through this series of events?
{% highlight console %}
$ cat ~/.ssh/id_dsa.pub
...copy output to clipboard...
$ ssh myhost
...enter password...
myhost$ vi ~./ssh/authorized_keys
...paste public key and save...
myhost$ exit
{% endhighlight %}
Thanks to bash's tab completion, I
happened upon **ssh-copy-id**. Instead of all that above, just do this: 
{% highlight console %}
$ ssh-copy-id myhost
...enter password... 
{% endhighlight %}
You're done!

