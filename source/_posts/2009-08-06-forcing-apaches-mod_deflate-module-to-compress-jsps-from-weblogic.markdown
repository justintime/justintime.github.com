---
title: Forcing Apache's mod_deflate module to compress JSP's from Weblogic
permalink: /content/2009/08/06/forcing-apaches-moddeflate-module-compress-jsps-weblogic
layout: post
categories:
- Apache
- sysadmin
comments: true
sharing: true
footer: true
---
This is one of those "note for myself, and maybe it will help someone else"
posts. When you use Apache and mod_weblogic as a frontend to a WebLogic
application server, you will likely want to compress your output. It makes
sense to put the load of compression on the webservers, since the application
servers are busy doing other things.

With all the buggy browsers out there, blindly gzipping everything can cause a
lot of issues, so most people end up with a stanza such as this in their
config:

    
    
    AddOutputFilterByType DEFLATE text/html text/css application/x-javascript text/plain
    #Instead of blacklist, we use a whitelist:  
    BrowserMatch ^MSIE [6-9] gzip
    

Well, unfortunately, this will not catch your JSP files. I think it has to do
with the way that Weblogic is passing through the MIME type as well as the
order of filters in the chain. No matter the exact cause, here is the fix:

    
    
    <LocationMatch ".*\.jsp$">
         ForceType text/html
    </LocationMatch>

This simply forces Apache to assume that all files that end in .jsp are of
type text/html. This happens before the mod_deflate filter is applied, and
therefore your JSP's will be gzipped!

