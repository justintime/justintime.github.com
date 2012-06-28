---
title: "Not So Typical Jumpstart: Part Two"
permalink: /content/2009/09/21/not-so-typical-jumpstart-part-two
layout: post
categories:
- Solaris
- Sun
- Jumpstart
- sysadmin
comments: true
sharing: true
footer: true
---
![](/assets/images/solaris.gif)In [part one of the series](/content/2009/09/18
/not-so-typical-jumpstart-part-one), we setup the ISC DHCP server. Now it's
time to set up our install and config servers -- both of which will reside on
the same box in this case. Solaris Jumpstart uses standard protocols, namely
TFTP and NFS to provide these services. In this post, we'll just be setting up
the framework for the real customizations that will come in parts three and
four.

  
  

## Step 1: Setup the Install Server

In our example, we'll be assuming that our install and config directories will
be setup under /export/home/jumpstart/. So, pop the Solaris 10 DVD into the
drive of your server, and issue the following commands as root:

    
    
    mkdir -p /export/home/jumpstart/install/s10u7s
    cd /cdrom/cdrom0/Solaris_10/Tools
    ./setup_install_server /export/home/jumpstart/install/s10u7s
    

Once that's done (it will take awhile), we need to make sure the NFS server is
running, and share our install location as a read-only mountpoint:

    
    
    svcadm enable nfs/server
    echo 'share -F nfs -o ro,anon=0 -d "install server directory" /export/home/jumpstart/install/s10u7s' >> /etc/dfs/dfstab
    shareall
    

Now, it's time to create a boot file and make it available via TFTP download
for our client:

    
    
    cd /export/home/jumpstart/install/s10u7s/Solaris_10/Tools
    ./add_install_client -d SUNW,Sun-Fire-T1000 sun4v
    svcadm enable tftp/udp6
    

**Note that the add_install_client command is likely not a command you can cut and paste!** To determine the two arguments to add_install_client, you need to run some uname's if you're deploying to Sparc. To get the platform name, run 'uname -i', and replace the 'SUNW,Sun-Fire-T1000' string above with the response. Then, run 'uname -m', and replace sun4v with the response (which will most likely be sun4u). If you're running x86, you'll run this command:
    
    
    ./add_install_client -d SUNW.i86pc i86pc
    

At this point, you can do **interactive** network installations of the Solaris
OS to your client. In fact, I recommend that you go ahead and try booting from
the network and make sure that everything's setup to this point. On a Sparc
box, from OBP, type 'boot net:dhcp - install'. If you're on x86, boot via PXE.
If you don't have a working network installation at this point, stop here and
get it working before you move on to setting up the config server.

## Step 2: Setup the Config Server

We could do an interactive network install, which is helpful for systems that
may not have a CD/DVD drive, but really -- where's the fun in that? We're
striving for automation here! That's where the config server comes in. The
config server provides a sysidcfg file to the system which tells it things
like what IP's belong on what interfaces, what is my hostname, etc. The
sysidcfg file tells the system settings that will be unique to that system.
The other function of the config server is to provide the jumpstart profile
and all the scripts that the profile refers to. The jumpstart profile tells
the machine specifics about the installation procedure -- what packages to
install, what locale to use, etc. Let's setup our directories first:

    
    
    for d in scripts sshkeys sysids jumpstart_sample; do
    mkdir -p /export/home/jumpstart/configs/$d
    done
    echo 'share -F nfs -o ro,anon=0 /export/home/jumpstart/configs' >> /etc/dfs/dfstab
    shareall
    

We've created our configs directory, which is the root of the config server
setup. We created a few subdirectories -- scripts is where we'll store our
add-on scripts, sshkeys is where we'll keep our ssh public keys, sysids is
where the system-specific sysidcfg files will be stored, and jumpstart_sample
is where we will keep our jumpstart_sample profiles. These files are handy to
have around for reference. Let's copy those over now:

    
    
    cp /export/home/jumpstart/install/s10u7s/Solaris_10/Misc/jumpstart_sample/* /export/home/jumpstart/configs/jumpstart_sample
    

Now, we're ready to create our jumpstart rules file. Run the following:

    
    
    cd /export/home/jumpstart/configs/
    ln -s  /export/home/jumpstart/configs/check  /export/home/jumpstart/configs/jumpstart_sample/check
    echo "hostname web1    delete_raidctl_vols    webserver      webserver_finish.sh" >> rules
    touch delete_raidctl_vols webserver_finish.sh
    chmod 755 delete_raidctl_vols webserver_finish.sh
    

We added one rule to the rules file. There is a well-commented rules file in
the jumpstart_sample directory that you can pour over to get all the gory
details. In our rules file, we're essentially saying this:

  * **hostname web1**: Any client that has a hostname equal to 'web1' will use this rule. Remember in part one when I told you to jot down the hostname we used in dhcpd.conf? That hostname and this one have to match exactly.
  * **delete_raidctl_vols**: This is the begin script. It is ran before the actual installation occurs. If you don't need a begin script, you can simply use a '-' here. Right now, delete_raidctl_vols is empty, but in part four we'll populate it with a script that deletes any "hardware" raid volumes so that we can use ZFS software mirroring in our installation.
  * **webserver**: This is the actual jumpstart profile file. We'll go over this in part three.
  * **webserver_finish**: This is the finish script. This script provides the sysadmin with an interface to do anything he wants via a shell script after installation, but before reboot. All the power of jumpstart is in this one file. We'll cover that in part four. Just as with the begin script, if you don't need a finish script, just use a dash here.

At this point, we still don't have a full custom jumpstart setup yet. Before
it's ready to be tested, we need to add the content to our 'webserver'
jumpstart profile file, and run the 'check' command on it to generate the
rules.ok file. We'll do this in part three. Part four will cover some examples
of things you can do in the begin and finish scripts - stay tuned!

