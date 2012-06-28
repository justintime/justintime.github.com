---
title: Use GMail as an SMTP relay using SSMTP
permalink: /content/2008/09/01/use-gmail-smtp-relay-using-ssmtp
layout: post
categories:
- Linux
- QuickTips
- sysadmin
comments: true
sharing: true
footer: true
---
On some of your home workstations, and especially on a laptop,
setting up a full-blown SMTP server such as Postfix, Sendmail, or
Exim might be overkill.  Follow the jump to learn how to setup the
lightweight ssmtp to relay all outbound mail through your GMail
account by using Gmail as a smarthost. SSMTP is meant to be a
no-frills, secure, and lightweight replacement for a full-blown
MTA. Personally, I feel it's best use is on a laptop where you're
moving around between networks a lot, and need to send outbound
emails from cron or other shell scripts. By setting up SSMTP, it
doesn't matter where you are, sending mail will be sent out over
encrypted SMTP to Google's gmail servers. After handing it off,
Google's servers do all the routing for you. Setting up SSMTP is
quick and easy - let's get to it. On Ubuntu, run:
{% highlight console %}
\# sudo apt-get install ssmtp mailx
{% endhighlight %}
Now, we just need to configure SSMTP. Open up /etc/ssmtp/ssmtp.conf
in your favorite editor, and add or update the following lines:
{% highlight properties %}
\#The following line redirects mail to root to your gmail account root=myemail@gmail.com
mailhub=smtp.gmail.com:587
UseSTARTTLS=yes
UseTLS=yes
AuthUser=myemail@gmail.com
AuthPass=mypassword
{% endhighlight %}

That's it! Now, let's try testing it:
{% highlight console %}
$ echo "This is a test message." | mailx -s 'Test Message' myemail@gmail.com
{% endhighlight %}

You should now be all setup
and ready to go!


