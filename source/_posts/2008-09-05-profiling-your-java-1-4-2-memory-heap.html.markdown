---
title: Profiling your Java 1.4.2 memory heap
permalink: /content/2008/09/05/profiling-your-java-142-memory-heap
layout: post
categories:
- Java
- Sun
- sysadmin
comments: true
sharing: true
footer: true
---
New Java 6 devs and admins get all the fun.  New toys, better performance, more auto-tuning -- yet you get stuck supporting a legacy java app that you can't upgrade past 1.4.2.  Well, provided you have a more recent 1.4.2 JDK, you can use <a href="http://java.sun.com/javase/6/docs/technotes/tools/share/jhat.html">jhat</a> too!
<!--break-->
The key is to have your app do a heap dump when sending it the QUIT signal.  Append this option to your java options on startup of your application:
<pre>
-XX:+HeapDumpOnCtrlBreak
</pre>

Now, start your app, and let it run for awhile.  There is no overhead to running with this option, however do note that your app will freeze for awhile when you send it the magic signal as it creates a heap dump.  Once your app has ran for awhile, and your caches are loaded or your leak has leaked, send the java process the QUIT signal.  On Windows, this is done by doing a CTRL+C at the console.  On Linux & Solaris, you can send the java process the QUIT signal either by doing a CTRL+C, or finding the PID of the process and sending the signal to it.  Assume a PID of 12345:
<pre>
kill -3 12345
</pre>

Upon sending the process the signal, you'll see something similar to this get printed to stdout:
<pre>
Dumping heap to java_pid12345.hprof.1220646896001 ...

Heap dump file created [533206498 bytes in 22.836 secs]

</pre>
Here you see it took my laptop about 22 seconds to dump a heap of a little over 512MB.

So now, you have the heap.  You either need to have Java 6 available, or transfer the heap dump over to a computer that does.  Also note you need quite a bit of RAM to run JHAT.  Since JHAT loads the other VM's heap, you need the size of your heap dump plus some working room - I recommend heapsize + 512MB.  Now, if I have a 512MB heap dump, and give it another 512MB, here's what my JHAT command line looks like:
<pre>
$JAVA6_HOME/bin/jhat -J-mx1g java_pid12345.hprof.1220646896001
</pre>

You'll see output like the following (this takes a while to load):
<pre>
Reading from java_pid12345.hprof.1220646896001...

Dump file created Fri Sep 05 15:34:56 CDT 2008

Snapshot read, resolving...

Resolving 12662545 objects...

Chasing references, expect 2532 dots....

Eliminating duplicate references............

Snapshot resolved.

Started HTTP server on port 7000

Server is ready.

</pre>

Now, open up a web browser to http://localhost:7000/, and find that memory leak!!!

