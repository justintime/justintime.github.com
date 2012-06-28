---
title: "Book Review: Learning NAGIOS 3.0 by Wojciech Kocjan"
permalink: /content/2009/07/22/book-review-learning-nagios-30-wojciech-kocjan
layout: post
categories:
- Book Review
- sysadmin
comments: true
sharing: true
footer: true
---
I was recently asked by [PACKT Publishing](http://www.packtpub.com) to review
the book _[Learning NAGIOS 3.0](http://www.packtpub.com/guide-for-learning-
nagios-3/book/mid/240709quylb8)_ by Wojciech Kocjan. I agreed to do so so long
as I could state whatever I felt about the book, and PACKT was fine with that.
I'm guessing they were fine with that because they knew the book was pretty
darn good! Click through for a full chapter-by-chapter breakdown of the book.
[![Learning Nagios
3.0.png](/assets/images/Learning%20Nagios%203.0.png)](http://www.packtpub.com
/guide-for-learning-nagios-3/book/mid/240709quylb8) Title: _[Learning NAGIOS
3.0](http://www.packtpub.com/guide-for-learning-
nagios-3/book/mid/240709quylb8)_ Author: Wojciech Kocjan ISBN:
978-1-84719-518-0 Overall, this is a good book, with material that everyone
except the most seasoned Nagios veterans can appreciate. I myself have been
using Nagios for about the last 10 years, and I've been too lazy to upgrade my
2.x install to the latest 3.x install. After reading the book, I think I'll
make it a priority. The book's main audience is probably ideally someone who
isn't new to \*nix, but is new to Nagios. They will get the most use out of
this book. That being said, there was quite a bit of new information or tips
that I hadn't discovered on my own within the book as well. Perhaps what I
liked most about the book is that not only did it tell you how to get things
set up when you have only 10 hosts and 20 services to monitor, it told you how
to set things up so that performance and manageability don't become an issue
when that same instance of Nagios is monitoring thousands of hosts and
services. Here's a quick breakdown of content by chapter. Note that [Chapter
7](http://www.packtpub.com/files/learning-nagios-3-sample-chapter-7-passive-
checks-and-nsca.pdf) is clickable - you may download a PDF for free of that
chapter.

## Chapter 1: Nagios Overview

The author does a good introduction about the core ideas and conventions in
Nagios, and at the end he offers a "What's New" section for sysadmins who are
upgrading from 2.x.

## Chapter 2: Installation and Configuration

This chapter walks you through installing Nagios from source on Ubuntu 'Gutsy'
7.10. It also goes through the basic tasks of creating hosts, services,
commands, time periods, contacts, and groups of objects. After getting your
feet wet, the book dives into one of the key features of Nagios, inheritance.
New to Nagios 3.0 is the capability to inherit from more than one parent,
which is a welcome addition. The final section goes into one of the most
important features (and one of the features Nagios implements best):
notifications.

## Chapter 3: Using the Nagios Web Interface

The first precursor to using the web interface is to get it setup properly.
One key point that the book leaves out, and can be a major stumbling block for
new users is that the core of the web interface is compiled C binaries. Most
users expect PHP, Perl, or some other interpreted language, but this is not
the case in Nagios. This severely limits the number of people who can go in
and modify the web UI - everyone knows PHP, not many know C. The rest of the
chapter goes through using the web interface to check status, print reports,
etc.

## Chapter 4: Overview of the Nagios Plugins

Each Nagios installation is only as good as it's plugins. In fact, without any
plugins, Nagios is unable to really do anything at all. Nagios' reliance upon
plugins is one of the reasons that it's been around for so long, and seems to
fit everyone's setup. Most use the same Nagios core, but you'd be hard pressed
to find two installations using the exact same set of plugins. The majority of
the chapter goes over the core plugins that are included in the Nagios Plugins
distribution.

## Chapter 5: Advanced Configuration

Chapter 5 covers some things that the Nagios docs don't - mainly how to
organize your definitions into a maintainable file and directory structure. It
also goes into detail about the depth-first inheritance search order, and
multiple inheritance - new to Nagios 3. Also new to Nagios 3, custom
variables, are covered here as well. Chapter 5 also covers the algorithm used
to determine flapping, and does it very well. I'd never comprehended it until
reading the book.

## Chapter 6: Notifications and Events

Note: This chapter has two abstracts available on PACKT's website - you can
read [Part 1 here](http://www.packtpub.com/article/notifications-and-events-
nagios-part1), and [Part 2 here](http://www.packtpub.com/article
/notifications-and-events-nagios-part2). This chapter goes over the ins and
outs of setting up contacts properly. The key here is to not over-notify
contacts about incidents they have no input or control on, because they will
quickly delete or even filter all messages from Nagios. The chapter also goes
into different types of notifications available to Nagios. When fixing a
broken application's source code is not an option, many times the only
solution is to restart the application when it fails. Nagios can do this for
you as well in what's referred to as Event Handlers. This chapter walks you
through setting up an event handler that restarts Apache should it die. New to
Nagios 3 is Adaptive Monitoring. Adaptive monitoring gives you the ability to
dynamically change configurations stored in the config files via the named
pipe. The remainder of the chapter walks you through building, installing, and
configuring NSCA to accept passive check results over the network.

## [Chapter 7: Passive Checks and NSCA](http://www.packtpub.com/files/learning-nagios-3-sample-chapter-7-passive-checks-and-nsca.pdf)

[Chapter 7](http://www.packtpub.com/files/learning-nagios-3-sample-chapter-7
-passive-checks-and-nsca.pdf) starts the content with the subject of passive
checks. Passive checks are the key to scaling Nagios to thousands of hosts.
The author then goes into the pros and cons of active and passive checks. From
there, you are taken through several examples of passive host and service
checks.

## Chapter 8: Monitoring Remote Hosts

This chapter introduces the reader to the concept of remote checks, and how
they differ from passive checks. The first part of the chapter goes into
detail about using SSH to execute remote checks. Personally, I have never used
this approach, as it introduces a little more security risk - if someone were
to compromise the nagios user account on the Nagios server, they would likely
get shells on all your other servers as well. The next section of the chapter
goes into setting up NRPE, which I personally recommend and use extensively.
NRPE is has much less overhead than SSH, but still encrypts the connection.
Also, NRPE is not a shell, so if the nagios user is compromised on the server,
the only thing the attacker could do to the remote machines is run the
previously defined service checks on your client hosts. The author walks the
reader through examples of using both approaches.

## Chapter 9: SNMP

SNMP is very near and dear to me - I was forced to love it when working with
DOCSIS back in my cable industry days. The author gives a pretty good
introduction to SNMP in the beginning of the chapter. After introducing the
reader to net-snmp utilities and some GUI's, he goes into detail about
installing and testing the net-snmp agent on the remote hosts. Once SNMP is
set up on the remote hosts, it's time to start playing with the check_snmp
plugin. check_snmp is not so different from other plugins, and is not bad to
setup at all. One thing that I had tried before, and failed at doing, was
setting up Nagios to be a SNMP trap destination. The author presents a way to
do this, but I would argue that his method wouldn't scale very well. Either
way, his method works - although it's important to remember that Nagios is not
a SNMP management package.

## Chapter 10: Advanced Monitoring

The first part of the chapter goes into using NSClient++ to monitor Windows
systems. I would argue that this is not necessarily "Advanced Monitoring" -
maybe there should be a small chapter dedicated to monitoring Windows.
However, that's all semantics - the content itself is accurate and well
stated. The chapter goes into detail about installing NSClient++ and using
check_nt, check_nrpe, and passive checks using NSCA to get data from your
Windows hosts. The remainder of the chapter goes into distributed Nagios
instances. I myself have never had to do this, but in reading through the
content, it certainly looks doable. It appears as though there isn't too much
to the initial setup, but config file maintenance looks like it could become
cumbersome. I'll have to noodle on that for a bit!

## Chapter 11: Extending Nagios

Yoda might have been quoted as saying "Only after a padawan writes plugins
will the true power of Nagios be unveiled to him" - or maybe not, but it's
definitely a true statement. That's what chapter 11 is all about - writing
your own plugins. I can especially appreciate the fact that the author
distinguishes between a working plugin, and a plugin written the right way.
The chapter finishes up with how you might go about writing your own web
interface (only skimming the surface for obvious reasons).

## Summary

In summary, this book is for anyone who runs, or is thinking about running
Nagios 3.0 for business or pleasure. It's a pretty quick read, and has quite a
bit of information in it that will have you reaching for it like you would a
reference book. In the interest of full disclosure, all links to [PACKT's
website](http://www.packtpub.com/guide-for-learning-
nagios-3/book/mid/240709quylb8) from this article will result in me receiving
referral dollars should you purchase the book from them. I only participate in
referrals when I have personally used and approve of the product. If you
enjoyed this review and are interested in purchasing the book, I would
appreciate your referral.

