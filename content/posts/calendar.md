---
title: "calendar"
date: 2025-09-10T00:53:58-07:00
draft: true
---

`https://io.devhack.gay/proxy/calendar.ics`

We need to talk about inter-cluster openbao eso sa jwt reviewers.

### So you want to self-host a software project

Here are your options:
- a 24/7 desktop at home, maybe a homelab?
- a $4/mo digitalocean droplet or similar
- the "declarative" multi-tenant kubernetes cluster that you said you'd like to configure 2 years ago so your hackspace members can host their own software but "never got around to doing" because that would take like a year for you to learn how to do properly

Here's how to declare a calendar! You will need:

- automated [debian installation](https://github.com/graevy/debhack) for hypervisors[^1]
- terraformed proxmox[^2] configuration
- Talos VM configs[^3] for the kubernetes clusters
- a [stable upstream cluster](https://git.devhack.net/devhack/core-infra) to host crucial[^5] services on
- a [less stable downstream cluster](https://git.devhack.net/a/member-prod) controlled by fluxcd for members (that's you!) to "selfhost" on
- a [third repo](https://git.devhack.net/a/tenants)[^6] for flux to [track](https://git.devhack.net/a/member-prod/src/branch/main/tenancy/tenants-repo.yaml) valid cluster tenants
- a [fourth repo](https://git.devhack.net/a/k8s) for your own tenant k8s manifests
- the actual [statefulset](https://git.devhack.net/a/k8s/src/branch/main/apps/baikal/statefulset.yaml) for your caldav server[^7]
- a [token-access-controlled reverse proxy](https://git.devhack.net/a/k8s/src/branch/main/baikal/proxy) so the caldav server cam serve a concatenated .ics blob for compatibility with pesky google calendar seattle polyamorists
- a [go-http webserver](https://git.devhack.net/a/member-prod/src/branch/main/tenancy/src-frontend) so members can provision themselves space on the k8s cluster after passing both oidc authentication and keycloak's "are you a paying member" api query

Let's start with...

#### Talos

Should your containers live in (talos or otherwise) VMs, or is bare metal fine? The answer: it doesn't normally matter, and it's not hard to pivot. Talos has good documentation, and `talosctl` works every time I need it to. Inconsistent donated hackspace hardware and general nixos ignorance pushed me to use VMs.

#### [03:06:52] Devin Hacker: heyy I restarted core's VMs can you unseal openbao pls?

How do you learn to use kubernetes if you've never written a Dockerfile?

- setup your hypervisors and debian VMs
- pick the simplest kubernetes distro to configure (k3s)
- dangle your terrible cluster in front of knowledgable hobbyists
- they condescendingly explain to you what you're doing wrong
- incur tech-debt through poorly-implemented cluster patches
- repeat steps 3 through 5

Stability is a red herring; devhack has two clusters because I wanted to learn to use kubernetes. Anyway, the Nerd Containment Cluster directs[^8] the knowledgable away from my real baby:

#### Downstream k8s (member-prod)[^9]

Just read the [README](https://git.devhack.net/a/member-prod#readme) for building out the cluster. DRY? I've been interstitially chipping away at this all year. I started with talos, helmed traefik and external secrets, got frustrated with lack of networking knowledge, acquired CCNA, really started putting in the hours, [beat](https://git.devhack.net/a/member-prod/src/branch/main/kickflux.sh) flux [with](https://git.devhack.net/a/member-prod/src/branch/main/debugflux.sh) [a](https://git.devhack.net/a/member-prod/commit/1c33c06f4b264ec33b2abab54896b387270c1472) [stick](https://git.devhack.net/a/member-prod/src/branch/main/toggleflux.sh) [until](https://fluxcd.io/flux/installation/configuration/multitenancy/#how-to-configure-flux-multi-tenancy) I settled on a model, wrangled inter-cluster auth. Observe[^10] my gradual descent as this became my primary project:

![committimes](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/committimes.png)

Note the number of commits between the hours of midnight to 6am. The first clustering represents openbao inter-cluster auth:

```
(Sep 9, 2025, 02:38 PM PDT)
ac755528e8 	redid the secrets model 	two months ago 
9edfee8184 	connect externalsecret to secretstore 	two months ago 	
df2ec5f41f 	members->tenants. debugging per-namespace secretstore 	two months ago 	
bbcf9917d3 	route to the external openbao server. not sure if i need to hit port 8200 yet 	two months ago 	
a984cabfac 	secrets hell 	two months ago 	
555dc10194 	moving around the secretstore 	two months ago 	
6d02c7bbb2 	i think the secretstore needs to be in the openbao namespace? 	two months ago 	
d230c4cf73 	that should obviously go in infra 	two months ago 	
b4c5779857 	openbao namespace 	two months ago	
(Aug 10, 2025, 08:57 PM PDT)
```

(The second clustering broadly represents [rook-ceph-external declaration](https://git.devhack.net/a/member-prod#rook))

#### Go-HTTP webserver

The webserver for tenant autoprovisioning isn't particularly important, it just means I don't have to click approve every week forever. No python; an opportunity to get into Go. Because traefik's middleware handles the oidc auth flow and gatekeeps `/trigger`, it's pretty simple and insecure and I can just vibe it out. Great. It's like 300loc right now but it's still unnecessarily validating JWTs.

#### Conclusion

Now you've built your calendar!


[^1]: total yakshave, unnecessary for proxmox, and now that I know it, nixos 100x better for this

[^2]: virt-manager on nixos strong competitor. ARM proxmox isn't there yet so I haven't done this step

[^3]: these I can't share because they're almost entirely full of secrets. I also can't store them in Vault because dependency graph. I just have them encrypted in my syncthing folders (laptop + desktop. phone/ereader too insecure)

[^5]: crucial is defined as anything that slows our ability to fix problems when it goes down; yes, DNS, but also e.g. the synapse (matrix) server. while I made the initial infra for this I can't take credit for most of the software on it

[^6]: this is managed by the webserver and as such should be abstracted into another repo to reduce the privilege of the webserver and to not pollute commit history

[^7]: baikal is a pretty obvious choice in that it's a simple pre-containerized caldav server. nextcloud is too heavy, good gui though

[^8]: though I started getting PRs last week. mm

[^9]: Because we're going to make member-test eventually, right?

[^10]:
```
nix-shell -p python313Packages.matplotlib
git log --reverse --pretty='%at' > /tmp/git_times.txt
python3 - <<'PY'
import matplotlib.pyplot as plt
import datetime as dt

with open("/tmp/git_times.txt") as f:
    ts = [int(x.strip()) for x in f if x.strip()]

times = [dt.datetime.fromtimestamp(t).hour + dt.datetime.fromtimestamp(t).minute/60 for t in ts]

plt.style.use("dark_background")
accent = "#95d550"

plt.figure(figsize=(8,4), facecolor="#111", edgecolor="none")
plt.scatter(range(len(times)), times, s=12, color=accent)
plt.yticks(range(0,24,2), color=accent)
plt.xticks(color=accent)
plt.ylabel("Hour of Day (24h)", color=accent)
plt.xlabel("Commit Number", color=accent)
plt.title("Avery Mental Health, Visualized by `member-prod` Git Commit Timestamps Over Time", color=accent)
plt.grid(True, color="#333", alpha=0.4)
plt.tight_layout()
plt.show()
PY
```

