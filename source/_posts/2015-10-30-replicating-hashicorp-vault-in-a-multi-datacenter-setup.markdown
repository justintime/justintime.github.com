---
layout: post
title: "Replicating Hashicorp Vault in a Multi-DataCenter Setup"
date: 2015-10-30 12:45:58 -0500
comments: true
categories: 
---

This post will go over how to use [HashiCorp's Vault](https://vaultproject.io) with [HashiCorp's Consul](http://consul.io) as a backend
in a multiple datacenter arrangement.  This post is a cleaned up summary of what happened in [this Github issue](https://github.com/hashicorp/vault/issues/674).

Very, very special thanks go out to Jeff Mitchell with Hashicorp.  Without his help, I never would have been able to accomplish what I had originally set out to do.

# The Use Case
 - You have more than one physical datacenter.
 - You need to have a HA Vault setup in each datacenter
 - You don't want to lose functionality in any datacenter if the connection between them is severed.
 - You want to have all Vault auth tokens, secrets, and policies available in all datacenters.
 - You have one *read+write* "source" datacenter where you will be creating Vault tokens, policies, and secrets.
 - You have one or more *read-only* "destination" datacenters where Vault data will be replicated to, but never modified.  We'll use one in our example, but I use 3 and see no real scalability problems with anything less than 20.


# Context and Assumptions

Throughout this post, I'll refer to two datacenters: Datacenter A and Datacenter B.  Datacenter A will represent our "source" datacenter, and B will
represent our "destination" datacenter.  For brevity, we'll assume that these are both physically 
separate datacenters as well as separate Consul datacenters.  We'll also assume that there is VPN or an alternative connectivity solution in place.  

Lastly, this post assumes that you're familiar with working with both Vault and Consul.  Please read all the docs on both products([Consul](https://www.consul.io/docs/index.html),[Vault](https://vaultproject.io/docs)).  Hashicorp has 
went to great pains to produce some really good documentation, please don't let their efforts go to waste.

<div class="alert warning-alert">Vault's authors do not support using Vault in this manner.  While it certainly works very well for me, it may not work for you.  We will be disabling 
Vault's internal read cache as part of this exercise, and doing so will have a significant impact on Vault's performance.  In my scenario, performance 
is not a concern so long as the request comes back within a second, and Vault still met that requirement. </div>

# The Problem

While Consul itself supports multiple datacenters, there's some problems in the way that it handles things them that cause problems when 
you're putting Vault in front of it.

1. Your first thought might be to use multiple datacenters in Consul, and point all of your Vaults at the same datacenter.  This technically 
will work, but if Datacenter A loses connectivity to Datacenter B, Vault will not function in Datacenter B until connectivity is restored.
1. You might next come upon [consul-replicate](https://github.com/hashicorp/consul-replicate).  This is the right tool for the job, but the devil's in
the details.  First, you can't replicate the entire k/v store -- you have to exclude some things from being replicated.
1. If you get all that figured out, you'll quickly discover that even though everything seems to be working fine via consul-replicate, your changes
don't show up in Datacenter B until after you restart and unseal Vault.

# The Solution

The solution is to setup Vault to point at a local Consul cluster.  We'll use consul-replicate to replicate specific data from Consul in the source datacenter (A) to
the destinatation datacenter (B)

For performance, Vault makes use of a read cache.  Since only one Vault instance is actually marked as active and that active instance is the only one that sees _any_ operations,
it caches every read indefinitely in process memory.  Since we're using consul-replicate to essentially change the data underneath Vault without using Vault API's, you need 
to disable that read cache.  

## Step 1: Setup Consul clusters in each datacenter

By following the [awesome documentation on Consul](https://www.consul.io/docs/index.html), you'll have a Consul cluster up and running in each datacenter in no time.
*NOTE:* You need to set your ```encrypt``` and ```acl_master_token``` to the same values in order to make multiple datacenters work in Consul.

## Step 2: Make the Consul clusters aware of the nodes in the other datacenters

Use the ```consul join -wan <<hostname of Consul host in other datacenter>>``` command to establish communications between each Consul cluster.

## Step 3: Install HA Vault in each datacenter

Use the [awesome documentation on Vault](https://vaultproject.io/docs) to build HA Vault clusters in each datacenter.  Point each Vault instance at it's local Consul datacenter.
Vault instance 1 in Datacenter A would have a ```vault.hcl``` file like this:
``` json
backend "consul" {
  address = "localhost:8500"
  advertise_addr = "https://vault1.datacenterA.com:8200"
  token = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  path = "vault"
}

listener "tcp" {
  address = "vault1.datacenterA.com:8200"
  tls_cert_file = "/etc/pki/tls/certs/wildcard.datacenterA.com.crt"
  tls_key_file = "/etc/pki/tls/private/datacenterA.com.key"
}
```

Vault instance 1 in Datacenter B would have a ```vault.hcl``` like this:
``` json
disable_cache = true
backend "consul" {
  address = "localhost:8500"
  advertise_addr = "https://vault1.datacenterB.com:8200"
  token = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  path = "vault"
}

listener "tcp" {
  address = "vault1.datacenterB.com:8200"
  tls_cert_file = "/etc/pki/tls/certs/wildcard.datacenterB.com.crt"
  tls_key_file = "/etc/pki/tls/private/datacenterB.com.key"
}
```
The big thing to notice here is that we turn off the read cache in our destination datacenter.

<div class="alert alert-warning">IMPORTANT: the disable_cache functionality is new and is only available in Vault 0.4.0 and up.  Vault 0.4.0 wasn't available at the time of this writing.  If you need this functionality and 0.4.0 isn't available yet, you need to build from source.</div>

## Step 4: Set Up Consul-Replicate

At this point, you will have all of the endpoints set up in the proper manner.  The last piece to this puzzle is to replicate the data from the source to the destination(s) via [consul-replicate](https://github.com/hashicorp/consul-replicate).  Consul-replicate is a very specific tool written for a very specific purpose, and I'll admit that the docs for it aren't up to par with the other tools in Hashicorp's suite.  Rest assured, it works perfectly once you've got it set up.

Consul-replicate works by connecting our destination Consul cluster, queries the keys that we instruct it to sync using Consul's built-in remote datacenter capabilities, and synchronizes these key-value pairs to our destination Consul cluster's local datacenter.

Download the latest consul-replicate release, and install it on one of the Consul nodes in datacenter B.  Your ```/etc/consul-replicate.hcl``` should look something like this:
``` json
consul = "127.0.0.1:8500"
token = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
retry = "10s"
max_stale = "10m"

  prefix {
    source = "vault/sys/token@datacenterA"
  }
  prefix {
    source = "vault/sys/policy@datacenterA"
  }
  prefix {
    source = "vault/logical@datacenterA"
  }
  prefix {
    source = "vault/audit@datacenterA"
  }
  prefix {
    source = "vault/core/audit@datacenterA"
  }
  prefix {
    source = "vault/core/auth@datacenterA"
  }
  prefix {
    source = "vault/core/keyring@datacenterA"
  }
  prefix {
    source = "vault/core/mounts@datacenterA"
  }
  prefix {
    source = "vault/core/seal-config@datacenterA"
  }
```

The key here:
##### <div class="alert alert-danger">DON'T REPLICATE THE ENTIRE /vault TREE!!!</div>

It's not so much about what you DO replicate as it is what you DON'T replicate.  Jeff helped me out tremendously here:

> The values I gave above should be a good baseline. You definitely do not want /core/leader or /core/lock and if you replicate /sys/expire you'll have multiple DCs all trying to revoke the same leases, which is a very bad idea.

> ...

> From some looking at a basic layout with the file physical backend, you'd want to copy /sys/token but not /sys/expire, yes to /logical/, and yes much of /core but not /core/leader and not /core/lock.

Once you have your prefixes defined, you can start up consul-replicate: ```/usr/local/bin/consul-replicate -config=/etc/consul-replicate.hcl -log-level=info```.  Within a few seconds, all of your Vault data should be replicated up to your destination datacenter.

# Conclusion

While unsupported, I've found this setup to be fast and stable in our use case.  We use Vault more as a encrypted secret keystore for passwords that applications need access to, and don't use any of the more esoteric features such as the various auth backends.  We simply use the token auth and generic secret storage along with the file audit backend.  Replication is near-immediate, and the performance penalty incurred due to disabling the read cache has been acceptable.

