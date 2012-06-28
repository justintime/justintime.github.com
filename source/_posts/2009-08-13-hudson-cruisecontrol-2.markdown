---
title: Hudson > (CruiseControl * 2)
permalink: /content/2009/08/13/hudson-cruisecontrol-2
layout: post
categories:
- Java
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/medium_hudson.png)[CruiseControl](http://cruisecontrol.sour
ceforge.net) and I have never really gotten along. When you're a Java shop,
you have to use continuous integration. In fact, if you're a code shop, you
need CI. For the longest time, CruiseControl was the only kid on the block.
I'd heard about [Hudson](http://hudson.dev.java.net/) quite a bit, but I
didn't take the time to try it. Why not? Well, because CI is hard, and it
takes forever to get setup right -- I didn't want to have to re-invest all
that time. Man, if only I'd known how wrong I was.

Everyone's gripe with CruiseControl was that you had to edit XML files to make
the configuration. Well, I don't mind XML, and it's often pretty good at
config files. But CruiseControl was always quirky. Switching from CVS to SVN?
A day's worth of work. Adding a new build? At least an hour or two. Little
things: CruiseControl would freak out and die if you didn't do the initial
checkout from CVS/SVN - CruiseControl only does updates, not checkouts. We
often joke how the developers that write CruiseControl favorite motto was "let
the sucker sysadmin deal with it".

So, I downloaded Hudson, and in less than 10 minutes I had everything that was
being done in CruiseControl working in Hudson. And, I'm being honest here, I
actually smiled a few times to myself when setting it up! It took another 20
minutes, and I have authentication working against our LDAP server, which I
never had working in CruiseControl.

If you're running CruiseControl now, drop everything, do yourself a favor, and
go try Hudson. If it doesn't do what you want, it has plugins that do. It has
API's for XML, JSON, and Python, and the XML implementation has full XPATH
support. Every field in the web interface has inline help that is actually
helpful. Having different projects use different Java's and Ant's are a click
away. You can build multiple projects at once, create build dependencies, and
even have distributed builds run amongst multiple machines.

Please, I'm begging you. Give Hudson a try, and get back some of your life
from CruiseControl! If you're not running CruiseControl or Hudson, then you
probably should be.

