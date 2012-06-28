---
title: SMF Manifests for Endeca IAP 6.x
permalink: /content/2009/05/12/smf-manifests-endeca-iap-6x
layout: post
categories:
- sysadmin
comments: true
sharing: true
footer: true
---
In doing some recent upgrades, we migrated our Endeca installation to Solaris
10. I got the itch to write some SMF manifests, and here's my completed XML
and method files.  First, download
[EndecaSMF.tar.gz](/sites/sysadminsjourney.com/files/code/EndecaSMF.tar.gz),
and extract it somewhere. Change to the ./endeca/ directory. Next you need to
edit a few things in the two xml files. If you're running the daemons under a
user other than 'endeca', edit the following lines updating it with the user
you created. Note that you have to edit both the start and the stop methods
for a total of eight changes (4 in each XML file):

    
    
    <method_credential user="endeca"/>
    <envvar name="USER" value="endeca"/>
    

Next, edit the path to your Endeca installation. The XML files come
preconfigured with '/apps/endeca'. This is the value to '--target=' you used
in the setup shell scripts. If you used something other than '/apps/endeca',
then do a search and replace through both XML files. Now, run the following as
root:

    
    
    cp svc-endeca* /lib/svc/method/
    chown root:bin /lib/svc/method/svc-endeca*
    chmod 755 /lib/svc/method/svc-endeca*
    svccfg -v import endeca-eac.xml 
    svccfg -v import endeca-workbench.xml
    

If your Endeca services are running, stop them now. To start the Endeca
Application Controller (HTTP Service), run:

    
    svcadm enable endeca/application-controller

If you want the Workbench server to start on every boot, run

    
    svcadm enable endeca/workbench

That's it!

