---
title: Tip for "Split Components Across Domains" Performance Goal from Yahoo!
permalink: /content/2009/11/16/tip-split-components-across-domains-performance-goal-yahoo
layout: post
categories:
- Apache
- sysadmin
comments: true
sharing: true
footer: true
---
Just thought I'd pass this little tidbit out there - we fixed it by pure luck
on the first try. Yahoo unselfishly provides a document titled [Best Practices
for Speeding Up Your
Website](http://developer.yahoo.com/performance/rules.html). While some of the
rules offered there aren't applicable for all sites, it's a great document and
if you run a website, you should read it. At $work, part of our last code drop
was to push out a feature that enabled "Split Components Across Domains". From
the article [Performance Research, Part 4: Maximizing Parallel Downloads in
the Carpool Lane](http://yuiblog.com/blog/2007/04/11/performance-research-
part-4/):

> Our rule of thumb is to increase the number of parallel downloads by using
at least two, but no more than four hostnames. Once again, this underscores
the number one rule for improving response times: reduce the number of
components in the page.

I'm here to tell you, if you have AOL users surfing your site, **do not use
four hostnames**.  When we pushed this feature up to production, we had one
hostname that served up the HTML, and we had four hostnames that served up
imagery (all these hostnames pointed back to the same IP, but doing this
allows a performance boost in the browser). For this example, let's say that
www.mydomain.com is the HTML hostname; img0.mycontent.com, img1.mycontent.com,
img2.mycontent.com, and img3.mycontent.com were the imagery servers. This most
certainly improved performance on the client side, but we started receiving
some reports from a few users that they were no longer able to see **any**
imagery on the site since we dropped the new code. We immediately knew what
was causing the issue, but had no idea why, or how far spread out it was.
Well, after poking around some of the "big boys" websites such as Amazon, we
noticed that while all of them separated their components as suggested by
Yahoo!, all of them used only one hostname for the imagery. We quickly
configured our webapp to only use www.mydomain.com for the HTML, and
img0.mycontent.com for the imagery. Once we did that, our AOL users were again
able to see imagery. Now, I have no idea how widespread the issue was. I know
it was limited to users of the AOL browser, and I suspect it's probably a bug
in a specific version of their browser. However, if your site needs to provide
compatibility to the most users possible, you may want to use just one
separate hostname for splitting components. I hope this helps someone else!

