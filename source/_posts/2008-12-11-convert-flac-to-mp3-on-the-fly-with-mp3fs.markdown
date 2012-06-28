---
title: Convert FLAC to MP3 on the fly with MP3FS
permalink: /content/2008/12/11/convert-flac-mp3-fly-mp3fs
layout: post
categories:
- Linux
- sysadmin
comments: true
sharing: true
footer: true
---
I refuse to do DRM. If there's an album I want, I buy the CD. The first thing
I do after opening a new disc is to rip the disc to
[FLAC](http://flac.sourceforge.net/). The second thing I do is to copy the
disc so that the loader in my car doesn't do permanent damage to the master
copy. The third thing I do is to put the album on my MP3 player. Now, my
player runs [Rockbox](http://www.rockbox.org/), so I **can** play FLAC files,
but they eat up too much space. However, I hate to keep both an MP3 and a FLAC
laying around when I only need access to the MP3 once. Enter
[MP3FS](http://mp3fs.sourceforge.net/) - a fuse filesystem that converts FLAC
to MP3 on the fly.  It's a beautiful thing. I keep all my FLAC files on my
NAS, which is exported via NFS to all my systems. On my laptop, I have my FLAC
export mounted at /mnt/FLAC. I have MP3FS configured to convert /mnt/FLAC, and
it's mounted at ~/MP3. I plug in my MP3 player, and browse all my MP3's on
~/MP3 (they don't really exist). When I copy the MP3 from ~/MP3 to my MP3
player, MP3FS transcodes the FLAC files to MP3 on the fly. It even adds ID3
tags to the MP3! Here's how you can setup the same thing.

### Download and install MP3FS

Most distro's don't include MP3FS as a package, but pretty much any modern
distro supplies the prerequisite packages. On Ubuntu, run the following to
satisfy the prerequisites: {% highlight bash %} sudo apt-get install build-
essential fuse fuse-utils liblame-dev libflac-dev libfuse-dev libid3tag0-dev
{% endhighlight %} Next download MP3FS from http://mp3fs.sourceforge.net/,
extract the file, change into the new directory, and do the normal GNU thing:
{% highlight bash %} tar -xzvf mp3fs-0.12.tar.gz cd mp3fs-0.12 ./configure
make sudo make install {% endhighlight %}

### Test

Before we mount this thing via fstab, we'll get it working first. First,
create the mountpoint - in my example, it's ~/MP3. {% highlight bash %} mkdir
~/MP3 {% endhighlight %} Now, if your FLAC files are at /mnt/FLAC, and you
want 192K MP3's, run this command: {% highlight bash %} mp3fs /mnt/FLAC/,192
~/MP3/ -o ro {% endhighlight %} Now, browse the new MP3 directory using
Nautilus, ls, or whatever. Cool 'eh? Note the file isn't actually transcoded
until you try to access the contents of the file. Just doing directory
listings doesn't transcode. Go ahead, pick an MP3 to play in your favorite
player. You'll likely find that transcoding happens pretty quickly.

### Set it and forget it

Now, we can setup this mount in /etc/fstab and configure it to mount on
bootup, so it's there waiting for you all the time. Unmount the directory, add
the entry to fstab, and mount it. {% highlight bash %} sudo umount
/home/justintime/MP3/ sudo sh -c "umount /home/justintime/MP3; echo
'mp3fs#/mnt/FLAC,192 /home/justintime/MP3 fuse ro 0 0' >> /etc/fstab" mount
~/MP3 ls ~/MP3 {% endhighlight %} At this point, you are ready to go. If you
don't like to brag about your uptime, go ahead and reboot and make sure the
mountpoint is there. Otherwise, trust me ;-) Hope you enjoy MP3FS as much as I
do!

