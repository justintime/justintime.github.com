---
title: Estimate time-to-completion with progress.sh
permalink: /content/2008/12/15/estimate-time-completion-est
layout: post
categories:
- Linux
- Code
- sysadmin
comments: true
sharing: true
footer: true
---
Like many of you other sysadmins, I run a lot of ad-hoc, long running jobs.
Also like many of you, I have a full plate and can't stand to sit around
watching things run. Often times, I will start such a job and forget to come
back to it until the end of the day. I needed a way to find out quickly about
how long these tasks would take to run so that I could make a mental note or
set a reminder to check the task later.  Over time, I noticed that the vast
majority of the jobs I ran could be quantified and estimated by coming up with
custom shell pipeline. For instance, I need to iterate over something, and
write output to a file. I know that I'll be close to being done when I hit
100,000 lines in that file. If the file was named output.log, then I could
monitor progress by running 'wc -l output.log'.

These conditions gave birth to
progress.sh - a shell script that runs a command that you specify once every
30 seconds. The command needs to give back an integer. You can optionally
specify an end integer, and it will (fairly accurately) give you back an
estimated completion time. progress.sh takes two arguments, one required, the
other optional. The first argument is the command that generates an integer.
The second argument is optional, it's the end integer that will allow the
script to estimate time remaining. Perhaps the script is best explained by
giving a full example. Open up a terminal, and issue the following at the
command line:
{% highlight bash %}
echo "" > test.out; for i in `seq 1 600`; do echo "SUCCESS" >> test.out; echo "$i" >> test.out; sleep 3; done
{% endhighlight %}

This is a one-liner script that echoes two log lines to a file
once every 3 seconds for 30 minutes. Before hitting the enter key, open up
another terminal, and run this in it:
{% highlight bash %}
./progress.sh 'grep -c SUCCESS test.out' 600
{% endhighlight %}

It takes an iteration or two to
get enough data to make a good estimate, but you should start seeing output
like this:
{% highlight bash %}
Current=.13/sec TotalAvg=.13/sec Total=4/600 0% 1.27 hrs left
Current=.33/sec TotalAvg=.23/sec Total=14/600 2.00% 42.46 mins left
Current=.33/sec TotalAvg=.26/sec Total=24/600 4.00% 36.92 mins left
Current=.33/sec TotalAvg=.28/sec Total=34/600 5.00% 33.69 mins left
Current=.33/sec TotalAvg=.29/sec Total=44/600 7.00% 31.95 mins left
Current=.33/sec TotalAvg=.29/sec Total=54/600 9.00% 31.37 mins left
Current=.33/sec TotalAvg=.30/sec Total=64/600 10.00% 29.77 mins left
{% endhighlight %}

The first column is the statistics related to average units
per second. Let's examine the last line. Now, progress.sh executes the command
you give it once every thirty seconds. The .33/sec figure means that in the
last iteration, the integer incremented .33 units per second. Since we echo
the word "SUCCESS" out to the file once every 3 seconds, the math here is
sound. The tTotalAvg of .30/sec is the same metric, except instead of being
for the last execution, it is the average since the startup of progress.sh.
The second column shows the completion status. Again, looking at the last
line, we are told that we have 64 units out of our total 600, meaning we're
roughly 10% done. The final column tells us what the script estimates as the
time remaining before we are at 100% done.

### Caveats

  * I'm not a math major. This is simple stuff. If you know 'bc' and have suggestions, I'd be happy to hear them.
  * Watch your quoting on the first argument. If you're doing complex pipelines, you will likely need to escape some characters. Check out the [quoting section](http://tldp.org/LDP/abs/html/quoting.html) of the [bash-scripting howto](http://tldp.org/LDP/abs/html) for tips.
  * Let me know if it works great for you. Let me know if it doesn't. I'll try to make it better if I can. I use it all the time and it works well for me.

### Download

Get progress.sh here: [https://github.com/justintime/progress.sh](https://github.com/justintime/progress.sh).

