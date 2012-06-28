---
title: CheckPoint UTM-1 vs Cisco ASA in an ECommerce Setting
permalink: /content/2009/10/15/checkpoint-utm-1-vs-cisco-asa-ecommerce-setting
layout: post
categories:
- Cisco
- Me
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/cisco-logo.gif)Recently at $WORK, we had to come up with
budget proposals for next year. We knew that we were going to outgrow our
current Checkpoint UTM appliances by holiday next year, so we had to buy new
hardware. We just had to decide which hardware. While I'm capable of building
a Linux/\*BSD firewall on my own, I frankly don't have the time to mess around
with updates and compliance documentation. We need an appliance, and for our
needs, Cisco and CheckPoint are about the only options for us. We switched to
the UTM appliances from a pair of Cisco ASA 5500's a few years ago. However,
after examining the pros and cons of both, I recommended we switch back to the
ASA platform next year. Read on for my decision making process explained.

Our first experience with the ASA product line from Cisco was a few years ago.
The current ASA software at the time was 5.x (IIRC, maybe it was 6.x). The
reason we switched to CheckPoint and their UTM-1 appliances was due to the
lack of configurability. First of all, it was very tricky to make the ASA
behave like a router AND a firewall, not just a firewall. Eventually, they
supported the features necessary to do basic static routing, but I hit an
issue where the "ASP" or "Accelerated Security Path" filters on the ASA were
throwing away packets that I didn't want it to. I was unable to write an ACL
or tweak a configuration that would let the packets I needed to get through.
In essence, the firewall was saying it knew what was bad for me, and wouldn't
listen to my argument on the matter at all. After going round-n-round with
Cisco TAC, it became my sole purpose in life to get rid of those damned ASA's.
I succeeded in that two months later with a pair of UTM-1's from CheckPoint.

We're in the minority of businesses where our firewall's priority isn't
protecting internal users from the big, bad Internet. Our goal is to let all
but the most blatantly abusive potential guests browse our website and buy
stuff. This is an important distinction - if we were the typical corporate
network that focused on the former, we probably would have stuck with
CheckPoint. So, here's my list of pros and cons for each device:

  * ## **CheckPoint**

    * **Pros**

      * SmartView Tracker. This app has no competition that I've found. This app lets you view events in real time, or do some pretty complex searches in real time. Beats the heck out of grep | cut | sort | uniq | wc on a syslog file.

      * SmartDashboard: If you're into GUI's, this one is very nice at configuring rulesets, and giving you a graphical view of your networks.

      * SmartDefense: while quite expensive, this L7 deep inspection filter does it's job well. You get updates every week or so, and can turn them on, off, or put them in monitor mode which lets the packets through, but logs an event. This allows you to see what would happen if you turned it on, without actually interrupting packet flow.

    * **Cons**

      * Expense. Yikes. Comparing a Cisco ASA solution to the closest CheckPoint solution in our case has CheckPoint coming in at more than 25% more than the Cisco which will push more pps.

      * Lack of a robust CLI. This is a killer for me. While having a GUI can be nice at times, nothing beats a concise CLI. Where Cisco's ASDM solution is a GUI built upon a CLI foundation, CheckPoint's CLI is an afterthought to the GUI. Some might argue there's nothing you can't do via the CLI on a CheckPoint, but if you're editing the policy files in vi, then you're just asking for trouble.

      * Commodity hardware. CheckPoint is a software solution, and their UTM-1 appliances are nothing more than x86 boxes running SecurePlatform (which is a pared down RHEL). While there's nothing inherently wrong with that, the result of CheckPoint using off-the-shelf hardware versus Cisco's custom hardware is that Cisco's can push a lot more packets than comparable CheckPoints.

      * Hard Drives. Cisco's run off flash and have no moving parts save for the fans. CheckPoint's appliance requires a full-on hard drive. While I've had DOA Cisco flash, I've never had their flash fail me once put into service. I can't count how many hard drives have failed me over the years.

      * Reliance upon a SmartCenter server. Some may see this as a positive, but I see it as a negative. When you install your CheckPoint policy, it first goes to a separate server called the SmartCenter. The SmartCenter then pushes this config to the individual appliances one-by-one. All logs on the appliances are sent to the SmartCenter. I have a few problems with this. First, it's another server. Second, it's another single point of failure -- if your SmartCenter dies, you lose the ability to change the configuration on your appliances until you get it back up. To eliminate the single point of failure, you're encouraged to run a Active/Standby HA setup of SmartCenter. At this point, you have not just two appliances to keep up to date, but two SmartCenter servers as well. Each one of these devices is an x86 box with a hard drive, so MTBF is comparitively low.

  * ## **Cisco**

    * **Pros**

      * CLI. While it's not quite IOS, it's damn close, and anyone at home in IOS can pick up the ASA differences very quickly.

      * Easy upgrades and rollbacks. Cisco's software upgrades might be odd to some, but once you get the hang of it, you won't find anything better.

      * Optimized hardware. With the ASA's, you get very few moving parts and ASIC's that are optimized for pushing packets. Cisco's been doing this for a long time, and they're very good at it.

      * More bang for the buck. You pay less for a Cisco solution that has higher specs than a CheckPoint solution that doesn't do as much.

      * ASDM. If you're into the GUI thing, you can not ever have to touch the CLI.

    * **Cons**

      * Bugs. Cisco's everything-including-the-kitchen-sink mindset means that their software tends to have a lot more bugs in it than what I've seen with CheckPoint. In their defense, Cisco seems to have been pretty quick to fix the bugs that I've encountered.

      * VPN Policy Management. I can't speak to this too much, as I never really used the VPN portion of either appliance. However, it was plain to see that CheckPoint had a lot more to offer in their solution when it came to VPN policy management features.

I'm sure there's a lot that I missed, but in the end, it came down to a few
major points. Cisco has incremented their software 3 major versions since my
last production experience with them, and it seems to me that much of the
reason why I switched away has been resolved. I feel much more at home using
the IOS-like CLI. I didn't need a lot of the extra features that CheckPoint
offered. Last, but certainly not least, there's a lot more fun things I can
spend that 25% on like new servers! However, if I had a bunch of business
users to extend VPN functionality to, while making sure that they were secured
from the Internet, I wouldn't hesitate to chose the UTM-1.

I'm really interested to hear what others think. Do you think I made the right
choice? No? Why?  If you care to share your choices, let me know what your
appliance is protecting (users or servers) and what choice you made.

