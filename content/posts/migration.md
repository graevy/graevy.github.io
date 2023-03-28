---
title: "migration"
date: 2023-03-28T04:33:25-07:00
draft: false
---

After my digitalocean team dissolved, I migrated from a droplet costing me $4/mo to github pages for free. Truly, I could've avoided webhooks entirely and saved money in the process. But I did centralize my services and lost privacy, so who's to say; I learned all about the specifics of CNAME records interfering with SSL certs ;-;

Surprisingly, migrating the build pipeline was the easiest migration component, and actually enabling https was the hardest. I hung on some DNS records until I decided to remove the cloudflare step (obvious in retrospect, but I wonder if I can reintegrate it). I'm not sure if I ever bothered setting up https on the droplet, but it definitely would've been easier with actual diagnostics involved.