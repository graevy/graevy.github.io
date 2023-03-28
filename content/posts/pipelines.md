---
title: "pipelines"
date: 2023-01-25T14:09:41-08:00
draft: false
---

## Source to Deploy, directly

I had enough free time to throw together this project site over the holidays. Without any real networking knowledge, I snagged on basics for hours; the worst by far[^1] was the webhooks. Ultimately, the 3 guides I referenced didn't mention that network points and nodes (?) have their own rules for port forwarding:

- Cloudflare has a very short [whitelist](https://developers.cloudflare.com/fundamentals/get-started/reference/network-ports/)[^2],
- Most distros, and particularly webhost distro images (I imagine), require port whitelisting through ```iptables```/```nftables``` backends typically managed with ```ufw```

Basically, any point along the source -> browser pipe can block you. And if it's github webhooks -> dns resolver (cloudflare) -> webhost (digitalocean) -> server running ```webhook``` package systemd service -> router -> endpoint, it's dicey. It's understandable that a guide wouldn't include this information; it's obvious to an expert, and beginners will probably just start with ```git pull```s on a cronjob/systemd timer.

## Build and Test

I've been careful not to interfere with Hugo's default build process ```hugo```; it also handles testing beautifully through ```hugo server```. My only hangup was forgetting my browser caches recently visited webpages: something that Hugo explicitly warns you about in the documentation (that I read a month ago).

I was annoyed by customizability issues in the devise theme, but they were [recently added](https://github.com/austingebauer/devise/commit/8b4bc6fb5fb28986685679a6f2267053514e87c2) as features, so I dodged build scripts with toml tinkering[^3]. I'm considering more complex html elements if they don't impact page size which might require forking the devise theme to not complicate the build process.


[^1]: Defeating me until I returned and could ask people who knew what they were doing
[^2]: There are compromises for custom port forwarding through cloudflare, but there are ports which explicitly disable caching, and the only reason not to use them is because you have to add ```-port 1234``` to the ```webhook``` config file located by default at ```/etc/systemd/system/webhook.service```
[^3]: THANK YOU [kjeller](https://github.com/kjeller)