---
title: "neovim + nixos"
date: 2025-02-25T22:19:06-08:00
draft: false
---

[My neovim dotfiles](https://github.com/graevy/dotfiles/tree/nixos/.local/share/nvim) are well-cooked now. I got into it initially because:

- my 2018 laptop has 8gb of ram and LSPs started crashing on larger projects
- I need fine-grained linter/diagnostic customization to not get distracted by them while coding
- The UI felt too difficult to customize generally
- I became obsessed with golfing my IDE startup time[^5]

![startup](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/startuptime.png)

I want to share what I've learned about interoperability.


### Cat-and-Mouse Declaration

NixOS modules for configuring complicated[^2] programs require ongoing maintenance, so the modules feature-lag their respective native configs. Neovim serves a good example.

`home-manager` and `nixvim`, two third-party[^4] nixos neovim configurations, provide `extraConfig` embedded lua snippets to inject native neovim configs. `nixvim` [notes](https://github.com/nix-community/nixvim/blob/f0764db7212003520341ac10ddcee50e9c458a6f/README.md?plain=1#L462) "Sometimes NixVim won't be able to provide for all your customization needs. In these cases, the `extraConfigVim` and `extraConfigLua` options are provided". I read the intention as "here's a hackable section for features we haven't yet implemented", but I worry:

- "I'm going to have to shove everything in here"
- "now I have TWO config languages"
- "the abstraction clearly leaks"
- and when I see `extraConfigLuaPre` and `extraConfigLuaPost`...

Critiquing `nixvim` purely for being incomplete is unfair, but neovim changes a lot between versions[^11]; there will always be `extraConfigLua`.

This hybrid config provides centralization, because everything sits in the nixos module, and some access to the nixos build graph, but sacrifices:

- simplicity
- compared to fully committing to nixos modules, the determinism guarantees (you forfeit the safeguard against configuration drift)
- easy interoperability, should either the nixos module side or lua side require knowing the other's configs
- portability to other distros[^7]

Most nixos modules don't try to configure complex programs. Neovim is just the first module with third-party footguns I've had to justify balking at. Steam, for example, is functionally a package manager for games, yet `programs.steam` doesn't try to offer per-package declaration. Steam's complex environment is obviously best delegated to steam rather than the tiny nixos module.

Why are we so obsessed with reinventing the wheel? Why can't we just treat native configs as version-pinned flake inputs instead of building 200+ contributor projects? Existing opaque to nixos certainly has its downsides[^10], but I hit my limit here.


### My three[^3] miscellaneous tarpits wrangling Neovim

#### 1. Using someone else's bespoke config

I did this at first and I couldn't maintain it[^8]. Yeah, I can link you [mine](https://github.com/graevy/dotfiles), and you can throw the plugin list and the lua files at an LLM to get the gist. Personally, I have to approach complexity by encountering the problem a solution solves, so bottom-up works a lot better for me than top-down.

I definitely document all code differently now after going through that, with far less assumed ecosystem knowledge. At least in open-source.


#### 2. Overcorrecting for simplicity

I lost some time to this, after rejecting that overengineering for my own. 

You can build features from neovim's popular tooling without the plugins themselves, by way of `autocmd` and `opts/packadd` (on top of `lazy.nvim` in my case). Every time I've reached this point I've ended up replacing an autocmd block with a plugin. At the moment I have two autocmd blocks in my `init.lua`, one is a simple diagnostics toggle and the other is some LLM-slop to lazy-load my LSPs that I haven't finished evaluating. Both are experiments; what sort of diagnostic toggle behavior am I looking for, do I even need to explicitly defer LSP loading...Both should eventually become plugins with time[^9].

There are thousands of neovim plugins, and if you're at a point where you're rolling your own, you're either deeeeeeep in the trenches or paranoid about breaking changes on updates. I use under 25 plugins[^6] to be an *easily maintainable* IDE.


#### 3. Dynamic neovim tooling (`packer`, automatic lsp managers like `mason`)

You just end up losing nixos' advantages. Declarative version pinning, non-deterministic packer sync calls, etc...I do see advantage in the simplicity of hybrid environments, but what happens when an imperative install leaks out of neovim? Mason shoves things onto $PATH, and if anything uses those artifacts, and if they update imperatively, those are effectively undeclared dependencies.

Anyway, I didn't fall into this one. Mason's aggressive dynamism had me clutching my `configuration.nix`.


[^1]: Everybody is always going to lug their shell configs with them.

[^2]: For mature programs, the threshold for "too complicated" is maybe "has its own packages". The most complex piece of software I would feel comfortable configuring entirely in a nixos module is probably sway. Neovim changes a lot, varies so much between users...maybe one day nixvim will get there.

[^3]: Bonus pit: writing this post, which I've had to fully rewrite now twice to come close to making my points cleanly. Probably why it's so dense

[^4]: Though home-manager is widely adopted. I will also note here that `home-manager` doesn't do conditional plugin loading the way `lazy.nvim` does (though you can specify load order), and thus the feature-lag precludes my IDE boot-golfing. I consider `nixvim` more complete, and focus on it here.

[^5]: I did not truly understand the mindset of the dev who found the `xz` backdoor (because the ssh connections were taking ~500ms longer) until I noticed my neovim startup time occasionally went from ~80ms to ~300ms because, ultimately, I set a `power_save` profile in `tlp`.

[^6]: 22 at the time of writing, and trying to downsize. I think as time goes on, I'll understand the system better, update it more easily, and want more features, so I will gradually bloat.

[^7]: Nixvim does generate lua configs which you could export. Though it [isn't very comprehensive](https://github.com/nix-community/nixvim/discussions/2550), and I don't want to lose my documentation/code structure. If neovim ever calcifies, nixvim will catch up to become better than native configs, I think.

[^8]: If I understood neovim better first, this would've been much more manageable. I think my first attempt involved cloning someone's 80-plugin config before I knew where the plugin configs were stored or where generic vim options were defined, so maybe I'm overreacting.

[^9]: This concept of having a hackable codebase section has extended beyond neovim for me now; I no longer shove Rust into my experiments.

[^10]: Neovim itself isn't version-pinned, state could persist in the config files themselves, the native config exists outside the build graph...I mean, this is all compromise.

[^11]: With the inclusion of neovim 11 in nixos 25.05 stable, I just migrated my lsp configuration from the `nvim-lspconfig` to the new native `vim.lsp.config`, for example. Neovim is still changing quickly.
