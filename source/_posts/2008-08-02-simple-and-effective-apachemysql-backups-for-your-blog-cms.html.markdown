---
title: Simple and Effective Apache+MySQL Backups for your Blog/CMS
permalink: /content/2008/08/02/simple-effective-apachemysql-backups-your-blogcms
layout: post
categories:
- Apache
- Linux
- MySQL
- sysadmin
comments: true
sharing: true
footer: true
---
As part of setting up my new <a title="Linode" href="http://www.linode.com/?r=c4f79463ba583ec1f15e3307190bda4bda9d65df">Linode</a> host, I needed a quick, easy, and maintanable way to create backups of my LAMP webapps.  Follow the jump to see how I set up my backup strategy.

<!--break-->
<strong>DISCLAIMER:</strong> I make no guarantees to the effectiveness of this script.  It works for me, and it should work for you, but it is up to you to test it!  Also note, you need to have SSH access and root privileges to your server.

I needed a quick way to get a backup strategy in place that would create a daily snapshot of my <a href="http://www.wordpress.org">Wordpress</a> and <a href="http://www.drupal.org">Drupal</a> code and MySQL databases.  Basically, I keep a 7 day rotation of each webapp's code and MySQL, so that if I do something to break my app, I can at least restore it back to the previous day's state.  Also, before I install a new plugin or hack on a theme, I can create a snapshot by firing off one script.

I had an advantage since I was starting things from scratch - I could name things consistently.  One of the assumptions that is made is that the directory name of the Apache DocumentRoot of your webapp is the same as the name of your MySQL database.  Obviously, you can't go changing your MySQL db names around very easily, but you can use symbolic links to make your document root's have the same name as your DB.

First, let's setup our hypothetical webapp, which will be a wordpress blog.  We'll call it MySite_wp.  For the purpose of this example, we have a directory /apps/MySite_wp which is the document root for the Wordpress installation.  There is a directory named /apps/snapshots/ where we will store our daily snapshots of our document root, and a directory named /apps/mysqlbackups/ where we will store our MySQL database backups.  Finally, our custom scripts will be stored in /apps/scripts.

<h3>Step One: Backup MySQL</h3>
First, let's setup our script that does our MySQL backup.  This is a shell script that I wrote because the scripts offered by <a href="http://www.zmanda.org">Zmanda</a> were a little overkill for what I wanted.  I therefore came up with my own shell script that will backup any db you specify on the command line.  Let's create this script, and name it /apps/scripts/backupMySQL.sh:
<pre>#!/bin/bash

#set -x

USER=root
PASS=mysqlrootpassword
DEST=/apps/mysqlbackups/archives
MYSQLBIN=/usr/bin
LOGROTATE=/usr/sbin/logrotate

cmp_versions() {
   [ "$1" == "$2" ] &amp;&amp; return 10

   ver1front=`echo $1 | cut -d "." -f -1`
   ver1back=`echo $1 | cut -d "." -f 2-`
   ver2front=`echo $2 | cut -d "." -f -1`
   ver2back=`echo $2 | cut -d "." -f 2-`

   if [ "$ver1front" != "$1" ] || [ "$ver2front" != "$2" ]; then
      [ "$ver1front" -gt "$ver2front" ] &amp;&amp; return 11
      [ "$ver1front" -lt "$ver2front" ] &amp;&amp; return 9

      [ "$ver1front" == "$1" ] || [ -z "$ver1back" ] &amp;&amp; ver1back=0
      [ "$ver2front" == "$2" ] || [ -z "$ver2back" ] &amp;&amp; ver2back=0
      cmp_versions "$ver1back" "$ver2back"
      return $?
   else
      [ "$1" -gt "$2" ] &amp;&amp; return 11 || return 9
   fi
}

get_dump_opts() {
  cmp_versions "$VERSION" "4.1.0"
  RV=$?
  if [ $RV -eq 9 ]; then
    MYDUMP="$MYDUMP --skip-lock-tables --all"
  else
    cmp_versions "$VERSION" "4.1.2"
    RV=$?
    if [ $RV -eq 11 ]; then
      MYDUMP="$MYDUMP --default-character-set=utf8 --create-options"
    else
      MYDUMP="$MYDUMP --default-character-set=utf8 --all"
    fi
  fi
}

SCRIPTDIR=`dirname $0`
if [[ "$SCRIPTDIR" == "." || -z "$SCRIPTDIR" ]]; then
  SCRIPTDIR=$PWD
fi
LOGROTATECFG="$SCRIPTDIR/mysqlbackup.logrotate"
MYDUMP="$MYSQLBIN/mysqldump --user=$USER --password=$PASS --opt --extended-insert \
 --single-transaction"
MYSQL=$MYSQLBIN/mysql

VERSION=`$MYSQLBIN/mysqladmin --user $USER --password=$PASS version | \
 grep "Server version" | awk '{ print $3; }'`

if [ -z "$1" ]; then
  echo "I need a database to back up!!!"
  exit 1
fi

get_dump_opts

while [ ! -z "$1" ]; do
   DB=$1
   touch $DEST/$DB.sql
   chmod 400 $DEST/$DB.sql
   #Version specific dump
   $MYDUMP $DB &gt; $DEST/$DB.sql
   if [ $? -ne 0 ]; then
     echo "MySQL Dump of $DB had an error!"
     exit 1
   fi
   shift
done

$MYSQL --user=$USER --password=$PASS \
-e "PURGE MASTER LOGS BEFORE DATE_SUB( NOW( ), INTERVAL 31 DAY);"

if [ $? -ne 0 ]; then
  echo "MySQL log purge had an error!"
  exit 1
fi

if [ ! -e $LOGROTATECFG ]; then
  cat &gt; $LOGROTATECFG &lt;&lt;EOF
# Rotate MySQL backups
$DEST/*.sql {
   notifempty
   daily
   rotate 7
   compress
}
EOF
fi

if [ ! -x $LOGROTATE ]; then
  echo "Logrotate not executable, skipping rotation"
  exit 1
else
  $LOGROTATE -f $LOGROTATECFG
  if [ $? -ne 0 ]; then
    echo "Logrotate had an error!"
    exit 1
  fi
fi
</pre>

Now, make sure you edit the variables at the top of this script to your installation.  Since this script contains the root password to your MySQL install, run
<pre>
chmod 700 /apps/scripts/backupMySQL.sh
</pre>
to make it so only the root user can view the password.

Now, let's test the script.  Jump out to a command prompt, and run '/apps/scripts/backupMySQL.sh MySite_wp'.  Once that's done, look in the /apps/mysqlbackups/archives directory, and you should see a gzipped sql file sitting there.  Step one, done!

<h3>Step Two: Backup the Document Root</h3>
Now, we need to setup the script that will backup our actual files (usually php files).  Now, most of us have very little data that actually changes from day to day in our PHP files.  Most of the dynamic data is stored in the database.  So, to prevent wasting a bunch of space backing up the exact same file multiple times, we will leverage the hard linking feature of rsync.  Please note that this script is not my own, the majority of the code comes from <a href="http://www.mikerubel.org/computers/rsync_snapshots/">Mike Rubel's site</a>.  Now, create the file /apps/scripts/rsyncBackup.sh, and put this code in it:

<pre>
#!/bin/bash

unset PATH

KEEP=7

# ------------- system commands used by this script --------------------
ID=/usr/bin/id
ECHO=/bin/echo

RM=/bin/rm
MV=/bin/mv
CP=/bin/cp
TOUCH=/bin/touch
MKDIR=/bin/mkdir
RSYNC=/usr/bin/rsync
SEQ=/usr/bin/seq


# ------------- file locations -----------------------------------------

SOURCE_DIR=$1
SNAPSHOT_DIR=$2

# ------------- the script itself --------------------------------------

# make sure we're running as root
if (( `$ID -u` != 0 )); then { $ECHO "Sorry, must be root.  Exiting..."; exit; } fi

#Check our args
if [ -z "$SOURCE_DIR" ]; then
  $ECHO "Please pass a source directory as argument 1!";
  exit 1;
fi

if [ -z "$SNAPSHOT_DIR" ]; then
  $ECHO "Please pass a source directory as argument 1!";
  exit 1;
fi

#Check our DIR's
if [ ! -d $SOURCE_DIR ]; then
  $ECHO "$SOURCE_DIR is not a directory!";
  exit 1;
fi

if [ ! -d $SNAPSHOT_DIR/ ]; then
  $MKDIR -p $SNAPSHOT_DIR
fi

if (( $? )); then
{
	$ECHO "snapshot: could not create directory $SNAPSHOT_DIR";
	exit;
}
fi;

#Rotation:
#Account for backup.0
let KEEP=$KEEP-1

for i in `$SEQ $KEEP -1 0`; do
  # Delete the last rotation
  if [ $i == $KEEP ]; then
    $RM -rf $SNAPSHOT_DIR/daily.$i
  else
    # shift the middle snapshots(s) back by one, if they exist
    let NEXT=$i+1
    if [ -d $SNAPSHOT_DIR/daily.$i ] ; then			\
      $MV $SNAPSHOT_DIR/daily.$i $SNAPSHOT_DIR/daily.$NEXT
    fi;
  fi
done

#rsync
CMD="$RSYNC -a --delete --delete-excluded "
CMD="$CMD --link-dest=$SNAPSHOT_DIR/daily.1 "
CMD="$CMD $SOURCE_DIR/* $SNAPSHOT_DIR/daily.0"

if [ ! -d $SNAPSHOT_DIR/daily.0 ]; then
  $MKDIR -p $SNAPSHOT_DIR/daily.0
fi

eval $CMD
</pre>
Now, do a 'chmod 755 /apps/scripts/rsyncBackup.sh' and let's test it out.  Run '/apps/scripts/rsyncBackup.sh MySite_wp'.  Once completed, have a look in /apps/snapshots/MySite_wp/.  You will have a directory named daily.0 that will contain a snapshot of your application.  If you run the same command again, the current daily.0 contents will be moved over to daily.1, and a new snapshot will be stored in daily.0.  This will complete until you have 7 such daily directories, at which point the oldest will be deleted before the newest is created.  By using hard links, only if a file changes will it actually consume space on your hard drive.  Step two, complete!

<h3>Step Three: Tie It All Together</h3>
Now, for the easy part.  Let's tell cron to perform a backup each night.  Create the file /etc/cron.daily/backupWebApps.sh, and put this text in there:
<pre>
#!/bin/bash

WEBAPPS=( MySite_wp )

for WEBAPP in ${WEBAPPS[@]}; do
    /apps/scripts/backupMySQL.sh $WEBAPP
    /apps/scripts/rsyncBackup.sh /apps/$WEBAPP/ /apps/snapshots/$WEBAPP/
done
</pre>

Now, run 'chmod 755 /etc/cron.daily/backupWebApps.sh', and you will have a backup of your MySite_wp applicaton!  What's best, is let's say you add a Drupal application, you name your MySQL database MySite_Drupal, and your document root is a /apps/MySite_Drupal.  All you need to do is change line 3 of backupWebApps.sh to look like this:
<pre>
WEBAPPS=( MySite_wp MySite_Drupal )
</pre>
and you will get a backup of your Drupal install the following night too!
<h3>Restoration</h3>
Heaven forbid, you've made a critical mistake, installed a bad plugin, or something else that's horribly broken your MySite_wp install.  No fear!  Here's how to restore it.
<pre>
mkdir /apps/MySite_wp-broken && mv /apps/MySite_wp/* /apps/MySite_wp-broken/
rsync -avz /apps/snapshots/MySite_wp/daily.0/* /apps/MySite_wp/
gzip -dc /apps/mysqlbackups/archives/MySite_wp.sql.1.gz > /tmp/mysite.sql
mysql -u root -p MySite_wp < /tmp/mysite.sql
rm /tmp/mysite.sql
</pre>
and viola!  Your site is back as it was at the time of the last backup.

<h3>Offsite Backup</h3>
To ensure safety, you should then backup your /apps/snapshots and your /apps/mysqlbackups directories to someplace offsite.  I recommend rsync for this as well.  Stay tuned for a post on how to do this!


