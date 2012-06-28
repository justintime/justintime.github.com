---
title: Breaking Bad Habits - Don't Use seq in Your Shell Scripts
permalink: /content/2009/05/18/breaking-bad-habits-dont-use-seq-your-shell-scripts
layout: post
categories:
- Linux
- Solaris
- sysadmin
comments: true
sharing: true
footer: true
---
Like most, I learned shell scripting by following examples. Well,
unfortunately, most of the samples I learned from used the 'seq' binary to
execute a simple for loop like so:

    
    
    for i in `seq 1 10`; do
    echo $i
    done
    

I discovered why this is bad today - not all Unixes (Solaris and Darwin
included) come with it. Not to mention we're forking a process where we don't
need it. On bash, use the built-in brace expansion instead:

    
    
    for i in {1..10}; do
    echo $i
    done
    

For ksh and other shells, instead of using a for, use a while loop with an
incrementing counter if the integers are too numerous to list in the loop
header itself.

