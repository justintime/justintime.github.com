---
title: NGINX Performs Well on Solaris 10 x86
permalink: /content/2009/12/15/nginx-performs-well-solaris-10-x86
layout: post
categories:
- Solaris
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/nginx.gif)Just a quick posting of some simple benchmarks
today. Please note, these are not the be all, end all performance results that
allow everyone to scream from atop yonder hill that Solaris performs better
than Linux! This was just me doing a little due dilligence. I like Solaris 10,
and wanted to run it on our webservers. We're looking at using NGINX to serve
up some static files, and I wanted to make sure it performed like it should on
Solaris 10 before deploying it - you know, right tool for the job and all. So,
disclaimers aside, here's what I found.

## The Hardware

The hardware I tested was a Dell PowerEdge R610, with 12GB RAM, and 2x4 Core
Nehalem CPU's. SATA disks were used with the internal RAID controller, but no
RAID was configured.

## The Benchmarks

I used ApacheBench, as shipped with Glassfish Webstack 1.5. Yes, I know,
there's all kinds of flaws with ApacheBench, but the key here isn't the
benchmarking tool, it's that the tool and it's configuration remain the same.
Here's the command line I used:

`/opt/sun/webstack/apache2/2.2/bin/ab -n1000000 -k -c 2000
http://localhost/static/images/logo.jpg`

## CentOS 5.4

I installed CentOS 5.4, ran yum to get all the updates possible. I then
installed NGINX 0.7.64 from source, and simply copied one image file into the
document root. I did a few sysctl tweaks for buffers and whatnot, but found
later that they didn't impact the benchmark. Here's what ApacheBench running
on the local host had to say:

    
    
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/
    
    Benchmarking localhost (be patient)
    Completed 100000 requests
    Completed 200000 requests
    Completed 300000 requests
    Completed 400000 requests
    Completed 500000 requests
    Completed 600000 requests
    Completed 700000 requests
    Completed 800000 requests
    Completed 900000 requests
    Completed 1000000 requests
    Finished 1000000 requests
    
    
    Server Software:        nginx/0.7.64
    Server Hostname:        localhost
    Server Port:            80
    
    Document Path:          /static/images/logo.jpg
    Document Length:        4404 bytes
    
    Concurrency Level:      2000
    Time taken for tests:   21.916 seconds
    Complete requests:      1000000
    Failed requests:        0
    Write errors:           0
    Keep-Alive requests:    990554
    Total transferred:      4625275893 bytes
    HTML transferred:       4407166476 bytes
    Requests per second:    45629.29 [#/sec] (mean)
    Time per request:       43.831 [ms] (mean)
    Time per request:       0.022 [ms] (mean, across all concurrent requests)
    Transfer rate:          206101.61 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   3.9      0     135
    Processing:     0   43  67.8     27     676
    Waiting:        0   43  67.7     27     676
    Total:          0   44  68.1     27     676
    
    Percentage of the requests served within a certain time (ms)
      50%     27
      66%     41
      75%     49
      80%     53
      90%     72
      95%    202
      98%    245
      99%    342
     100%    676 (longest request)
    

No matter how you slice it, that's pretty darn fast. I knew that Solaris 10
had a completely rewritten TCP/IP stack optimized for multithreading, and that
it should keep right up with Linux. However, NGINX uses different event models
for Linux and Solaris 10 (epoll vs eventport), so I wanted to make sure there
weren't any major differences in performance.

## Solaris 10

I installed Solaris 10 x86, ran pca to get all the updates possible. I then
installed NGINX 0.7.64 from source, and simply copied one image file into the
document root. Here's what ApacheBench running on the local host had to say:

    
    
    Server Software:        nginx/0.7.64
    Server Hostname:        localhost
    Server Port:            80
    
    Document Path:          /static/images/logo.jpg
    Document Length:        4404 bytes
    
    Concurrency Level:      2000
    Time taken for tests:   21.728 seconds
    Complete requests:      1000000
    Failed requests:        0
    Write errors:           0
    Keep-Alive requests:    991224
    Total transferred:      4623536714 bytes
    HTML transferred:       4405506168 bytes
    Requests per second:    46023.73 [#/sec] (mean)
    Time per request:       43.456 [ms] (mean)
    Time per request:       0.022 [ms] (mean, across all concurrent requests)
    Transfer rate:          207805.08 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    1  71.9      0    4434
    Processing:     0   42  57.2     29    1128
    Waiting:        0   41  56.0     29    1128
    Total:          0   43  98.6     29    4473
    
    Percentage of the requests served within a certain time (ms)
      50%     29
      66%     35
      75%     42
      80%     50 
      90%     74
      95%    108
      98%    176
      99%    256
     100%   4473 (longest request)
    

Again, very impressive results. Overall, it appeared as though Solaris+NGINX
was just a few millis faster than CentOS+NGINX in most cases, but certainly
not enough to change your mind of what platform to use. If you notice the 4.5
second request on the Solaris box, I'm pretty sure that's a TCP retransmit
that I can work out with ndd tuning.

## The Verdict

NGINX is freaking fast. My hunch is that it's so fast, that I'm actually
running up against the limits of ApacheBench, not NGINX -- but that's just a
gut feeling. The verdict is that you won't be making a mistake going with
either Linux or Solaris when setting up your NGINX server.

