---
title: "calendar"
date: 2025-09-10T00:53:58-07:00
draft: false
---

This post is actually just me boasting about learning[^1] kubernetes, but the [lessons](#lessons) at the end are cool

### Selfhost platform decision summary

- [ ] your 24/7 home desktop

- [ ] a $4/mo digitalocean droplet or similar

- [x] the multi-tenant kubernetes cluster that you said you'd like to configure 2 years ago so your hackspace members can host their own software """reliably""" but "never got around to doing" because "that would take like a year to learn how to do properly"

### Sating my inner autodidact by ignoring complexity

How to configure my calendar:

- choose your hypervisor. I started with proxmox[^2]
- write Talos VM configs[^3] for kubernetes cluster nodes
- make a [stable upstream cluster](https://git.devhack.net/devhack/core-infra) to host crucial[^5] services on
- make a [less stable downstream cluster](https://git.devhack.net/io/member-prod) for members (that's you and me!) to "selfhost" on
- make a [third repo](https://git.devhack.net/io/tenants)[^6] for fluxcd to [track](https://git.devhack.net/io/member-prod/src/branch/main/tenancy/tenants-repo.yaml) cluster tenants
- make a [fourth repo](https://git.devhack.net/io/k8s) tracked by the third repo. for personal k8s manifests
- get caldav server [manifests](https://git.devhack.net/io/k8s/src/branch/main/apps/baikal/statefulset.yaml)[^7]
- write a [token-access-controlled reverse proxy](https://git.devhack.net/io/k8s/src/branch/main/baikal/proxy) so the caldav server can serve a concatenated `.ics` blob for compatibility with google calendar
- write a [`go-http` webserver](https://git.devhack.net/io/member-prod/src/branch/main/tenancy/src-frontend) so members can provision themselves space on the k8s cluster after passing both oidc authentication and keycloak's "are you a paying member" api query
- install davx5/etar on android for client sync
- write [backup](https://git.devhack.net/io/k8s/src/branch/main/baikal/src-proxy/pushcalendars.py) [scripts](https://git.devhack.net/io/k8s/src/branch/main/baikal/src-proxy/savecalendars.py) in case *someone* were to wipe your PVCs

### How to learn kubernetes if you've never written a Dockerfile

- start with your hypervisor and some debian VMs
- pick the simplest kubernetes distro to configure (k3s)
- dangle your terrible cluster in front of knowledgable hobbyists
- they condescendingly explain to you what you're doing wrong
- incur tech-debt through poorly-implemented cluster patches
- repeat steps 3 through 5

Stability is a red herring; devhack has two clusters because I wanted to learn to use kubernetes. Anyway, the Nerd Containment Cluster directs[^8] the knowledgable away from my real baby:

### Downstream k8s (member-prod)[^9]

Just read the [README](https://git.devhack.net/io/member-prod#readme) for building out the cluster. DRY? I've been interstitially chipping away at this all year. I started with talos, helm'd traefik and external secrets, got frustrated with lack of networking knowledge, finished acquiring CCNA, really started putting in the hours, [beat](https://git.devhack.net/io/member-prod/src/branch/main/kickflux.sh) flux [with](https://git.devhack.net/io/member-prod/src/branch/main/debugflux.sh) [a](https://git.devhack.net/io/member-prod/commit/1c33c06f4b264ec33b2abab54896b387270c1472) [stick](https://git.devhack.net/io/member-prod/src/branch/main/toggleflux.sh) until I settled on a [model](https://fluxcd.io/flux/installation/configuration/multitenancy/#how-to-configure-flux-multi-tenancy), wrangled inter-cluster auth. Observe[^10] my gradual descent as this became my primary project:

![committimes](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/committimes.png)

Note the number of commits between the hours of midnight to 6am. 

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

The first clustering represents openbao inter-cluster auth[^14], and the second [rook-ceph-external declaration](https://git.devhack.net/io/member-prod#rook))

I enjoyed graphing this a lot so I took a break and wrote a feature-crept [Go script](https://github.com/graevy/sleep) to automate doing this for arbitrary public git committers.

Anyway, the webserver for tenant autoprovisioning just means I don't have to click approve indefinitely. No python; an opportunity to learn some Go. Because traefik's middleware handles the oidc auth flow and gatekeeps `/trigger`, it's pretty simple and insecure and I can just vibe it out. Great.

Didn't even describe the actual calendar. Published this a week ago. *Groan*. Baikal for caldav because it ships containers[^13]. Flask for the gcal reverse proxy because I prefer learning serially.

#### Things that don't matter

- Bare-metal/Virtualized Kubernetes

  not hard to pivot

- What kubernetes distro should I use?

  you're only going to touch them to update every 2 years

- Single or multi-controlplane?

  not hard to pivot

- IP hardcoding

  it's always DNS anyway

- Flux vs Argo

  i'm obnoxiously opinionated against GUIs and even I don't care

- Getting it right the first time

  not hard to pivot

#### Things that matter

- banning people that escalate arguments about tooling

- not using FreeIPA

### <a name="lessons"></a>Lessons

`member-prod` foie gras'd me with the tech firehose for about half a year. Mentality mid-marathon matters more than the technical minutiae when I treat myself as a component. Actively divorcing ego from the project made me feel and work better.

When I let myself ride the high of project success, I inadvertently tie my ego to it...I start flinching at rearchitecting, because I'm suddenly an idiot who should've known better, or new tools, because I'll feel stupid while learning them. Eventually, I start thinking about architecture during off-time, making fresh perspectives rarer while burning out faster. College compsci 101 had me grinding similarly[^11]; in particular, I remember learning kindof early that my brain hits diminishing returns on project effort without breaks after about 3 hours.

Similarly, I didn't try to maintain the appearance of hard work around others; those relationships would create emotional stakes in productivity. To actually see my progress you would've had to stalk my devhack forgejo and a 6-person infra group chat where I would post every ~week. This is maladaptive; marketing yourself matters, and doing too much alone means not learning from/with seniors/peers.

#### Technical Lessons

1. I'm prone to connecting components before testing them. Eschewing TDD when you're F10-ing through a step debugger works fine for low-stakes machine-local projects, but when my workflow became "redeploy a docker image and attach a debugging container to my webapp's pod" just to print-debug three integrated components I could've tested in isolation at `localhost:8080` a few steps prior...

2. Know where you can pivot. I don't know best practices! I'm learning on a weirdly-scaled homelab[^12], so I bias toward what I *hear* are best practices: I pre-planned my cluster down to a security model. Cheap iteration tolerates bad initial practices; I wasted time ensuring the ideal interoperation of modular components.

Anyway, you can't really "finish" a cluster with people in it, so I'm going to go ahead and post this now, and iterate on it later.

[https://io.devhack.gay/proxy/calendar.ics](https://io.devhack.gay/proxy/calendar.ics?token=6c6d335e2af668a0eb1dedf4d24886eae92375a7e20a935b6f01db116d1c1d71)


[^1]: having now gotten my hands dirty, [this](https://garnaudov.com/writings/how-i-think-about-kubernetes/) is the blogpost I wish I read at the start

[^2]: we aren't sold on proxmox at the moment because ARM, and we've largely agreed that if we did it over we would use nixos with virt-manager

[^3]: these I can't share because they're almost entirely full of secrets. I also can't store them in Vault because dependency graph. I just have them encrypted in my syncthing folders (laptop + desktop. phone/ereader too insecure). I've been impressed with Talos' documentation, and `talosctl` works every time I need it to

[^5]: crucial is defined as anything that slows our ability to fix problems when it goes down; yes, DNS, but also e.g. the synapse (matrix) server. while I made the initial infra for this I can't take credit for most of the software on it

[^6]: this is managed by the webserver and as such should be abstracted into another repo to reduce the privilege of the webserver and to not pollute commit history

[^7]: baikal is a pretty obvious choice in that it's a simple pre-containerized caldav server. nextcloud is too heavy, good gui though

[^8]: though I started getting PRs last week. mm

[^9]: Because we're going to make member-dev eventually, right?

[^10]:
    ```
    nix-shell -p python313 python313Packages.matplotlib
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

[^11]: Ivy League intro coding course second assignment: python 60fps rendered (Qt) Newtonian solar-system model. Zero previous code experience, still bitter

[^12]: "Sysadmin":Server >= 2:1

[^13]: and is weirdly opinionated about using subdomains instead of paths. [Symlink, I guess](https://git.devhack.net/io/k8s/src/branch/main/baikal/image/Dockerfile). Sortof motivated to pick up the project to build something competing in this space

[^14]: specifically, inter-cluster openbao external secrets operator service account json web token reviewer configuration

