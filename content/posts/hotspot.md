---
title: "hotspot"
date: 2023-06-01T01:07:37-07:00
draft: false
---

# Problem

My phone's rom, grapheneOS, permits tethering, but my carrier bans it[^2]. So, my carrier blocks anything I tether.

There are 4 vectors I've read about for tether detection[^4]:
1. Packet TTL
2. Phone defaults are configured to expose tether status to carriers.
3. TCP/IP stack fingerprinting. Default implementations vary by OS
4. Deep packet inspection. Mobile devices don't connect to e.g. a windows update server

# Solution

1. Incrementing the default packet TTL on my desktop/laptop spoofs my phone's TTL.
2. Variables stored in `/system/build.prop`. Specifically, `tether_dun_required` needs to be `0`, and `net.tethering.noprovisioning` needs to equal `true`. You need root access now or during the OS build step to edit `/system`. I don't think this can be addressed on iOS.
3. Too inconsistent to be the sole reason to block packets; I ignored this
4. A VPN fixes this easily

So now I'm pushing this post on my desktop from my phone's hotspot[^1]. I don't know how many of these fixes are actually necessary; that probably varies by carrier. I succeeded after setting up a VPN[^3], incrementing TTL, editing `build.prop` vars, and rebooting my desktop.

[^2]: unless I pay extra. America doesn't even have net neutrality

[^4]: from stackoverflow and xda-developers

[^1]: Comcast doesn't provide 100% uptime, so the redundancy is nice.

[^3]: $15/mo cheaper than the hotspot premium