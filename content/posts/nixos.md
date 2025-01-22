---
title: "nixos"
date: 2025-02-08T18:32:36-08:00
draft: true
---


Did a bunch of projects without posting about them. Gonna batch-release these

#### Why

To further the declarative obsession. Because I've been using arch for more than 2 years. Because people kept telling me to try it.


#### What is nixos

NixOS is:
- [nix itself](https://web.archive.org/web/0/https://jonathanlorimer.dev/posts/nix-thesis.html)
- your [configuration.nix file(s)](https://github.com/graevy/nixos)
- `sudo nixos-rebuild switch`

That's it. Don't believe anyone else. I would never lie to you.


#### What happened

The dual-boot[^1]-and-replace-old-OS, so there weren't any huge headaches. It took me like a month of hour-a-day reading/tweaking to reach feature parity with my arch installation, so you're in for that if you try it.

There were a few blocks.

- I moved from X to wayland in the middle of this, so lots of trying out new tooling
- Versioning is pretty messy. nix-channel can track state accidentally, some packages need you to bring in unstable nixos,  etc.
- Okay, so this was an edge case. I had to remove some packages, which meant basically `sudo nix-collect-garbage -d && sudo nixos-rebuild switch`. Some of them contained symlink loops to their parent dirs, so nix refused to delete them, and they were load-bearing for existing derivations. That was a nightmare. There was some solution to manually remove them via `nix-store` but it was poorly documented (recurring theme for nixos) so I just reinstalled the OS. That may seem a little extreme, but I had to left-expand the partition anyway, and the whole point of nixos really is to manage your installation declaratively, so it's a good exercise to see what needs to get added to the declaration.


#### My takes

It's good, the declaration is very satisfying. I'm totally bought-in now, complete sunk-cost about it, which is its own problem.

Flakes. Bad ux. I don't currently see a use for them beyond "nix-shell but version-pinned", which is what shell.nix should be anyway, I think? And for that purpose, it's a huge amount of boilerplate in a really annoying domain-specific language. I'm sure people who use them more fluently have better uses for them, and I might get there eventually.

Nixos integrates very well with systemd, which I wasn't expecting. I'm not really writing my own unit files.

When you leave the happy path, it's awful. The documentation is sparse, you have to hack to get anything done, in a system that does not want you to create state. I honestly think most nixpkgs maintainers are just people who went down a hole and had to build a package about it. Come for the determinism, stay for the buy-in?

What does nixos offer? ultimately, lightweight portability:
- easy CI/CD by regenerating old versions of the OS, a great alternative to heavy backup/restore for a whole system, but not great for stateful objects, which aren't usually things that break during upgrades, so, great feature
- nix shells/flakes are great solutions to the problem of development/build determinism that are, again, solved more heavily by containerized releases


[^1]: or quad-boot, you know, nobody's judging anybody here

