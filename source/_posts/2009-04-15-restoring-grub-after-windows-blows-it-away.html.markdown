---
title: Restoring GRUB after Windows Blows It Away
permalink: /content/2009/04/15/restoring-grub-after-windows-blows-it-away
layout: post
categories:
- Linux
- sysadmin
comments: true
sharing: true
footer: true
---
<p>If you make the mistake of installing Windows after Linux, it will rewrite your MBR, killing GRUB. Some might argue simply installing Windows on your computer is a mistake, but let's fix the MBR and worry about that later. ;-) <!--break--> In my case, my boot partition is on the first partition on the first hard drive. I use Ubuntu in my examples, but any LiveCD should do. First, boot the LiveCD - no need to boot into a GUI. Open a terminal, and become root. In Ubuntu,</p>
<pre>sudo -s</pre>
<p>works nicely. If you can't remember which partition is your boot partition, try</p>
<pre>fdisk -l /dev/sda</pre>
<p>OR</p>
<pre>fdisk -l /dev/hda</pre>
<p>might help jog your memory. Next, we just need to reinstall the bootloader code to the MBR. In my examples, hd0,0 is the first partition on the first disk.</p>
<pre>root@ubuntu:~# grub
Probing devices to guess BIOS drives. This may take a long time.
       [ Minimal BASH-like line editing is supported.   For
         the   first   word,  TAB  lists  possible  command
         completions.  Anywhere else TAB lists the possible
         completions of a device/filename. ]

grub&gt; root (hd0,0)

grub&gt; setup (hd0)
 Checking if "/boot/grub/stage1" exists... no
 Checking if "/grub/stage1" exists... yes
 Checking if "/grub/stage2" exists... yes
 Checking if "/grub/e2fs_stage1_5" exists... yes
 Running "embed /grub/e2fs_stage1_5 (hd0)"...  16 sectors are embedded.
succeeded
 Running "install /grub/stage1 (hd0) (hd0)1+16 p (hd0,0)/grub/stage2 /grub/menu
.lst"... succeeded
Done.

grub&gt; quit
</pre>
<p>That's it - reboot, and you'll be greeted by GRUB again!</p>

