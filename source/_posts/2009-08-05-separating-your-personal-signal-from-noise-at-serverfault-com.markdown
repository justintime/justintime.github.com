---
title: Separating Your Personal Signal from Noise at ServerFault.com
permalink: /content/2009/08/05/separating-your-personal-signal-noise-serverfaultcom
layout: post
categories:
- Sites I Like
- sysadmin
comments: true
sharing: true
footer: true
---
Matt Simmons over at [Standalone Sysadmin](http://www.standalone-
sysadmin.com/) has been evangelizing ServerFault.com for awhile now. The idea
is great, and it really works - I've learned a lot of things from the site
already. However, checking websites is so 1998 - everything I do is RSS now.
Simply adding the homepage of ServerFault.com to your RSS reader using
http://serverfault.com/feeds results in a huge amount of items that I could
care less about, and I hate clutter in my RSS reader. After poking around a
bit, I found some undocumented features that you can use to eliminate unneeded
noise from your RSS feed (or your browser if you still live in 1998 :-) ).
The key to doing this is tags. Every question on ServerFault has one or more
tags. You can view them all at
[http://serverfault.com/tags](http://serverfault.com/tags). There's two ways
you can go about getting only what you want in your feed -- excluding tags or
including tags. Let's start with including tags.

## Including Tags

When using this method, I haven't figured out how to use an "OR" when using
multiple tags, you can only use the builtin AND operation. Let's say that you
only want questions tagged with Linux. Easy enough, your feed URL would be [ht
tp://serverfault.com/feeds/tag/linux](http://serverfault.com/feeds/tag/linux).
Now your feed will only show you questions tagged with Linux. Say that's
getting to be TMI, and you want to limit that feed to only include questions
tagged Linux and Ubuntu. Simply add more tags to your feed URL with +tagname,
and urlencode the plus - resulting in this URL: [http://serverfault.com/feeds/
tag/linux%2bubuntu](http://serverfault.com/feeds/tag/linux%2Bubuntu). Now, you
can't do "OR"'s in a single query, but you can create multiple feed URL's that
include just what you want and use your feed reader to combine them into one
folder.

## Excluding Tags

The above example works, but not many sysadmins I know are so focused in just
a few areas. Also, the above configuration will not keep you in-tune to new
tags that you might be interested in. For myself, I'm interested in everything
except anything Windows related. By excluding tags, you will need to go
through an iterative process, but once you're done you'll be quite happy with
the results. Let's get to it. The first step is to make a URL that gives an
RSS feed for all posts not tagged windows. Easy: [http://serverfault.com/feeds
/tag/-windows](http://serverfault.com/feeds/tag/-windows). Now, unfortunately,
many questions are tagged as windows-server-2003, but are not tagged windows.
So, we append the URL with a "AND NOT THISTAG" operation like this:
[http://serverfault.com/feeds/tag/-windows%2B-windows-
server-2003](http://serverfault.com/feeds/tag/-windows%2B-windows-
server-2003). You can see where I'm going with this now. Using these two
methods, you can create a very nice, clean, and relevant personal RSS feed for
ServerFault's questions. Nothing here is rocket science, but it's not
documented either -- hopefully it helps someone else. Note that you can
preview what your query will generate in your browser by replacing "feeds/tag"
in the URL with "tags". In case you're wondering, my "everything except
Windows" feed URL is still not perfect, but here's what I've got so far:
[http://serverfault.com/feeds/tag/-windows%2B-windows-server-2003%2B-sqlserver
%2B-windows-server-2008%2B-windows-xp%2B-iis%2B-active-directory%2B-sharepoint
%2B-vista%2B-exchange%2B-outlook](http://serverfault.com/feeds/tag/-windows
%2B-windows-server-2003%2B-sqlserver%2B-windows-server-2008%2B-windows-xp%2B-
iis%2B-active-directory%2B-sharepoint%2B-vista%2B-exchange%2B-outlook). Share
your URL's and tips I may have missed in the comments!

