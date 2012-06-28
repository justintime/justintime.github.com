---
title: Teaching Java How to Commit Suicide
permalink: /content/2010/01/29/teaching-java-how-commit-suicide
layout: post
categories:
- Java
- sysadmin
comments: true
sharing: true
footer: true
---
At $work, we have a lot of java processes that are ran via cron and other
wrappers that do some pretty critical tasks. The apps have been written so
that the whole thing is wrapped in a try/catch that will call system.exit(1)
should something not go right. Our wrapper scripts watch for a non-zero exit
code, and alert Nagios if something went wrong. This works great except for
when a VM encounters an outOfMemory exception (OOM). The Java VM attempts to
continue on, but if the main thread hits this exception, the entire VM will
exit. However, the application code that exits with a status of 1 never gets
called, so the application ends up dying with a status of 0. Well, Sun (Oracle
now I guess) gave us a new option in Java 6 that was backported to 1.4.2_12
and up that allows us to tell Java to run a shell command when it encounters
an OOM exception. By adding the option

    
    -XX:OnOutOfMemoryError="kill -9 %p"

to our Java command line, the VM will execute a shell that calls the kill
command, with an argument of the PID of the VM. The -9 option to kill will
cause the VM to exit with a non-zero status, so that our wrappers will pick up
the error and alert the right people. Note: this feature was never backported
to Java5 - sorry!

