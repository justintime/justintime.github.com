---
title: Using Git Submodules with Dynamic Puppet Environments
permalink: /content/using-git-submodules-dynamic-puppet-environments
layout: post
categories:
- devops
- git
- puppet
- sysadmin
comments: true
sharing: true
footer: true
---
There comes a point in the lifecycle of every Puppet setup where you realize
that you're going to be much better off utilizing other peoples' Puppet
modules whenever possible.  It's what makes OSS great -- why should I reinvent
the wheel when I can help make your wheel even better?  I've found what I
think is a very productive setup -- it leverages Git (specifically branches,
submodules, and hooks), Gitolite permissions, and Puppet environments to
create a workflow that a team of admins can use to iterate over new features
on without disturbing each other.

Most of pieces to this puzzle are very well documented elsewhere, I'll provide
links where necessary.

## Step 1: Establish Dynamic Environment Workflow

The first step is to go read "[Git Workflow and Puppet
Environments](http://puppetlabs.com/blog/git-workflow-and-puppet-environments/)" written by Adrien Thebo of Puppet Labs.  Once you've
implemented that setup, you should be able to do the following from your
workstation:
{% highlight bash %}
git clone git@git:puppet.git
cd puppet
git checkout -b mybrokenbranch
echo "this line breaks everything" >> manifests/site.pp
git commit -am 'Intentionally breaking things'
git push origin mybrokenbranch
{% endhighlight %}

At this point, you now have a new environment named 'mybrokenbranch' on your
Puppetmaster. You can test the setup by ssh'ing into the client machines and
run:
{% highlight bash %}
puppet agent --test --environment mybrokenbranch --noop
{% endhighlight %}

That obviously won't be a happy puppet run. The key
point here being that your other environments are not impacted by the work of
this one admin. Let's delete the local and remote branch. From your
workstation:
{% highlight bash %}
git checkout master
git branch -d mybrokenbranch
git push origin :mybrokenbranch
{% endhighlight %}

Note that
the Puppetmaster says that it's deleted the environment. Feel free to verify
that by running the above command on the Puppet client, it will complain about
not having an environment.

## Step 2: Incorporate Git Submodules

With all that setup, let's go ahead and implement support for git submodules.
I have a pull request off to Adrien to implement this functionality, but until
he commits it in, you can use [my fork on github](https://github.com/justintime/puppet-git-hooks). Replace the update
hook with the updated version on your git server. Now, let's try pulling a git
submodule into our repo. Again, from your workstation:
{% highlight bash %}
git checkout -b firewall
git submodule add git://github.com/puppetlabs/puppetlabs-firewall.git modules/firewall
git add .gitmodules modules/firewall
git commit -m 'Adding firewall submodule'
git push origin firewall
{% endhighlight %}

Note in the output that the Puppetmaster is checking out the
git submodule into the new environment. Go ahead and log into the
Puppetmaster, and look in your firewall environment, you should see all the
manifests and whatnot there.

Here's where I need to stamp a disclosure notice -- git submodules aren't all
milk and honey. There's some funky situations you can get yourself into if
you're not careful. Thankfully, there's not many of those situations you can't
get yourself out of. I highly recommend reading the [Pro Git chapter on submodules](http://progit.org/book/ch6-6.html) before doing anything with
them.

## Step 3: Implement Access Controls on Gitolite

This next step is entirely optional, but works out well for us. We have a
setup where I'm the only admin that can write to the master and testing
branches of our git repo, but any sysadmin can create their own branch, test
it, and delete it if need be. [Setting up gitolite](http://sitaramc.github.com/gitolite/) is far beyond the scope of
this post, but if you have about an hour of free time, you can have it setup
and running. However, below I've pasted the relevant snippet from
gitolite.conf that enforces those permissions.
{% highlight bash %}
repo    puppet                                                                                                          
  RW+     = JustinEllison
  R       = @SysAdmins Fisheye-puppet PuppetMaster
               - master testing = @SysAdmins
  RW+     = @SysAdmins
{% endhighlight %}

## Step 4: Profit!

To summarize it all, here's the workflow for an admin to add a new feature in
our Puppet setup:

 1.  Create a new VM which will be the testing ground for the new feature.
 1.  Create a local feature branch to implement the new feature in. The admin iterates over this branch (pushing the branch to origin) getting things working with his VM.
 1.  Once he's happy with the results on his VM, he's required to login to another sandbox VM, and run it against the same puppet branch with the '--noop' flag to ensure nothing unintended happens.
 1.  At this point, the positive and the negative have been tested, and he then asks me to merge the feature branch into master.
 1.  I then do a {% highlight bash %}git diff ...origin/newfeature{% endhighlight %} We go over any changes, and I merge it in.
 1.  From there, we follow our normal deployment method of tagging a release, and manually checking out the tag on the Puppetmaster.

While it's certainly not perfect, this workflow setup has allowed us to work
together as a team while still implementing some best practices. In
particular, the dynamic environments allow us to test our features extensively
before releasing them into production. This is especially important in a team
where the admins aren't Ruby programmers that can write puppet-rspec tests.

Before the integration of git submodules with the dynamic environment
workflow, we were manually merging external repos into our own setup, and it
was an absolute nightmare. Now, to update our repo to use a new version of
someone else's module, we just create a new feature branch, update the
submodule, test, and merge.

What workflows do you and your team use that make life with Puppet better?
Please share below.

