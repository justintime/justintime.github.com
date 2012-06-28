---
title: "Ask SAJ: What to do with Apache logs > 50GB?"
permalink: /content/2009/11/30/ask-saj-what-do-apache-logs-50gb
layout: post
categories:
- Apache
- Ask SAJ
- sysadmin
comments: true
sharing: true
footer: true
---
Our site at $work is generating Apache logs that, when combined sequentially
into one file, are larger than 50GB in size for one day's worth of traffic.
AWStats' perl script pretty much chokes when working on this much data. Last I
checked, Webalizer wasn't much different, and probably wouldn't scale up to
that amount of data either. Does anyone out there have any advice on a
commercial solution for Apache log analysis that can scale up like that?

