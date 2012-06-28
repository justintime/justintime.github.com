---
title: Random Password Generation in a Perl One-Liner
permalink: /content/2009/09/16/random-password-generation-perl-one-liner
layout: post
categories:
- Perl
- Code
- sysadmin
comments: true
sharing: true
footer: true
---
Say you need a quick random 8 character alpha-numeric password. In sh, there
isn't a $RANDOM variable and tr can give different results on different OS's.
More than likely you have perl available - use it! {% highlight bash %} perl
-le 'print map { (a..z,A..Z,0..9)[rand 62] } 0..pop' 8 {% endhighlight %}
Thanks to [Chris Angell's Perl One-
Liner](http://www.chrisangell.com/oneliners.html) page for this one. Do you
have a better cross-platform way of doing it? Let me know!

