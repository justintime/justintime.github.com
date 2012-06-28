---
title: My Thoughts and Ramblings on DrupalConSF 2010
permalink: /content/2010/04/23/my-thoughts-and-ramblings-drupalconsf-2010
layout: post
categories:
- Me
- Drupal
- Drupal Planet
comments: true
sharing: true
footer: true
---
I had the great pleasure of attending my first
[DrupalCon](http://sf2010.drupal.org) this week. Held in downtown San
Francisco at the Moscone Center, it was my opinion that this was Drupal's
"homecoming". While Drupal wasn't "born" in San Francisco, it seems to be the
city that has the strongest following. The attendance numbers didn't lie - I'm
pretty sure they broke 3,000 <del>geeks</del> attendees. I made this trip solo
-- I only knew three people that were going, and those three were only
acquaintances I'd met via email/IM a few months before. When I left, I didn't
come home with "leads" or "contacts", I came home with friends and role
models, many of whom I plan on staying in touch with. I met most of the
authors of the Drupal books I've read, associated faces to the podcasts and
RSS feeds I subscribe to, and I even had the opportunity to quickly say thanks
to Dries and shake his hand.

For those who didn't know, archive.org has made the sessions [available for
download](http://www.archive.org/search.php?query=DrupalCon&sort=-publicdate),
so be sure to check those out. Read on for my "takeaways" from DCSF2010.

Please note that these are just what come to my mind, I'm sure I'm forgetting
huge topics. Please forgive me in advance for those!

## Larry Garfield is my favorite presenter of the conference

[Larry Garfield](http://drupal.org/user/26398) works for
[Palantir.net](http://palantir.net/), and is one of the few people that I've
listened to that is immensely intelligent, yet speak well and even make a
crowd genuinely laugh out loud. I attended his "Objectifying PHP" and "Views
for Developers" sessions, and left feeling motivated and enlightened. My
thanks go out to him, as he very obviously put a lot of preparation time into
his presentations.

## Drupal is methodically (pun intended) implementing OO

As evidenced by Larry Garfield's "Objectfying PHP" and John VanDyk's "Batch vs
Queue" session, Drupal is refactoring portions of core into classes and
methods where it fits. I'm part of the camp that welcomes the change, and
can't wait. I can't help but wonder if we'll alienate some contrib module
authors in the process, but I'm sure that it will bring the overall quality of
contrib modules up a few notches.

## David Strauss knows what he's talking about

I've been in IT/Networking/Programming/etc for about 20 years now. While I
don't claim to be the smartest person in the group at any point in time, I
consider myself pretty well rounded. It's been a long time since someone was
able to truly talk so far over my head that I couldn't keep up, but [David
Strauss](http://fourkitchens.com/bios/david-strauss) of [Four
Kitchens](http://fourkitchens.com/) did just that at the [Chapter Three
](http://chapterthree.com)open house party. We discussed HipHop PHP, operating
systems, configuration management, and god knows what else. I had to look like
a deer in headlights!

## HipHop PHP will eventually run Drupal

I can say this because David Strauss is the one working on it. Enough said.

## Microsoft is playing it smart

Instead of trying to compete with Drupal, they're finally trying to help
Drupal. I'm a hardcore anything-but-Microsoft OS kinda guy, but I can't
dispute that there's a lot of shops out there that already have well versed
SQL Server and IIS admins. Microsoft announced that they now have a native SQL
Server driver for PHP, and that Drupal can now run on MS SQL Server. This will
be a huge boon for getting Drupal into the Microsoft-centric enterprises -
there's no longer a need to have a MySQL guy. Oh, and [giving away free
alcohol](http://www.sysadminsjourney.com/content/2010/04/20/2010-what-year)
never hurt either :)

## MongoDB will have a large impact on Drupal 7

[Chx](http://drupal.org/user/9446) gave an excellent presentation - "[MongoDB:
Humongous Drupal](http://sf2010.drupal.org/conference/sessions/mongodb-
humongous-drupal)". He covered a lot about SQL, and how over the years it's
become "best practice" to de-normalize tables to improve performance. We've
all done that, but have you ever pondered that you're breaking one of the
fundamental rules of relational databases when you've done that? While MongoDB
is perfectly suited for logging and caching in Drupal, the biggest win is with
Fields in Drupal 7. Each field you create results in a new table that must be
added to a JOIN when building a node. Shops with a lot of fields on their
nodes will likely see huge gains in performance by moving to MongoDB for those
tables.

## Big Drupal is Big

Hey, did you hear that Drupal powers whitehouse.gov? Seriously, there's been a
lot of progress in the past year with regards to making Drupal scale. [Project
Mercury](http://getpantheon.com/mercury/what-is-mercury) from the great folks
at [Chapter Three](http://www.chapterthree.com) makes Big Drupal easy, and is
now supported on Amazon's EC2, Rackspace, and
[Linode](http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df)
<shameless_plug>thanks to my
[stackscript](http://www.sysadminsjourney.com/content/2010/04/12/new-linode-
stackscript-pantheon-mercury-high-performance-drupal-10-minutes-or-
less)</shameless_plug>. There was a huge amount of interest in Mercury and how
it all works at the conference. The BOF session was great - unfortunately I
missed the sessions where it was discussed in more detail.

## Chapter Three rocks

Two out of the three people I knew coming into DCSF currently work for Chapter
Three, and the third person used to work for them. Special thanks to [Greg
Coit](http://www.chapterthree.com/about_us/greg_coit) and [Kevin
Montgomery](http://uptownalmanac.com/users/kmonty) for taking me under their
wing and introducing me to all their colleagues. I also had the pleasure to
meet [Josh Koenig](http://www.chapterthree.com/blog/josh_koenig), albeit
briefly. Seems the partner/CTO of one of the leading Drupal shops is a little
busy at a DrupalCon. I ended up meeting a few other guys that I clicked really
well with and hope to keep tabs on: Jeff Graham of
[FunnyMonkey](http://www.funnymonkey.com/), Rob Wohleb of
[Xomba.com](http://www.xomba.com/), and Aaron Levy of [Chapter
Three](http://www.chapterthree.com) - thanks for the beer and discussion!

## Git will change Drupal.org

The migration to Git can't happen fast enough for me. Aside from the ability
to commit code on a plane, contrib modules will benefit greatly. When all is
said and done, every new issue on drupal.org will have it's own repository
that any user will be able to commit to. Once the issue is resolved, the fix
will be merged back into the main module repo. That should break down even
more barriers for new contrib authors getting into Drupal development.

## Dries Buytaert is really tall

Yes, Dries is very tall - at least 6'4" if I had to guess, but this is
actually just a way for me to remind you that I shook Dries' hand :) I was
more than a little starstruck!

Overall, I had a blast, and can't wait for the next DrupalCon in the states. I
heard it's in Chicago -- count me in! If you ever get the chance, I absolutely
recommend that you attend.

