---
title: Selecting the right CDN for YOUR website
permalink: /content/2011/04/19/selecting-right-cdn-your-website
layout: post
categories:
- Drupal Planet
comments: true
sharing: true
footer: true
---
At one of my jobs, we recently went through the process of selecting a
[CDN (Content Delivery Network)][] for our site. While the first rule of
CDN’s is that “any CDN is better than no CDN”, it can be argued that
certain CDN’s are a better fit in certain situation than others. This
post is basically a summary of the process we went through when
selecting our CDN. By no means is this a statement of “XYZ is better
than ABC”, it’s simply documentation of the process we went through in
order to select the right one for our business. While most CDN’s are
compatible with Drupal via excellent contrib modules such as [CDN][],
this information presented in this article is relative to any website
and isn’t Drupal-specific.

To illustrate the importance of a CDN using real numbers, one image
being fetched from the data center to our office takes about 323ms. That
same image fetched from Seattle is 483ms, and from Washington DC takes
599ms. The worst cases appear when coming overseas - to fetch the same
image from Paris it takes on average 1,141ms **for just that one image**.

A Content Delivery Network (CDN) shortens that distance between your
static content and the end-user. While the text on most web pages is
dynamic, most images, JavaScript, and CSS are static. These static
objects make up a large percentage of the total bytes downloaded for
each page view. By using a CDN, you place static content as close to the
end-user as possible. In turn this decreases the page load time a
end-user experiences by leaps and bounds.

### Pre-selection Criteria

There’s a plethora of CDN’s to choose from, and if you don’t filter the
initial list down to five or fewer providers, you’ll end up spending
months in evaluation time. By defining specific must-have features, we
were able to limit the initial number of companies to compare to four.
Many CDN’s provide value-add services above and beyone static objects,
such as “Dynamic Site Acceleration” – this evaluation looked solely at
serving up static file content, e.g. JPEG, GIF, CSS, and Javascript.

The filtering properties we used to limit scope were:

1.  **The CDN must provide “origin pull” or “reverse proxy” support**. If
    the CDN receives a request for a file that doesn’t exist at the edge, it
    applies a customer-defined URL rewrite to the request, and proxies the
    request to the origin site. If the image exists at the origin, the edge
    server caches the image locally and serves it to the client from there.
    For example, the CDN host name might be cdn.example.com (which points to
    the edge), and the origin site (my server) would be www.example.com. If
    I point my browser to http://cdn.example.com/logo.gif, and that file
    doesn’t exist at the edge, the CDN will make a request for
    http://www.example.com/logo.gif. If that file exists, it is fetched and
    cached. If it doesn’t exist, a 404 is returned to the client. The trade
    off is that you don’t have to pre-seed static content to the CDN, but
    the first user request for a static object takes a bit longer to
    complete (because it results in two requests instead of one). Once the
    edge network’s cache is primed, there is no performance difference
    between origin pull and CDN origin.

2.  **The CDN must propagate cache-related HTTP headers from the origin to
    the end-user** We’ve went to great lengths to use versioning of
    filenames so that we can set far-future expires headers on 99% of our
    static content as recommended by [Yahoo’s “Best Practices for Speeding Up Your Website”][]. 
    This results in far fewer HTTP requests to render a
    page that has already been requested by the end-user previously,
    ultimately decreasing page response time. Some CDN’s that offer origin
    pull do not proxy these headers back.

3.  **The CDN must use GZip compression on text-based content** Most CDN’s
    support this, but it’s something you definitely want to check. When
    serving up static text-based content such as CSS or Javascript, the CDN
    can and should compress it for you before sending it to the end-user.
    Compression makes the overall page content smaller, and therefore faster
    to render.

4.  **Response time must be consistent and fast** Performance is a tricky
    thing. While having the fastest response time overall didn’t guarantee
    that a CDN would “win”, having consistent relative poor performance
    would guarantee a CDN would “lose”. Try not to focus too much on
    performance numbers – most of the CDN’s will have a standard deviation
    less than ten milliseconds between each other. In our research we found
    out quickly that there’s a lot of features more important to us than 5ms
    worth of response time.

5.  **100% Uptime SLA** Since a CDN is at it’s most basic level a
    geographically distributed cluster of cache servers, it should be
    implied that a CDN can provide 100% uptime. If one POP goes down,
    requests should be automatically routed to the next nearest POP. If your
    CDN doesn’t offer this, you need a new CDN.

6.  **Company financial strength and solvency** This is something often
    overlooked when people evaluate, but was very important to us. There are
    a lot of CDN’s out there, and we found only 2 or 3 that could put in
    writing that they are a profitable corporation. Our implementation
    required a fair amount of work, and it would take us some time to switch
    to another CDN. If your CDN goes dark in the middle of the night, how
    long will it take you to switch?

### Important Features

Whereas not meeting any of the above requirements would result in being
excluded from our comparison, the following features were key points of
consideration. Not meeting them all wouldn’t exclude a CDN, but on the
flip side, implementing them all would put the CDN in very good
standing.

1.  **Price**. While high prices weren’t going to scare us away, bang
    for the buck played a large part in our decision. We weren’t
    interested in paying a premium for brand recognition.

2.  **Strong international presence**. Our guests include international
    clients, and poor static object performance for those clients was
    the key motivation for implementing a CDN in the first place.

3.  **Contract terms**. Some CDN’s do month-to-month, some do 12 month,
    others require longer as you negotiate price.

4.  **Overage fees**. CDN’s meter you on the amount of bandwidth you
    consume. You pay for a “bucket”. No CDN’s turn your service off
    after you exceed that bucket, they just bill you for overages. The
    good CDN’s will bill you at the same per-GB rate that you pay for
    your monthly bucket. Some CDN’s charge as much as 2x for overages.
    Avoid those.

5.  **Traffic accounting**. One other thing often overlooked with origin
    pull CDN’s is whether or not the traffic between the edge POP’s and
    the customer origin is counted as traffic against your total. Some
    CDN’s count it against your bucket, others don’t.

6.  **Setup fees**. CDN’s vary wildly on their setup fees. Some are
    free, some charge more than $5,000. Make sure you incorporate that
    cost into your decision.

7.  **User Interface**. All CDN’s offer some form of web-based
    interface. The quality of the interface greatly differs between
    CDN’s. I could swear that some of the interfaces I saw were written
    in CGI Perl in the late 90’s. Others interfaces offered everything a
    customer could ever want, including detailed analytics and
    reporting. Key questions to ask are “If I get a bad image out on the
    edge, how do I purge it?”, and “How do I tell how much bandwidth is
    being consumed throughout the CDN at any particular point in time?”

### External Reporting Data

We chose to invest in one month’s worth of reporting from
[CloudHarmony’s CloudReports][] service. This gave us a quick way to
examine performance of CDN’s to the actual end-user browser behind a
real cable/dsl/dialup connection (not to a datacenter somewhere). While
some might view those reports expensive, we found it quite a bargain to
have another independent view into the performance of a vast majority of
CDN’s.

### The Contenders

Given the above requirements, coupled with the performance data provided
from CloudHarmony we were able to refine our list of CDN’s to consider.
In alphabetical order:

1.  [Akamai][]
2.  [CacheFly][]
3.  [EdgeCast][]
4.  [LimeLight][]

### First elimination: Akamai

Akamai is to the CDN market what Bose is to the home audio market. While
it’s not inherently a bad product, you’re paying a huge premium for the
brand name. While we never got so far as to setup a demo account, the
performance data provided by CloudHarmony and other sources didn’t favor
them well at all. My personal opinion (which is little more than a wild
guess) on why Akamai doesn’t perform as well is because of their
product’s age. Their network is by far the largest one out there, and I
can guess that keeping up with the latest optimizations and protocols is
a huge undertaking.

When speaking with Akamai, I got the impression that they really don’t
care to sell their static object delivery product by itself. Their reps
focused mostly on trying to upsell their Dynamic Site Acceleration
product. While DSA might indeed be a great product, it wasn’t what we
were interested in.

In the end, the best price I could get out of Akamai was more than twice
that of the next most expensive CDN in our comparison, and they wanted a
3 year contract at that price. I’m just not that into paying twice as
much for an equal product, so they were eliminated. If we should move to
a Dynamic Site Acceleration type of service later, Akamai will
definitely be re-evaluated at that time.

### Second elimination: LimeLight

LimeLight Networks is the 2nd largest CDN provider, behind Akamai. It’s
fitting that they are right behind Akamai, because they came across like
a smaller Akamai to me. Their pricing is much more competitive than
Akamai, and performance appeared to be quite good across the board. They
supposedly have a nice web and reporting interface, but I was unable to
get a demo setup without filling out paperwork that would have required
approval from our legal department. Therein lies the problem with
LimeLight – getting them to do anything outside the everyday norm was
like pulling teeth. Like Akamai, LimeLight also is focused on the upsell
and seemed to me generally disinterested in selling their static
delivery service.

If for some reason, we had to switch away from our primary choice, my
second choice would likely be LimeLight Networks, but only after I was
able to obtain a demo account so that I could verify their performance
was within acceptable range and the functionality of their user
interface.

### Independent Performance comparisons

I was able to easily procure demo accounts from EdgeCast and CacheFly,
so I set up some performance testing of our own using [Pingdom][] to
download a typical JPEG image from each Pingdom POP using the origin
pull setup. Note that since Pingdom’s servers are in data centers and
not in actual residences; this isn’t a measure of end-to-end
performance, rather a way to compare apples to apples response time from
various regions around the world. The executive summary here is that
while EdgeCast “edged” out CacheFly, the real message is that any CDN is
so much better than none at all:

CDN                  | US/Non-US    | Location                 | # of Polls | Avg Response Time | Max Response Time | StdDev
:--------------------|:-------------|:-------------------------|:-----------|:------------------|:------------------|:-------
CacheFly             | Non-US       | Amsterdam 2, Netherlands | 289        | 68                | 4202              | 285.98
                     |              | Copenhagen, Denmark      | 259        | 158               | 461               | 36.02 
                     |              | Frankfurt, Germany       | 287        | 41                | 567               | 32.38 
                     |              | London 2, UK             | 290        | 29                | 2489              | 145.26
                     |              | London, UK               | 284        | 29                | 127               | 11.30 
                     |              | Madrid, Spain            | 259        | 201               | 586               | 31.36 
                     |              | Manchester, UK           | 281        | 129               | 1709              | 184.87
                     |              | Montreal, Canada         | 286        | 105               | 3084              | 250.63
                     |              | Paris, France            | 286        | 143               | 521               | 60.11 
                     |              | Stockholm, Sweden        | 286        | 54                | 882               | 80.88 
                     | Non-US Total |                          | 2807       | 94                | 4202              | 157.88           
                     | US           | Atlanta, Georgia         | 289        | 16                | 398               | 23.52 
                     |              | Chicago, IL              | 288        | 56                | 2615              | 158.33
                     |              | Dallas 4, TX             | 286        | 40                | 960               | 74.61 
                     |              | Dallas 5, TX             | 289        | 26                | 1506              | 89.08 
                     |              | Dallas 6, TX             | 291        | 47                | 1473              | 132.25
                     |              | Denver, CO               | 289        | 216               | 925               | 72.18 
                     |              | Herndon, VA              | 288        | 473               | 3472              | 196.13
                     |              | Houston 3, TX            | 289        | 107               | 382               | 18.15 
                     |              | Las Vegas, NV            | 288        | 74                | 3044              | 180.60
                     |              | Los Angeles, CA          | 289        | 12                | 92                | 11.52 
                     |              | New York, NY             | 289        | 175               | 2571              | 152.29
                     |              | San Francisco, CA        | 287        | 28                | 231               | 24.17 
                     |              | Seattle, WA              | 288        | 174               | 1083              | 108.41
                     |              | Tampa, Florida           | 267        | 68                | 3048              | 214.49
                     |              | Washington, DC           | 286        | 163               | 1547              | 141.67
                     | US Total     |                          | 4303       | 112               | 3472              | 170.11
CacheFly Total       |              |                          | 7110       | 105               | 4202              | 165.61
                     |              |                          |            |                   |                   |       
EdgeCast Small       | Non-US       | Amsterdam 2, Netherlands | 284        | 62                | 381               | 27.49 
                     |              | Copenhagen, Denmark      | 254        | 126               | 1148              | 87.72 
                     |              | Frankfurt, Germany       | 284        | 40                | 318               | 19.05 
                     |              | London 2, UK             | 284        | 26                | 975               | 59.59 
                     |              | London, UK               | 283        | 23                | 191               | 14.38 
                     |              | Madrid, Spain            | 252        | 176               | 1174              | 112.31
                     |              | Manchester, UK           | 275        | 86                | 1494              | 118.26
                     |              | Montreal, Canada         | 283        | 163               | 601               | 59.56 
                     |              | Paris, France            | 283        | 94                | 1537              | 140.76
                     |              | Stockholm, Sweden        | 271        | 162               | 967               | 81.87 
                     | Non-US Total |                          | 2753       | 94                | 1537              | 99.35            
                     | US           | Atlanta, Georgia         | 284        | 129               | 523               | 34.51
                     |              | Chicago, IL              | 284        | 26                | 463               | 35.86 
                     |              | Dallas 4, TX             | 277        | 30                | 339               | 25.79 
                     |              | Dallas 5, TX             | 284        | 26                | 581               | 50.32 
                     |              | Dallas 6, TX             | 284        | 23                | 430               | 33.68 
                     |              | Denver, CO               | 281        | 244               | 2169              | 150.12
                     |              | Herndon, VA              | 280        | 24                | 301               | 20.44 
                     |              | Houston 3, TX            | 281        | 115               | 441               | 40.02 
                     |              | Las Vegas, NV            | 281        | 56                | 559               | 34.32 
                     |              | Los Angeles, CA          | 283        | 11                | 94                | 8.45  
                     |              | New York, NY             | 284        | 72                | 1134              | 161.16
                     |              | San Francisco, CA        | 280        | 23                | 118               | 11.01 
                     |              | Seattle, WA              | 282        | 131               | 3571              | 333.38
                     |              | Tampa, Florida           | 260        | 166               | 4977              | 303.29
                     |              | Washington, DC           | 282        | 83                | 686               | 111.97
                     | US Total     |                          | 4207       | 77                | 4977              | 148.63
EdgeCast Small Total |              |                          | 6960       | 84                | 4977              | 131.64
                     |              |                          |            |                   |                   |       
Data Center          | Non-US       | Amsterdam 2, Netherlands | 292        | 837               | 1344              | 35.72 
                     |              | Copenhagen, Denmark      | 262        | 990               | 4195              | 297.90
                     |              | Frankfurt, Germany       | 291        | 867               | 1533              | 57.14 
                     |              | London 2, UK             | 291        | 725               | 1065              | 25.95 
                     |              | London, UK               | 290        | 811               | 1114              | 49.50 
                     |              | Madrid, Spain            | 262        | 1005              | 1765              | 75.84 
                     |              | Manchester, UK           | 281        | 899               | 8928              | 580.11
                     |              | Montreal, Canada         | 291        | 342               | 412               | 11.52 
                     |              | Paris, France            | 293        | 1128              | 2680              | 230.78
                     |              | Stockholm, Sweden        | 292        | 1063              | 4056              | 367.89
                     | Non-US Total |                          | 2845       | 864               | 8928              | 326.71           
                     | US           | Atlanta, Georgia         | 291        | 316               | 1017              | 63.48 
                     |              | Chicago, IL              | 290        | 170               | 253               | 7.02  
                     |              | Dallas 4, TX             | 292        | 191               | 3214              | 253.67
                     |              | Dallas 5, TX             | 292        | 145               | 263               | 14.52 
                     |              | Dallas 6, TX             | 291        | 147               | 358               | 22.93 
                     |              | Denver, CO               | 291        | 71                | 272               | 14.63 
                     |              | Herndon, VA              | 293        | 316               | 487               | 15.43 
                     |              | Houston 3, TX            | 293        | 177               | 372               | 19.66 
                     |              | Las Vegas, NV            | 290        | 246               | 3194              | 392.02
                     |              | Los Angeles, CA          | 291        | 303               | 1188              | 57.60 
                     |              | New York, NY             | 290        | 346               | 1120              | 123.55
                     |              | San Francisco, CA        | 293        | 229               | 519               | 22.28 
                     |              | Seattle, WA              | 290        | 489               | 1078              | 170.33
                     |              | Tampa, Florida           | 270        | 331               | 4105              | 247.99
                     |              | Washington, DC           | 290        | 595               | 1511              | 235.84
                     | US Total     |                          | 4347       | 271               | 4105              | 208.20
Data Center Total    |              |                          | 7192       | 506               | 8928              | 390.52


... and to really drive the point home for the PHB's, we consolidate the
data and give a very telling graph:

![](/assets/images/cdn.png)

### Third elimination: CacheFly

CacheFly is an up-and-comer in the CDN arena. They have **very**
aggressive pricing, and have very good performance as well. If the site
in question was a popular blog or community website and was very price
sensitive, I would select CacheFly as my first choice CDN. However,
where they fall short is in reporting and their web interface. The best
way to contact their support department is via email or web-based form.
Their web interface left a huge amount to be desired, and they have very
little documentation on how to use it. There is no reporting whatsoever
– you get raw log files and have to write our own reporting scripts on
top of that data. I couldn't help but wonder about all the “what ifs”.
What if we get an incorrect image cached and need to have it cleared
from their network? If we see a DDoS at the CDN, how do we know? These
and other similiar questions are what ultimately eliminated CacheFly.

In CacheFly's defense, I was told that they were working on a complete
refactor of the user interface and was offered a chance to help beta it,
but I was under time constraints and declined. The issues I had with the
UI may or may not be present at the time of this writing.

### The winner (for us): EdgeCast

It will appear when reading this post that I used the process of
elimination to find the "lesser of all evils", but understand that's
just the writing style I chose to convey the process. It wasn't that
EdgeCast didn't lose, it's that they won. Here's why:

-   EdgeCast is routinely in the top tier of CDN’s in terms of
    performance.
-   Their support is very knowledgeable and responsive.
-   The sales reps care about your business and are willing to work with
    you.
-   They offer the most features of any CDN I evaluated. One such
    feature is "rollover" where if you don't use all your allotted
    transfer for one month, the remainder gets added to next months
    allotment. This is perfect for a business with holiday traffic
    spikes such as ours.
-   While they aren’t the cheapest CDN, they are certainly affordable,
    and offered the best “bang for the buck” for the feature set we
    needed.
-   Their UI is fully functional, offering configuration, reporting, and
    analytics in an easy to use fashion. The UI includes a fully
    functional rules engine (for additional charge) that allows you to
    apply actions such as cache purge, header change, etc based upon
    conditions like client IP, HTTP request header, etc.
-   Last but certainly not least, the company is one of only two
    profitable CDN’s in the market today.

### IT'S NOT THE DESTINATION, IT'S THE JOURNEY!!!

Please don't read this article and walk away saying "Justin recommends
EdgeCast, that's who we're going with". For one, if you're letting my
blog posts make business decisions for you instead of doing due
diligence, then you're doing it wrong.

For our **very specific needs** EdgeCast was the best fit. For your
needs, you will very possibly arrive at a completely different decision,
and that's great. By all means, blog about it. What I'm trying to convey
is that there are a lot of points of comparison when going through your
evaluation, and not all of them are obvious. It's hard to get an
objective point of view when doing this on your own -- this is my best
attempt at documenting what I came across.

Hopefully if you haven't implemented a CDN for your busy sites, this
post will motivate you to do so. If you're unhappy with your current
CDN, perhaps this post has given you some insight on how to find a
replacement. If you're happy with your current CDN, please leave
comments as to why.

Lastly, I was in no way influenced monetarily or otherwise by any
vendors, and none of the links in this article contain referral ID's.
This is all my personal opinion and in no way represents the opinion of
my employers.

  [Pingdom]: http://www.pingdom.com
  [CDN (Content Delivery Network)]: http://en.wikipedia.org/wiki/Content_delivery_network
  [CDN]: http://drupal.org/project/cdn
  [Yahoo’s “Best Practices for Speeding Up Your Website”]: https://developer.yahoo.com/performance/rules.html
  [CloudHarmony’s CloudReports]: http://cloudharmony.com/reports
  [Akamai]: http://www.akamai.com
  [CacheFly]: http://www.cachefly.com
  [EdgeCast]: http://www.edgecast.com
  [LimeLight]: http://www.limelight.com

