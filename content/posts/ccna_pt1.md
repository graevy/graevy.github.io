---
title: "ccna 1"
date: 2023-10-22T20:14:09-07:00
draft: false
---


### Background

I'm half finished with this CCNA course, and it's been a missing piece. A few months ago I was working on a PR for ss14 and someone in the discord told me to implement device networking to mesh some devices instead of the [bitmask I wrote](https://github.com/space-wizards/space-station-14/blob/6b340ab2f685b35f7ad41cb6bd78df3056c6d156/Content.Server/Shuttles/Components/RemoteShuttleTimerComponent.cs), and in retrospect, this was obvious. I'd just learned helplessness with the word "networking". And so much of tech is confidence; we can't learn it all; we just need to know how to learn.

So I detoured for the CCNA cert. It's comprehensive, marketable, and concrete. I went through something similar with radio a few years ago.

### VLANs, Subnetting, and Hosting

This detour coincided with setting up [devhack](https://devhack.net/)'s network, with some quirks:

- We were allocated a /29 subnet despite not paying for it
- Most of the hardware is old and donated
- Being a hackerspace, the config should be transparent

This first point was really strange. Obviously the initial reaction was "hey, six usable addresses!" but the reality of the situation is that our ISP probably reactivated an old configuration for our shared office space and they would probably catch it on the next billing cycle, or when other tenants setup networking[^1]

The second is still a major pain point, and I'm obviously in over my head. We settled on 6 VLANs to start, 2 switches (1 layer 3), and 2 SSIDs. The day after my course covered VLANs. Our L3 switch had other plans:
![vrf](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/vrf.jpg)
but we're getting there.

And the third is an unexpected boon deviating from cisco's standard. I get my setup criticized by professional network engineers, and now I'm leading an RSA workshop this week. :D

![rsa](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/rsa.jpeg)


[^1]: As of October 2023, they haven't
