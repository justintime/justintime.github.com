---
title: Drupal on Heroku
permalink: /content/2011/09/20/drupal-heroku
layout: post
categories:
- Drupal
- Drupal Planet
comments: true
sharing: true
footer: true
---
[Heroku][1] has been around for awhile now, but has been primarily a rails host. Well, [until recently][2] anway. With the announcement of their Facebook integration, many others have noted that \*any\* PHP app can at least parse on Heroku's cedar stack. I'll be honest, it took me longer to get ruby+rails setup on my Macbook than it did to get a proof-of-concept installation of Drupal up and running. Here's what I did:

1.  Get ruby, rails, and the heroku gem installed and running. [This page][3] had me up and running pretty quickly on my Mac.
2.  Download and extract Drupal: 
    {% highlight console %}
curl http://ftp.drupal.org/files/projects/drupal-6.22.tar.gz | tar -xzvf -; cd drupal-6.22
{% endhighlight %}
3.  Initialize your git repo:
    {% highlight console %}
git init
{% endhighlight %}
4.  Here's what makes all this proof-of-concept only. Many of the features used in Drupal core's .htaccess file assume that the webhost has enabled the "AllowOverride All" option. Heroku doesn't allow this, it only allows a small subset of overrides. <strong>DOING THIS WILL MORE THAN LIKELY COMPROMISE THE SECURITY OF YOUR DRUPAL INSTALL. </strong>Open up .htaccess in your editor, and comment out any line that starts with these strings:
    
    *   Order
    *   Options
    *   DirectoryIndex
    *   php_value

5.  Add Drupal to git, and commit:
    {% highlight console %}
git add .; git commit -m 'initial commit'
{% endhighlight %}

6.  Create your heroku application. You'll need to have signed up for a free account on http://www.heroku.com and give the following command your login credentials:
    
    {% highlight console %}
heroku create --stack cedar
{% endhighlight %}

7.  Push your code up to heroku (note the URL it gives you back):
    {% highlight console %}
git push heroku master
{% endhighlight %}

8.  Now, we need to setup the Postgres instance:
    
    {% highlight console %}
heroku addons:add shared-database
{% endhighlight %}

9.  Let's display our Postgres credentials:
    
    {% highlight console %}
heroku config
{% endhighlight %}

10.  You can now hit your Drupal instance at the URL given to you by your last git push. Install as you normally would, selecting Postgres as your database, and filling in the user, password, database, and host given to you by 'heroku config'. Make sure to change the host from localhost under the "Advanced" fieldset.

  At this point, you can poke around your install, and start seeing what all else is broken :) 'heroku logs -t' is your friend. If you don't believe me, <a href="http://electric-mountain-6735.herokuapp.com/">here's a D7 instance</a>, and <a href="http://freezing-light-7795.herokuapp.com/">here's a D6 one</a>.

  Seriously, the .htaccess point is a deal-breaker. Unless someone with more time on their hands than I do can suggest a more secure configuration (or heroku allows Drupal to override all), there's some serious security ramifications to commenting out the lines in .htaccess.

  Drupal is definitely slow on the free plan for Heroku, but I mean, it's free; what did you expect? Drupal 6 seemed to work throughout, but I noticed when getting D7 up and running that I couldn't hit some "heavy" URL's like /admin/configure and /admin/reports/status. I could get into other sub-menus such as /admin/configure/development/performance. We all know D7 takes a fair amount of horsepower to run, and horses aren't free :). The whole point of heroku is being able to scale your app by dragging a slider in a web ui, and there's no reason to believe that Drupal wouldn't start running much faster given more resources from a non-free plan.

  The point of this blog post was to just jot down my notes and save someone else a little time in getting started -- hopefully the community can come up with some ideas so we have another awesome choice in Drupal hosting!

 [1]: http://www.heroku.com
 [2]: http://blog.heroku.com/archives/2011/9/15/facebook/
 [3]: http://pragmaticstudio.com/blog/2010/9/23/install-rails-ruby-mac

