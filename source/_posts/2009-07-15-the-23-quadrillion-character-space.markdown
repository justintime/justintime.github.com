---
title: The $23 Quadrillion Character - Space!
permalink: /content/2009/07/15/23-quadrillion-character-space
layout: post
categories:
- sysadmin
comments: true
sharing: true
footer: true
---
From [Slashdot](http://rss.slashdot.org/~r/Slashdot/slashdot/~3/IMBNn2vUq7o
/Software-Glitch-Leads-To-23148855308184500-Visa-Charges):  Hmmm2000 writes
"Recently several Visa card holders were, um, overcharged for certain
purchases, to the tune of $23,148,855,308,184,500.00 on a single charge. The
company says it was due to a programming error, and that the problem has been
corrected. What is interesting is that the amount charged actually reveals the
type of programming error that caused the problem. 23,148,855,308,184,500.00 *
100 (I'm guessing this is how the number is actually stored) is
2314885530818450000. Convert 2314885530818450000 to hexadecimal, and you end
up with 20 20 20 20 20 20 12 50. Most C/C++ programmers see the error now ...
hex 20 is a space. So spaces were stuffed into a field where binary zero
should have been."  That's probably more damage than Y2K ever hoped of doing
;-)

