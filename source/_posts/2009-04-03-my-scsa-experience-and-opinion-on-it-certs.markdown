---
title: My SCSA Experience and Opinion on IT Certs
permalink: /content/2009/04/03/my-scsa-experience-and-opinion-it-certs
layout: post
categories:
- Me
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
The last couple of months for me have been spent cramming 1200 pages of meaty
Solaris information into my brain. At the end of my sacrifice, I have an
[SCSA](http://www.sun.com/training/certification/solaris/scsa.xml)
certification to show for it. Was it worth it? For me, yes. For my employer,
yes. For everyone, no.  I've never been much for certifications. Heck, I
really didn't even have much desire to get my 4 year bachelor's degree - I
just knew that I would be better off if I had it. Fresh after graduation, I
got my [A+ Certification](http://certification.comptia.org/a/default.aspx). It
made me feel good, but never really did anything for me. During my job as a
computer repair tech, I had the misfortune of dealing with way too many paper
[MCSE](http://www.microsoft.com/LEARNING/MCP/MCSE/)'s that couldn't write a
batch file. The whole experience really soured me to certifications in general
-- to the point of me discrediting many people that had
[MCP](http://www.microsoft.com/learning/mcp/mcp/) or MCSE in their email
signatures. In my next job, as the sysadmin of a dialup/cable modem ISP, I had
a somewhat improved experience in being exposed to
[CCIE](http://www.cisco.com/web/learning/le3/ccie/index.html)'s - most of them
could at least do IP subnetting without a cheatsheet. I actually learned
enough RedHat Linux that I could have probably taken a month of studying and
turned it into an [RHCE](https://www.redhat.com/certification/rhce/)
certification, but decided against it. So, what made me turn to the dark side
and get my SCSA? The idea hit me when Sun offered a promotion for half-off
their training and testing package. I ran it by my boss, and he was cool with
the company paying for it, and me using a little company time to do my
studies. I figured what the heck, and went for it. Here's what I learned:

  * In my case, my certification was motivation. While I had worked with Solaris for the past 3 years, I really hadn't learned that much about it. Up until a few months ago, I hated SMF (what was so bad about init scripts?), and had no idea how to use ZFS. I didn't know where Solaris excelled, and instead used Linux for everything that I could. Now I know much more about the differences between Solaris and Linux. Details on that in a future post, but I can now make a well informed decision on what OS fits the job best, and I feel comfortable administering either.
  * It's up to you to get what you need out of the certification. If you want a piece of paper, you can go download "dumps" that contain every possible question you'll see on the cert exam, and memorize them all. You'll flounder and die out in the field, but that's your prerogative. I read the materials, took notes, and at the end of each chapter I performed the actual tasks on a Solaris box at home. That type of learning sticks with you, and will likely save your arse someday.
  * The test itself gets absurdly detailed at times. They expect you to memorize command line options, and give you know man pages to lookup. Sometimes the only difference between two answers is the -S in answer A versus the -s in answer B.
  * The test makes you memorize things you don't have to memorize in the field. The key to effective systems administration is good problem solving skills coupled with a good knowledge of the tools available to you. Thanks to man pages and Google, you don't need to memorize command line options, just know the command(s) that will get you out of trouble.
When all is said and done, it wasn't the most pleasant experience ever, but it
was one I'd do again. I now have confidence when faced with a Solaris problem.
I must say that while I'll stick with Linux on my desktop and laptop, I'll
actually lean towards Solaris on the server side of things. I learned a lot of
things that I never would have learned had I not had to take the test, and my
employer will benefit as well. By the way, if you're looking for good material
on the SCSA, go for [Bill Calkin's book](http://www.amazon.com/Solaris-System-
Administration-Exam-
Prep/dp/0789738171/ref=pd_bbs_2?ie=UTF8&s=books&qid=1238810994&sr=8-2) and
avoid [Paul Sanghera's](http://www.amazon.com/Certified-Administrator-Solaris-
310-200-310-202/dp/0072229594/ref=sr_1_17?ie=UTF8&s=books&qid=1238811080&sr=1-
17) book. I read both, and feel that Bill's book much better prepared me for
the exams. The cert doesn't make the sysadmin, but the sysadmin can make the
cert work!

