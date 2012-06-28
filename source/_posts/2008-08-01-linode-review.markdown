---
title: Linode Review
permalink: /content/2008/08/01/linode-review
layout: post
categories:
- Hosting
- Linux
- Reviews
- Virtualization
- sysadmin
- Linode
comments: true
sharing: true
footer: true
---
I recently switched from
[Aplus.net](http://www.aplus.net "Aplus.net") shared Unix hosting
to
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
Xen-based VPS hosting. Follow the jump to read my reviews of both.
I had a shared Unix account with Aplus.net for about a year. Aplus
used FreeBSD with jails to provide their shared hosting. While that
gave me the ability to ssh into the box, I could not get root. It
did however, work quite well - the control panel is nice, and you
could use about anything you wanted to. I never needed to use their
support, their control panel worked great, and I never had any
issues with billing. There were two drawbacks, one minor, the other
major:
1.  The box was firewalled to death. I'm all for firewalls, but I
    like to be in control of it. Not only were inbound ports blocked
    (which is a good thing), but all outbound access was blocked as
    well. This made hard things impossible, and easy things hard. For
    example, adding a simple RSS widget to your page hosted on Aplus
    just will not work.
2.  The particular box I was on was severely over-sold. I have no
    idea how many shared accounts there were on the box, but there were
    times where my simple little wordpress blog was completely
    unavailable. $12 a month is cheap, but I at least expect to be able
    to render pages!

After doing a bunch of research, my choice for a new hosting
provider was down to
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
and [SliceHost](http://www.slicehost.com "SliceHost"). In the end,
I settled on
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
because I was reading some grumblings that SliceHost was having
some growing pains, and I couldn't find any negatives to
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode").
So, at 10:57pm on July 30th, I started the sign up process for a
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
540 in their Dallas datacenter. At 11:07pm that night (10 minutes
later!) I had full access to my server. Very impressive! By 11pm on
July 31st, I had moved my blog from Aplus to
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
without any hitches. First, let me tell you what
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
is and isn't.
-   **Linode is**a provider of Xen-based virtualized hosts. This
    means you get to pick which distribution you want, and you get your
    own root account with which you can do what you feel like.
-   **Linode provides**a DNS Manager included with all their plans
    that allows you have full control over any number of domains. I had
    no idea this existed until I signed up, and it was a great little
    side benefit. I was able to cancel my DNS service at a registrar
    that I was paying $15 a year for.
-   **Linode provides**you with a Xen instance with 4 cores of Xeon
    for CPU, and a configurable amount of RAM, bandwidth, and storage.
-   **Linode provides**a out-of-band management tool named lish
    (LInode SHell) which gives you console level access to your
    server.  There is also an AJAX web-based console interface
    available.
-   **Linode provides**you with everything you need to build your
    own server. You may do with this server what you like, provided
    it's for law-abiding activities. You have the ability to create
    your own partitions, upgrade your kernel, install packages,
    whatever!
-   **Linode provides**you with more than enough rope with which
    you can hang yourself! This is a logical extension of the above
    point. If you have root, you can most certainly do a 'rm -rf /' and
    no one will stop to ask you if you're sure or not.
-   **Linode is not**your run-of-the-mill webhoster. If you want to
    run your own LAMP stack, you are more than welcome to do so.
    However, **you**are responsible for the setup and maintanence of
    the entire stack. There's no cute little control panel button you
    click to setup a blog. If you don't know Linux, and don't want to
    learn how to do these sort of things, you're better off with a
    provider such as Aplus.net.

After signing up, you get to pick which data center you want your
server to be hosted in.  Here are their current datacenters:
-   Newark, NJ
-   Atlanta, GA
-   Dallas, TX
-   Fremont, CA

You can view what servers are available in what datacenters
[here](http://www.linode.com/avail.cfm?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode Datacenter Availability").
Here are some of Linode's support options:
-   A quick
    [FAQ](http://www.linode.com/faq.cfm?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "FAQ")
-   A
    [Wiki](http://www.linode.com/wiki/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Wiki")
-   A public
    [support forum](http://www.linode.com/forums/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
    which employees take part in regularly
-   An
    [IRC channel](http://www.linode.com/irc/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
-   A support ticket system for active customers
-   There is a phone number posted on their site, but I don't think
    it's intended to be used for support issues.

After just two days of running my own
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode"),
I must say that I'm thoroughly impressed. Uptime is 100%, and I
haven't needed support for anything at all. My blog runs as it
should - and if it didn't it would be my fault for not setting it
up properly. I will update this post in the future with more data
as I learn more about the service. Also, if you'd like to give
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
a try and have enjoyed this post, consider visiting their site by
clicking on any of the
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df "Linode")
links present in this post. They contain a referral code that will
give me $20 credit if you sign up and stay a customer for 30 days.




