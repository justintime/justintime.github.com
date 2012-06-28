---
title: Installing Synergy2 from Source on OpenSolaris 2009.06
permalink: /content/2009/06/16/installing-synergy2-source-opensolaris-200906
layout: post
categories:
- OpenSolaris
- sysadmin
comments: true
sharing: true
footer: true
---
At work, I can't live without [Synergy](http://synergy2.sourceforge.net), the
program that allows you to share one keyboard and mouse with multiple systems
across multiple systems. Here's a quick post on how to install it in
OpenSolaris:

    
    
    pfexec pkg install SUNWgcc SUNWxwinc
    tar -xzvf synergy-1.3.1.tar.gz
    cd synergy-1.3.1
    ./configure
    make
    pfexec make install
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/synergys.desktop <<EOD
    
    [Desktop Entry]
    Type=Application
    Name=Synergy2 Server
    Exec=/usr/local/bin/synergys
    Icon=system-run
    Comment=Synergy2 Display Server
    X-GNOME-Autostart-enabled=false
    EOD
    

To enable startup at login, create the appropriate /etc/synergy.conf and
navigate to System->Preferences->Sessions, and place a check next to "Synergy2
Server".

