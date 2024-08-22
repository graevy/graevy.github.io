---
title: "devhack 1"
date: 2024-06-26T01:40:22-07:00
draft: false
---

So I co-founded a [hackerspace](https://devhack.net) with 2 friends about a year ago, which has only really been operational for about 5(?) months. Things are somewhat stable; we're covering about 2/3 of our operating costs already, so we feel comfortable calling it a success. I'm gonna try to distill the early wisdom before I lose the perspective.

### Too Many Cooks: The Hackerspace Volunteer Contribution Model

The demographic that frequents a hackerspace is financially and emotionally invested in tech. Contributors are very enthusiastic about contributing[^1], but flakey. Volunteer output ebbs and flows according to passion, on-call status, the job market, etc.; we are the first chore that gets dropped when you're burnt out. The first thing to understand about coordinating nerds to bootstrap infrastructure for free is that we aren't remotely consistent.

When we dumped our first 2u on the floor of the server room, before we even had racks, we had Proxmox. It's a simple hypervisor, and most of our services are still guests on that 2u; while I'm going to speak at length about its many flaws, I don't think starting with Proxmox was a mistake.

Before we had settled on responsibilities, over the course of 2 nights, one of our members:
- setup Proxmox
- hacked together a door opener[^2] with a telegram bot and a relay
- configured an IoT network to house said relay
- disappeared without documenting anything, and hasn't returned

A microcosm. Especially during the first few months, where we met sporadically to vivify a hastily evacuated[^3] WeWork hub. I will spare you the tedium of leasing, furniture acquisition[^4], and access control; nothing technological was occurring for the first 3 months, and by then, we'd learned the heat was broken.

### How I accidentally got put in charge of infrastructure

Devhack resembled a sort of commercial freezer during the first winter, and rewilding the 50-degree sterile office environment was my first charge. Of the 3 of us, I alone expressed aesthetic concerns, and being the least technological, I was the obvious choice to theme and layout the space[^5].

![](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/shibari.jpg)

This didn't last. I made obvious decisions about space usage, sourced a dozen posters and contracted furniture, but I was also the only underemployee; I had the most free time.

We'd host an open hack night, and the other two would have obligations. A was on call, B was taking a mental health break from tech, A was working late, B went on an extended European burnout-vacation, etc.; I was the only consistent event host. As people settled into their roles, the need for a dedicated event host dissolved[^6], but every Thursday from about 5pm-1am, I took care of the space.

Being consistent and a co-founder caused people to ask me to give them access to/build/coordinate something. Most of them would assume I knew everything about our projects[^10]. I'm not some savant; I just had like 20 hours a week to complete tasks like "give the printer a CUPS container we can send files to so we don't need drivers on each machine" or "find out why the nodes can't talk to each other" or "proxmox HA" or "make auth happen". I failed about half of these tasks.

### Anarchy, State, and Utopia

Volunteer churn resulted in, best-case, a lot of half-finished and duplicated work. Half a dozen people with hypervisor admin access kept intermittently stepping on each other. Flakey services cause hasty fixes cause flakey services. Mediawiki documentation stopgaps the problem, but service interdependency propagates downtime.

We debated, for several months, what would replace our hell. We decided that "version control for filesystems" was kindof possible with declarative IaC. In lieu of a test env, being able to regenerate infrastructure off a git repo and a shell script would at least spare us extended downtime with the nuclear option. Aforementioned employee #1 European vacation left devhack's infra design to me, the SRE with no experience. I asked the half-dozen homelab enthusiasts for advice and got as many different answers, so I spent awhile reading about bare-metal devops stacks on reddit. Ultimately, two things became clear to me:

1. Kubernetes, being declarative, scalable, over-engineered, and popular, is the perfect choice for enthusiasts with colocation hosting ambitions
2. Whatever kubernetes is built on top of needs to be sufficiently declarative to rebuild everything from a git repo

One of the [professionals](https://github.com/1lann) had a Terraform -> Kubernetes stack that he used for everything and was willing to teach me, so that was an easy decision. Unfortunately, he was moving end-of-month, so he did what he could for about 3 weeks. Chuie laid the foundation that I still creatively break and reform to this day. Thanks!

To generate the images for each machine in the space, I thought I'd use Packer; same language, nice interoperability. I lost a week trying to wrangle Packer and Terraform on our servers. These tools are made for cloud infrastructure. People suggested Chef, Ansible, MaaS...I wasn't going to add more complexity. Our images are made by fetching the latest Debian netinst iso and repacking it with [my script](https://github.com/graevy/debhack/blob/main/repack_mbr.sh)[^7] to bundle a Debian `preseed.cfg` for unattended installation. Then, a Terraform[^8] provisioner takes the installation and customizes it per-machine. Good enough; I'll trade Debian lock-in[^9] for simplicity.

It took three months or so to get the cluster to an acceptable state. I must thank [Finn](https://github.com/thefinn93) for picking me up where I stalled (cluster networking) and guiding us toward best-practices. Our biggest delays:
- Renumbering the network about halfway through
- Multiple switch configuration editors causing cluster inter-VLAN routing failures
- The wiki dying after migrating its VM because Proxmox does not play well with NixOS

The cluster is at least fully operational now. There's a lot of k8s-specific boilerplate, which we don't think we can protect our members from. They don't have to interact with Terraform. Good enough for now.


[^1]: particularly in the greenfield stage

[^2]: the devhack door has become a sort of biblical horror, perhaps deserving of its own blogpost.

[^3]: the plants were left to die of thirst, the utility closet wasn't traversable, the heat didn't work, etc. 

[^4]: most of our stuff came from the UW surplus store, friends, and their trucks. Hard to beat $5 whiteboards

[^5]: and in theory, learn by osmosis.

[^6]: I'm writing this from [ToorCamp](https://toorcamp.org) with the other 2. Tomorrow will be the first time one of us has not run open hack night.

[^7]: This is a surprisingly complicated process. Distro installation images are usually read-only, and you have to supply initrd + kernel commandline options, and debugging requires doing this in a VM...

[^8]: Hashicorp closed-sourced Terraform, so I moved us to OpenTofu, which is the same, for now.

[^9]: Devhack tradition dictates one must take a shot every time one installs debian. One of our members built an [eternal debian installation](https://github.com/Kansattica/DebianWomanEdition). It has broken one hard drive and one cd drive thus far.

[^10]: This is a great way to develop Imposter Syndrome, by the way