---
title: Migrating a Zone to a Different Machine on Solaris 10
permalink: /content/2009/06/30/migrating-zone-different-machine-solaris-10
layout: post
categories:
- Solaris
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
Zones are one of the best features in Solaris 10 -- they're so
lightweight that you can use them at almost no cost in performance.
Today, I ran across a situation where one of my zones needed more
RAM, and the box it was on didn't have it. Read on for how to
migrate a Solaris Zone to a different machine, and an important
update to Solaris 10/08 that makes the process **so** much easier.
The initial steps in migrating a zone are very similar. First, you
need to halt the zone:
{% highlight console %}
# zoneadm -z myzone halt
{% endhighlight %}

Next, you need to detach it from it's non-global zone:
{% highlight console %}
# zoneadm -z my-zone detach
{% endhighlight %}

Now, you need to copy the zone files over to machine B. You can use
rsync + ssh, tar + ssh, tar + ftp, cpio, or any other mechanism. If
you have your zone installed in /apps/zones, then the following
should do the trick:
{% highlight console %}
root@hostA # cd /apps/zones; tar -cf myzone.tar myzone
root@hostA # scp myzone.tar someuser@hostB:/var/tmp/ && rm myzone.tar
# ssh over to hostB, and become root 
root@hostB # cd /apps/zones/ && tar -xf /var/tmp/myzone.tar && rm /var/tmp/myzone.tar
root@hostB # zonecfg -z my-zone
my-zone: No such zone configured
Use 'create' to begin configuring a new zone.
zonecfg:my-zone> create -a /apps/zones/my-zone
zonecfg:my-zone> commit
zonecfg:my-zone> exit
{% endhighlight %}

As you can see, the process of moving a zone isn't too difficult,
but the sticking point is when the global zone on machine A has
different software and patches than machine B. Since a non-global
zone's inherit files and packages from the global zone, things can
get messy. Up until Solaris 10/08, getting things straightened out
was an exercise left up to the sysadmin, and it often times was no
small task. If you're on a release prior to 10/08, and there's a
lot of difference between Machine A & B, then you have your work
cut out for you. Try this (running this on 10/08 or newer doesn't
hurt anything, and it allows you to "preview" changes):
{% highlight console %}
root@gaia /apps# zoneadm -z sstg attach
These packages installed on this system were not installed on the source system:
    SUNWi15cs (2.0,REV=2004.08.23.14.43)
    SUNWi1cs (2.0,REV=2004.08.12.10.14)
    SUNWlocaledefsrc (11.10.0,REV=2004.08.12.18.18)
    SUNWnamdt (1.0,REV=2004.08.12.10.18)
    SUNWnamos (11.10.0,REV=2003.12.08.12.08)
    SUNWnamow (1.0,REV=2004.03.03.14.07)
    SUNWplow (1.0,REV=2004.08.12.10.19)
    SUNWplow1 (1.0,REV=2004.11.10.13.49)
    SUNWpsvrr (5.0,REV=2005.05.13.16.32)
    SUNWpsvru (5.0,REV=2005.05.13.16.32)
    SUNWtcatr (11.10.0,REV=2005.01.08.05.16)
    These patches installed on the source system are inconsistent with this system:
        118666: version mismatch
            (18) (20)
        118667: version mismatch
            (18) (19)
        118683: version mismatch
            (02) (03)
        118718: version mismatch
            (01) (02)
        118777: version mismatch
            (13) (14)
        118959: version mismatch
            (03) (04)
        119059: version mismatch
            (46) (47)
        119090: version mismatch
            (31) (32)
        119213: version mismatch
            (18) (19)
        119254: version mismatch
            (65) (66)
        119278: version mismatch
            (25) (27)
        119280: version mismatch
            (19) (20)
        119315: version mismatch
            (15) (16)
        119470: version mismatch
            (15) (16)
        119538: version mismatch
            (18) (19)
        119757: version mismatch
            (14) (15)
        119963: version mismatch
            (12) (15)
        120272: version mismatch
            (23) (24)
        120410: version mismatch
            (30) (31)
        120753: version mismatch
            (05) (07)
        120812: version mismatch
            (29) (30)
        121081: version mismatch
            (06) (08)
        121104: version mismatch
            (06) (07)
        122212: version mismatch
            (32) (33)
        122259: version mismatch
            (01) (02)
        122261: version mismatch
            (01) (02)
        122675: version mismatch
            (02) (03)
        122911: version mismatch
            (15) (16)
        123590: version mismatch
            (09) (10)
        123893: version mismatch
            (05) (15)
        123938: version mismatch
            (01) (02)
        124149: version mismatch
            (14) (15)
        125172: version mismatch
            (01) (02)
        125332: version mismatch
            (05) (06)
        125533: version mismatch
            (10) (11)
        125555: version mismatch
            (02) (04)
        125719: version mismatch
            (17) (20)
        125952: version mismatch
            (18) (19)
        126530: version mismatch
            (01) (02)
        126655: version mismatch
            (01) (02)
        127976: version mismatch
            (04) (05)
        136998: version mismatch
            (05) (06)
        137000: version mismatch
            (03) (04)
        137034: version mismatch
            (01) (02)
        137080: version mismatch
            (02) (03)
        138174: version mismatch
            (01) (02)
        138322: version mismatch
            (02) (03)
        138822: version mismatch
            (02) (04)
        138826: version mismatch
            (02) (04)
        138874: version mismatch
            (01) (03)
        139099: version mismatch
            (01) (02)
        139606: version mismatch
            (01) (02)
        139928: version mismatch
            (01) (02)
        139966: version mismatch
            (01) (02)
        139974: version mismatch
            (02) (03)
        139977: version mismatch
            (03) (04)
        140074: version mismatch
            (05) (08)
        140171: version mismatch
            (01) (02)
        140391: version mismatch
            (02) (03)
        140397: version mismatch
            (06) (08)
    These patches installed on this system were not installed on the source system:
        119397-09
        119788-09
        122130-04
        125060-05
        136708-01
        140589-01
        140916-01
        140917-01
        140919-01
        140921-01
        141414-01
        141686-01
        141688-01
        141690-01
        141692-01
        141694-01
        141715-01
        141717-01
        141719-01
        141721-01
        141726-01
        141729-01
        141731-01
        141733-01
        141736-01
        141738-01
        141740-01
        141742-01
        141743-01
        141765-01
        141767-01
        141773-01
        141775-01
        141781-01
{% endhighlight %}

WOW. That's a lot of cleanup. It's no wonder Sun was compelled to
add the update flag. Here's how to save yourself some hair:
At this point, you're good to 'boot' the zone on HostB. Thanks to
Sun's update feature, moving my resource-starved zone to a larger
server was a painless ordeal


