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
- the multi-tenant kubernetes cluster that you said you'd like to configure 2 years ago so your hackspace members can host their own software but "never got around to doing" because that would take like a year for you to learn how to do properly

Here's how to build a calendar! You will need:

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



#### Upstream k3s

Oh no. What are you doing here? You forgot to unseal Openbao!

#### Downstream k8s

Just read the README for building out the cluster. DRY

#### Calendar & Proxy

#### Go-HTTP webserver


[^1]: total yakshave, unnecessary for proxmox, and now that I know it, nixos 100x better for this

[^2]: virt-manager on nixos strong competitor. ARM proxmox isn't there yet so I haven't done this step

[^3]: these I can't share because they're almost entirely full of secrets. I also can't store them in Vault because dependency graph. I just have them encrypted in my syncthing folders (laptop + desktop. phone/ereader too insecure)

[^5]: crucial is defined as anything that slows our ability to fix problems when it goes down; yes, DNS, but also e.g. the synapse (matrix) server. while I made the initial infra for this I can't take credit for most of the software on it

[^6]: this is managed by the webserver and as such should be abstracted into another repo to reduce the privilege of the webserver and to not pollute commit history

[^7]: baikal is a pretty obvious choice in that it's a simple pre-containerized caldav server. nextcloud is too heavy, good gui though



