---
title: Drupal, meet Hudson; Hudson, Drupal...
permalink: /content/2010/01/20/drupal-meet-hudson-hudson-drupal
layout: post
categories:
- Drupal
- Drupal Planet
comments: true
sharing: true
footer: true
---
At $work, we use [Hudson](https://hudson.dev.java.net/) extensively, and it
rocks. For those who don't know already, Hudson is an implementation of
[Continuous Integration](http://en.wikipedia.org/wiki/Continuous_integration)
that is remarkably easy to use. I wrote about my [first impressions of Hudson](http://sysadminsjourney.com/content/2009/08/13/hudson-cruisecontrol-2)
previously. Hudson's original audience was Java developers using Ant or Maven,
but with plugins and some hacking, we can make it do some things for us as
module contributors to Drupal.  I've been cutting my Drupal developer teeth by
working pretty intensively on a few modules for Drupal - [Node Gallery](http://drupal.org/project/node_gallery) and it's derivatives. We are
hitting a crucial point in development where we are switching from the old way
of defining fields on a node to using CCK. While the module is still in alpha,
it's still in use by quite a few sites - as of this writing it's number 465 on
the list of Drupal modules. Not exactly the spotlight, but we can't go
breaking things without making people angry either. I figured this would be
the perfect place for Hudson - it will let you know when you break something.

### Pieces of the Puzzle

Here's the pieces you'll need:

  * A linux server with Java, a working Drupal install (that may get broken at times) and the cvs command-line utility. 
  * These Drupal modules installed and enabled: [drush](http://drupal.org/project/drush), [coder](http://drupal.org/project/coder), and optionally [simpletest](http://drupal.org/project/simpletest).
  * Some time on your hands

### The shell script

This is the most important piece of the setup. By utilizing Hudson's
environment variables, we can make this as portable as possible. By using the
same script for all Hudson jobs, changing the script automatically changes all
of our jobs at once. Let's dive right in:
{% highlight bash %}
#!/bin/bash
#set -x

PHP=/usr/bin/php
DRUSH_PATH=/apps/drupal/drush
DRUPAL_PATH=/apps/drupal/drupal_core
MODULES_DIR=$DRUPAL_PATH/sites/ngdemo.sysadminsjourney.com/modules
SITE="http://ngdemo.sysadminsjourney.com/"

DRUSH="$PHP $DRUSH_PATH/drush.php -n -r $DRUPAL_PATH -i $DRUPAL_PATH -l $SITE"
EXITVAL=0

# Check our syntax
PHP_FILES=`/usr/bin/find $WORKSPACE -type f -exec grep -q '<?php' {} \; -print`
for f in $PHP_FILES; do
  $PHP -l $f
  if [ $? != 0 ]; then
    let "EXITVAL += 1"
    echo "$f failed PHP lint test, not syncing to ngdemo website."
    exit $EXITVAL
  fi
done

#Install the files
/usr/bin/rsync -a --delete $WORKSPACE/* $MODULES_DIR/$JOB_NAME

#Run update.php
$DRUSH updatedb -q --yes

#Run coder
CODER_OUTPUT=`$DRUSH coder no-empty`
if [ -n "`echo $CODER_OUTPUT | grep $JOB_NAME`" ]; then
  $DRUSH coder no-empty
  echo "Coder module reported errors."
  let "EXITVAL += 1"
fi

#Run potx
cd $MODULES_DIR/$JOB_NAME
../potx/potx-cli.php
if [ $? != 0 ]; then
  let "EXITVAL += 1"
  echo "POTX failed."
fi
if [ -e $MODULES_DIR/$JOB_NAME/general.pot ]; then
  cp $MODULES_DIR/$JOB_NAME/general.pot $MODULES_DIR/../files/$JOB_NAME.pot
fi

exit $EXITVAL
{% endhighlight %}
Lines 14 through 23 find all files in $WORKSPACE (which is
set by Hudson) that have the 'must** name your Hudson project the same as the
module name. Also note that your Hudson user needs to have write access to the
specific module directory that it's installing. Line 29 runs drush so that it
invokes update.php, and answers yes to all questions. Lines 32 through 37 runs
the default code review from the coder module. You will have had to set this
up initially via the web interface. It then scans through that output looking
for any complaints about our $JOB_NAME, and if found, prints it to stdout and
increments our exit value by 1. Note we don't exit here, as it's a non-fatal
error. However, Hudson will treat it as a failed build and email everyone
about it. Lines 40 through 48 runs the Translation Template Extractor command
line utility against our module. It then copies the general.pot to the files
directory. Again, the user running Hudson will need write access for this to
work properly. If the potx-cli.php script should exit uncleanly, we increment
our exit value by one. Last in my script, we simply exit with whatever value
we have ended up with at this point. Again, if Hudson sees anything other than
a zero, it will email everyone about it. Since the modules I'm working on
don't have Simpletest tests ready yet, I don't run them in this script.
However, it's on the horizon, and can be ran easily using run-tests.sh. Note
that there is [a patch](http://drupal.org/node/602332) that will cause run-
tests.sh to output it's results in a JUnit style output, which Hudson
understands fully. If you implement this, I strongly recommend applying that
patch.

### Hudson Setup

Now that we have our script ready, we need to setup our Hudson job. Note that
installing Hudson itself is outside the scope of this article - it's
refreshingly easy and doesn't need repeating here. There are two things you
must do before creating the build task. First, setup your "E-mail
Notification" section according to your mail server at
http://myhudsonserver:8080/configure. Also, you will need to install the "URL
Change Trigger" plugin by navigating to
http://myhudsonserver:8080/pluginManager/available. Once you install that
plugin, create a new job. In my case, the job was named 'node_gallery', since
that's the name of the Drupal module I was working with. Select 'Build a free-
style software project' when asked. Under the "Source Code Management"
section, select "CVS", and then fill in the CVSROOT of the project you're
working with. In my case, it was
':pserver:anonymous:anonymous@cvs.drupal.org:/cvs/drupal-contrib'. Next, fill
in the path to the module in the "Module(s)" form - for me it's
'contributions/modules/node_gallery/'. If you're working with CVS HEAD, leave
the Branch field empty, otherwise type in the branch name there.
**IMPORTANT:** to avoid abusing Drupal.org's already overloaded CVS server
with cvs logins once every 5 minutes, we will point Hudson instead to the RSS
feed for the CVS log messages. Make sure "Poll SCM" is unchecked, and check
"Build when a URL's content changes". To obtain the URL, you need the node id
of your project. There's many ways to do this, but you can find it by going to
the project's Drupal.org page and click on "View CVS Messages". From that
page, click the orange RSS icon at the bottom left of that page. Copy and
paste that URL into the URL field in Hudson. Under the Build section, click
"Add build step", and select "Execute Shell". In the resulting "Command"
textarea, type the full path to the shell script we setup above. The final
section, "Post-build actions" is up to you, but you'll likely want to enable
email notifications. Place a checkmark in the "Email Notification" box, and
type in the email addresses of the desired recipients. Click Save, and you're
done! Hudson will start doing a CVS checkout of your project, and will start
running tests on it. It will email you once anything goes wrong, and will
notify you again when the problem is resolved. It will only run these tests
after someone commits code to CVS, so you will likely need to hit the "Build
Now" link in the left nav a few times. We've really only scratched the surface
of what Hudson can do. You can track performance using JMeter, add all kinds
of crazy plugins, require logins, the list goes on and on. While this helps,
it's still nowhere as helpful as a Ant/Maven job can be. Hopefully this
article is enough to spark some interest from the Drupal community so that we
can write some better continuous integration code in the future. Also, I'm far
from being an expert on either Drupal or Hudson. I wrote my first code for
Drupal in November of 2009, and I only tinker with Hudson on occasion at work.
Hudson works so well, it's one of those "set it and forget it" apps. I would
love for readers to leave comments on any mistakes I might have made, or
possible improvements I may have missed!

