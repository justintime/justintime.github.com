---
title: Apache, mod_ssl, and the Sun Fire T1000 - Part II
permalink: /content/2007/08/08/apache-modssl-and-sun-fire-t1000-part-ii
layout: post
categories:
- Apache
- Perl
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
After recompiling Apache to take advantage of the T1000's MAU as described in
[part I](http://techadvise.com/2007/08/08/apache-mod_ssl-and-the-sun-fire-t1000/), I set out to doing some testing. Something was amiss - using
some clients, I would see SSL page load times of about .025 seconds, others
took close to a second. The v210 consistently tested out at about .080 seconds
per page. **Do not use the worker MPM with the pkcs11 engine!!!!** There is [a bug on OpenSolaris.org](http://bugs.opensolaris.org/bugdatabase/view_bug.do?bug_id=6540060) that **will** bite you. [In part III I'll compare performance of worker vs prefork on the T1000 that will follow up with this issue](http://techadvise.com/2007/08/15/apache-mod_ssl-and-the-sun-fire-t1000-part-iii/). After a lot of Googling, I finally figured out what it was. The
T1000's MAU is only fast at doing RSA, and it generally sucks loudly when it
tries to do anything with DH signing. [Bug # 6241300 on OpenSolaris](http://bugs.opensolaris.org/bugdatabase/view_bug.do?bug_id=6241300) confirmed the
issue. If you limit mod_ssl's CipherSuite to just RSA algorithms, performance
is great. However, we're ecommerce here, and we don't want to turn away
anyone. Especially if they're trying to go SSL, which is generally reserved
for registering and checkout. So I though to myself, why not try our best to
use RSA with everyone, but if they can't or won't do it, then we fall back to
DH and eat the performance hit? I read [Apache's documentation on the CipherSuite directive](http://httpd.apache.org/docs/2.0/mod/mod_ssl.html#sslciphersuite)
until I could recite it word-for-word from memory. No matter what I did, I
could not get FireFox to negotiate RC4-MD5 if there were any 256bit
ciphersuites offered. I found a nice online tool at
[ServerSniff.net](http://www.serversniff.net/sslcheck.php) that allows you to
find out what other sites are offering for ciphersuites. Using Amazon.com as
my model, I found that they were somehow forcing me to use RC4-MD5 as long as
my browser supported it. Just as I was ready to throw in the towel, and give
up, I found the [SSLHonorCipherOrder](http://httpd.apache.org/docs/2.2/mod/mod_ssl.html#sslhonorcipherorder) Apache directive. Yaayyyy!!! Crap! That feature
was added in Apache 2.2 - we're on 2.0. Before I get into the details, let me
explain what this option does. The SSL specification says that as part of SSL
negotiation, the server can dictate what the ciphersuite will be. However,
until the SSLHonorCipherOrder option was introduced, Apache always went with
what the client wanted to use. So, envision the server and the client walking
down the street. They bump into each other, and want to talk in a secret
language:

  * **Server:** Hi, I can speak the following secret languages: A,B,C,X,Y,Z. Which would you like to use?
  * **Client:** I can speak all of those too, but my favorite is Y. Let's use that.
  * **Server:** Sounds good to me!

Now, when you set SSLHonorCipherOrder to true, the conversation is like this:

  * **Server:** Hi, what secret languages can you speak?
  * **Client:** I can speak A,B,C,X,Y,Z.
  * **Server:** Well, A is first in my list, we'll use A.

So, by turning on SSLHonorCipherOrder, I can get the desired behavior where
Apache does everything it can to use high performance ciphersuites before
falling back to the slow ones! Now about that Apache 2.2 thing... Using my
elite Googling skills once more, I found that the SSLHonorCipherOrder was a
feature that was actually added to Apache when it was in 2.0, but it was
branched off into 2.1 which eventually became 2.2. This meant that I might
actually be able to "backport" that feature to 2.0 by simply copying and
pasting some code. I found [the original Apache bug](http://issues.apache.org/bugzilla/show_bug.cgi?id=28665) and tried to
patch it against 2.0.59. Using 'patch < myfile.patch' got most of the way, but
there was a chunk at the end that I had to manually paste into the source
code. It still fit perfectly, but the line numbers had changed a bit. So, once
more I recompiled Apache, used the SSLHonorCipherOrder flag, and with no
complaints, Apache was off and serving requests. Now, how in the world do I
find out if it's working or not? **Verification** First, make sure that the
RSA operations of SSL are getting handed off to the hardware:

{% highlight console %}
root@web1->kstat -n ncp0 -s rsaprivate
module: ncp                             instance: 0
name:   ncp0                            class:    misc
rsaprivate                      840
{% endhighlight %}

Hit an SSL page, then check the counter again. It should be incrementing. So,
that tells us that the crypto hardware is being used, but I wanted a way to
find out what the ciphersuite distribution was. While memorizing mod_ssl's
documentation, I remembered that I could log the protocol version and
ciphersuite. So, I created a new logformat named combinedssl and used it in
httpd.conf like so:
{% highlight apache %}
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %{SSL_PROTOCOL}x %{SSL_CIPHER}x" combinedssl
CustomLog logs/www_ssl combinedssl
{% endhighlight %}
After restarting Apache, I had a logfile named logs/www_ssl with lines like
this:

    1.2.3.6 - - [08/Aug/2007:17:14:27 -0500] "GET /favicon.ico HTTP/1.1" 200 1406 "-" "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.12) Gecko/20070508 Firefox/1.5.0.12" TLSv1 RC4-MD5

Look at the last two fields - there's our SSL info! Next, I whipped up some
Perl to do a report on the data. I named it sslparse.pl:
{% highlight perl %}
#!/usr/bin/perl -w
use strict;

$|++;
my $input;
if (-t STDIN) { #is STDIN standard?
  my $file = shift || die "I need a filename to parse!n";
  open(F,"$file");
  $input = *F;
} else {
  $input = *STDIN;
}

my %sslcounts;
my %ips;
while (<$input>) {
  if (/^([0-9.]+) .* ([w-]+) ([w-]+$)/) {
    if (! defined($ips{$1})) {
      next if ($1 eq '-' || $2 eq '-');
      $ips{$1}++;
      $sslcounts{$2}{$3}{total}++;
      $sslcounts{$2}{total}++;
      $sslcounts{total}++;
    }
  }
  else { die "Can't parse!"; }
}

my $grandtotal = $sslcounts{total};
delete $sslcounts{total};
printf("%-25s %6d (%5.2f","SSL Connections",$grandtotal,"100"); print "%)n";
foreach my $proto (sort { $sslcounts{$b}{total} <=> $sslcounts{$a}{total} } keys(%sslcounts)) {
  next if ($proto eq "total");
  my $ptotal = $sslcounts{$proto}{total};
  delete $sslcounts{$proto}{total};
  printf("%-25s %6d (%5.2f","  Protocol: $proto",$ptotal,($ptotal / $grandtotal * 100)); print "%)n";
  foreach my $cipher (sort { $sslcounts{$proto}{$b}{total} <=> $sslcounts{$proto}{$a}{total} } keys(%{$sslcounts{$proto}})) {
    next if ($cipher eq "total");
    my $ctotal = $sslcounts{$proto}{$cipher}{total};
    delete $sslcounts{$proto}{$cipher}{total};
    printf("%-25s %6d (%5.2f","    $cipher",$ctotal,($ctotal / $grandtotal * 100)); print "%)n";
  }
}

{% endhighlight %}
I don't claim that the above code is proper, but I do know
that it works:

{% highlight console %}
    root@web1-> perl /tmp/sslparse.pl logs/www_ssl
    SSL Connections              250 (100.00%)
      Protocol: TLSv1            130 (52.00%)
        RC4-MD5                  117 (46.80%)
        AES256-SHA                 9 ( 3.60%)
        DES-CBC3-SHA               4 ( 1.60%)
      Protocol: SSLv3            120 (48.00%)
        RC4-MD5                  106 (42.40%)
        DES-CBC3-SHA              10 ( 4.00%)
        AES256-SHA                 4 ( 1.60%)
{% endhighlight %}

Nice! All SSL requests since we redeployed Apache are using the fast RSA
ciphersuites! For what it's worth, I could not get the nicely formatted
+HIGH:+MEDIUM:+LOW type of ciphersuite syntax to work properly. Every time I
added the word ALL to the mix, it blew up my sort order. I'd beaten my head
against the wall enough already, so I just hardcoded all the ones I wanted in
there.
{% highlight apache %}
SSLCipherSuite RC4-MD5:RC4-SHA:AES256-SHA:DES-CBC3-SHA:AES128-SHA:DES-CBC-SHA:DHE-RSA-AES256-SHA: DHE-DSS-AES256-SHA:EDH-RSA-DES-CBC3-SHA:EDH-DSS-DES-CBC3-SHA:DHE-RSA-AES128-SHA: DHE-DSS-AES128-SHA:DHE-DSS-RC4-SHA:EDH-RSA-DES-CBC-SHA:EDH-DSS-DES-CBC-SHA: DES-CBC3-MD5:RC2-CBC-MD5:RC4-64-MD5:DES-CBC-MD5:EXP1024-DHE-DSS-RC4-SHA: EXP1024-DHE-DSS-DES-CBC-SHA:EXP1024-RC2-CBC-MD5:EXP1024-RC4-MD5: EXP-EDH-RSA-DES-CBC-SHA:EXP-EDH-DSS-DES-CBC-SHA:EXP-DES-CBC-SHA:EXP-RC2-CBC-MD5
{% endhighlight %}

If anyone
knows of a cleaner way to represent that list in the same order, please let me
know. I'd also like to know what ciphersuites other ecommerce shops use.
**References used but not linked above:** Sun offers a [blueprint of the crypto accelerator of the UltraSPARC T1 processor](http://www.sun.com/blueprints/0306/819-5782.pdf) as a PDF.

