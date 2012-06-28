---
title: "The Nagios Fork: Did Two Wrongs Make a Right???"
permalink: /content/2009/05/12/nagios-fork-did-two-wrongs-make-right
layout: post
categories:
- Linux
- Nagios
- sysadmin
comments: true
sharing: true
footer: true
---
It's an item that I feel hasn't got much press, at least in the limited RSS
entries I've had time to scan lately: [Nagios has been
forked](http://www.icinga.org/). I've been using Nagios long enough that I
actually used NetSaint for a bit, so I have some mixed feelings about Icinga.
In general, I'm all for forks when they are indeed needed -
[FOSWiki](http://foswiki.org/) is a great example. But forks shouldn't be
taken lightly, in many ways they are like a divorce - they should be a last
resort, not a quick way out. Personally, I think that the fork will ultimately
either fail or merge back into Nagios, but read on for why I think the Icinga
fork is a case of two wrongs making a right.  First, let me state that this is
all my personal opinion. I've been around Nagios for a long time, and while I
don't know the developers involved personally, I've read enough of all of
their emails over the years to have a good feel for what they are about. All
this seems to have come about because of a few reasons:

  * Ethan Galstad, the sole person with commit access to Nagios, has become a bottleneck in the project. It took forever for Nagios 3.0 to come about, and development has slowed even more since then.
  * People seem to fear the commercialization of Nagios. Ethan's involvement in Nagios Enterprises appears to make some people nervous. I think this is all FUD - there's many examples of commercial OSS out there, and many of them are perfectly community-friendly. If Ethan finally wants to make some money over what he's developed over the past 10 years, then more power to him. If he and his company were to become "evil", **then** you fork the code, but not before.
  * Ethan, like most developers, prioritized bugs and features based upon what he felt like working on the most. This lead many to feel that their requests were going unheard.
Netways is the company that is sponsoring the fork, they are all great coders,
and have committed a lot of their resources to Nagios. However, I feel they
made a critical mistake - they treated the fork like a coup or a crusade.
Ethan states that he was never directly approached about the fork before the
announcement "Nagios is dead! Long live Icinga" was made on the mailing list.
Part of OSS is open communication, I think that Netways should have tried to
discuss things first. Going back to the divorce analogy, they filed for
divorce before the spouse knew there was a problem. So, the title makes
reference to two wrongs and a right. I think this may actually be one of the
rare occasions where two wrongs do make a right. The two wrongs? Easy!

  * Ethan was wrong for taking the community too lightly, and not allowing the community to have more input into the direction of Nagios. He had far too little participation in the mailing lists to be the sole dictator of the code base.
  * Netways was wrong starting a fork for the wrong reasons. Don't misunderstand me here, I think nearly all of their reasons are valid, I just don't think that a fork should have been the first step to resolve them.
So, what's the right here? Well, it appears as though this may have been the
wake up call that Ethan may have needed. I encourage you to [read all of
Ethan's posts on his blog](http://community.nagios.org/), but he is already
taking steps to resolve some of the more obvious issues. First and foremost,
he's appointed Ton Voon and Andreas Ericsson to be core developers. Ton and
Andreas are excellent developers, and likely have committed more of their time
to the development and support of Nagios and it's plugins than Ethan himself
has over the last couple years. The project could not be in more competent
hands than in theirs. He has committed to the setup of a bug/issue/request
tracker for Nagios, and has [created a site that allows end-users to vote on
what features they want to see in Nagios](http://ideas.nagios.org/).
Unfortunately, my crystal ball tells me that Icinga will be a casualty, but it
has already served it's purpose without a single release - it has pushed
Nagios further in a few weeks than anything else has in the past few years.
Perhaps two wrongs did make a right? **Personal note:** this is the first big
opinion story I've ever written here, and it feels odd. Usually I reserve
space on my blog for howto's and other facts instead of opinion. However,
Nagios has done so much for me over the years, it's hard not to voice my
opinion on a piece of software that I truly consider the single most important
piece of software I've ever used in my role as a sysadmin. More than likely if
you've read this far, you're a sysadmin too and likely have some strong
opinions on this topic - please do share them!

