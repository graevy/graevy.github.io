---
title: "nixos"
date: 2025-02-08T18:32:36-08:00
draft: false
---


Did a bunch of projects without posting about them. Gonna batch-release these. This one is about moving from arch to nixos.


### What is NixOS?

Nixos is:
- the concept of [nix itself](https://web.archive.org/web/0/https://jonathanlorimer.dev/posts/nix-thesis.html)
- your [configuration.nix file(s)](https://github.com/graevy/nixos)
- `sudo nixos-rebuild switch`
- `sudo nixos-collect-garbage -d`
- the occasional `flake.nix` and `nix-develop`
- whatever you settle on for misc tooling. for me, `nix-shell -p <some package i want to test>`, and the `nix-search` and `nix-inspect` packages

That's it. Don't believe anyone else. I would never lie to you.


### Why?

To further the declarative obsession. Because I've been using the same distro for more than 2 years. To become less sufferable.


### What happened?

The classic dual-boot[^1]-and-replace-old-OS strategy, so there weren't any huge headaches. It took me like a month of hour-a-day reading/tweaking[^6] to reach feature parity with my arch installation, so you're in for that if you try it.

There were a few blockers:

- I moved from X to wayland in the middle of this, so lots of trying out new tooling (i.e. i3->sway)
- Versioning gets messy. nix-channel can track state accidentally, some packages need you to bring in unstable nixos, etc.
- An edge case. I had to remove some packages, which means editing `configuration.nix` and then `sudo nix-collect-garbage -d && sudo nixos-rebuild switch`[^4]. Some of them contained symlink loops to their parent dirs, so nix refused to delete them from `/nix/store`, and they wormed their way into new derivations! `nix-store` provided some poorly-documented manual solution (recurring theme for NixOS) so I just reinstalled. That may seem extreme, but nixos simplifies reinstallation, and I wanted to test the process[^8]. Boot into a new nixos installation, move your `configuration.nix` on it, and `sudo nixos-rebuild switch`. Anything now missing needs to get declared.


#### My takes

It's good. Unified configuration in a single dir. I'm bought-in now, costs completely sunk, which is its own problem.

Flakes. Bad ux. I don't currently see a use for them beyond "nix-shell but version-pinned", which is what I want out of a `shell.nix` file anyway, I think[^7]? And for that purpose, it's a huge amount of boilerplate in a really annoying domain-specific language. I'm sure people who use them more fluently have better uses for them, and I might get there eventually. For my gripes, I do still use flakes.

NixOS integrates very well with systemd, which I wasn't expecting. I'm not really writing my own unit files often, but you can't rely on the abstraction. There's a larger pattern of nixos' native configs not being granular enough. For instance: defining a service that doesn't start automatically on boot requires [a slight hack](https://github.com/graevy/nixos/blob/64d256aa0fe7b5005a7206c2fed2933c1f647754/configuration.nix#L271C1-L275C43) where I would really just like `services.thing.enabled = true` and `services.thing.auto = false`, and to not have to manually write unitfiles. Truthfully in the spirit of open source I should add the feature to `services` myself, but I've heard many horror stories from my hackspace friends about trying to get nixos PRs merged.

A lot of people complain about massive `/nix/store`s, and I don't get it. Yes, it frequently stores unnecessary versions that simpler package managers don't have to. This stops things from breaking. My `/nix/store` is about 58Gb[^2], containing 18.2Gb of package versions which *might* be deduplicated using `apt` instead[^3], but I can't help but think: every deduplication case trusts in backward compatibility. I find NixOS absolutely worth it even on smaller ssds. Maybe the worst-case of `/nix/store` is a disk hog, but I haven't seen it yet.

When you leave the happy path, it's awful. The documentation is sparse[^5], you have to hack to get anything done, in a system that does not want you to create undeclared state. The NixOS equivalent of a "linux evening" fixing something gets inverted: spend 3 hours building something that won't break, where normal users simply `apt install`. I honestly think most nixpkgs maintainers are just people who went down a hole and had to build a package about it.

While I'm discussing the happy path -- where do I start with hardcoded file paths? The whole environment begs for a new layer, some interface between path and file that symlinks and `nix-ld` only grasp at[^9]. But nix, existing mostly in userspace, on top of filesystems and the kernel, can't neatly integrate itself. 

What does nixos offer? ultimately, lightweight portability:
- easy environmental CI/CD by regenerating old versions of the OS. A great alternative to heavy system backup/restore, but not great for stateful objects, which aren't usually things that break during upgrades, so, great feature!
- nix shells/flakes are great solutions to the problem of development/build determinism that are, again, solved more heavily (albeit more completely) by containerization.
- configuration centralization. OS-on-a-stick. My system becomes a file, next to my packages, programs, services, etc.


[^1]: or quad-boot, you know, nobody's judging anybody here

[^2]: I did not garbage-collect before checking, but I did somewhat recently move to 25.05 and then gc.

[^3]: I'm just saying, my arch install had 5 active versions of electron required by various different packages, and my `/nix/store` contains 4 at the moment. While `/nix/store` contains version bloat, NixOS neatly collates your packages; you rarely end up with more than you need, whereas conventional package managers tend to bloat over time, even when pruning orphans.

[^4]: See? I didn't lie to you

[^5]: The nixos wiki is often just a trap. Like, it's not maintained well, and frequently out of date, also apparently unassociated with the nixos project? There are two of them, `nixos.wiki` and `wiki.nixos.org`, and the unofficial one, `nixos.wiki`, is the older one that everyone uses. My guess is that they kept getting criticized for having poor documentation and decided to build a competitor to the arch wiki, but they've moved too late, and now it'll take a decade to sort itself out.

[^6]: I did read about a third of Dolstra's thesis. I would legitimately recommend reading about the evaluator's kernel-inspired-memory-management-but-for-disks. For me, that section cleanly described nix's solution to a problem I hadn't deeply considered before. 

[^7]: You can version pin via specific commit hashes. I tried it once, don't bother, just use flakes.

[^8]: I also had to left-expand my OS partition after killing some others, so, that was the best time to do it.

[^9]: Symlinks need to exist at the path destination, and `nix-ld` only handles dynamic linking. What if packages could supply their typical hardcodes without mutating the filesystem?

- the users complain about a hardcode breaking things
- nixpkgs maintainers for e.g. `glibc` add an entry to the map: `/usr/lib/<glibc header>` -> `/nix/store/<hash>-glibc`
- shim this map at a lower layer, like inside `open`/`openat`/`stat` or even in the kernel?

I do see some problems here; trusting the maintainer, debugging gets weird, performance concerns...I don't know, is this so insane? I'm not maintaining packages, or even particularly nix-brained, but even I can see this hole. We could stop haranguing developers (who are often just trying to not break userspace) assuming Filesystem Hierarchy Standard conventions and solve the problem endemically.
