---
title: Share Your Eclipse Plugins and Configurations Across Platforms
permalink: /content/2009/12/18/share-your-eclipse-plugins-and-configurations-across-platforms
layout: post
categories:
- Code
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/eclipse-logo-white.jpg)Over the years, I've come to know
and love [Eclipse](http://eclipse.org). Though it has roots in Java,
ironically, I use Eclipse for just about everything except for coding Java (if
I wrote Java code, I'm sure I'd use Eclipse). Eclipse is great for [browsing
Subversion](http://subclipse.tigris.org), [coding
PHP](http://www.eclipse.org/pdt), [coding
Perl](http://e-p-i-c.sourceforge.net), and even [coding shell
scripts](http://sourceforge.net/project/shelled). For die hards like me,
there's the [viPlugin](http://viplugin.com) that allows you to use all the vi
commands you know and love within Eclipse. About the time you get your perfect
Eclipse setup established, you buy a new laptop on a new platform. Or, in my
case, I have three "primary" development workstations, each on a different OS.
The rest of this article will show you how to hook
[Dropbox](http://dropbox.com) into your Eclipse installation, allowing you to
share your plugins and configurations across different versions of Eclipse, on
different machines, and even on different platforms.

Truth be told, doing this type of setup with Eclipse was actually easier to do
with older versions of Eclipse. Since they've moved to the p2 provisioning
system, it became a little harder to do, but still very possible. After much
googling, I finally came across [this StackOverflow
question](http://stackoverflow.com/questions/582391/installing-eclipse-3-4
-plugins-in-a-directory-other-than-eclipsehome-plugins) that gave me the
pieces I needed to set this all up.

A little prep work on the frontend will save us a huge amount of time in
maintenance. Note that I use Dropbox in this article, but any similar service
should do. We'll setup our Linux install first, since we can script things a
little easier there. Go ahead and install Dropbox and Eclipse - they're both
very straightforward installations.

Let's assume that our Dropbox directory is directly under our home directory,
and our eclipse installation is in ~/eclipse.  Let's setup some environment
variables and create our directory structure:

    
    export DROPDIR=~/Dropbox
    export ECLIPSEDIR=~/eclipse
    cd $DROPDIR
    mkdir eclipse-custom
    cd eclipse-custom
    # Create our shared extension dir
    mkdir extensions
    # Create our workspace dir
    mkdir shared-workspace
    

With our directory structure setup, it's time to pick a plugin to install.
Let's do [PDT](http://www.eclipse.org/pdt). The key here is that we start
Eclipse by pointing it to a new configuration directory which lives on our
Dropbox account, and install the new extension. This will force Eclipse to
install the plugin to the Dropbox directory, instead of the local directory.
Start Eclipse like so:

    
    eclipse -configuration $DROPDIR/eclipse-custom/extensions/pdt/eclipse/configuration

Note that you can change the 'pdt' portion of that path to whatever you
choose, but you must include the trailing eclipse/configuration portion. Once
in Eclipse, go ahead and install PDT just as you normally would, then exit
Eclipse.

Now that we've installed the PDT extension to a shared location, it's time to
point our local Eclipse installation to it. I wrote a quick script to do just
that:

    
    mkdir $ECLIPSEDIR/links
    cd $DROPDIR/eclipse-custom/extensions
    for d in `ls`; do
      echo "path=`pwd`/$d" > $ECLIPSEDIR/links/$d.link
    done
    

This script creates a directory named 'links' in your Eclipse local
installation, and creates a file for every extension that contains one line
containing the path to the target extension. Now, start Eclipse. For some odd
reason, the extensions wouldn't actually install until after I restarted
Eclipse a second time, so you may need to do the same. You should now see your
plugin in Eclipse.

Please note that if you're doing cross-platform development, you'll save
yourself some headache by **not** sharing the subclipse plugin. There's too
much of that plugin that depends on the underlying OS to share effectively.

