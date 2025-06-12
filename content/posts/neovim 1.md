---
title: "neovim 1 (nixos edition)"
date: 2025-02-25T22:19:06-08:00
draft: false
---

### Neovim

[My neovim dotfiles](https://github.com/graevy/dotfiles/tree/nixos/.local/share/nvim) are well-cooked now. I got into it initially because:

- my 2018 laptop has 8gb of ram and LSPs started crashing on larger projects
- I need fine-grained linter/diagnostic customization to not get distracted by them while coding
- The UI felt too difficult to customize generally[^4]
- I became obsessed with golfing my IDE startup time[^5]

![startup](https://media.githubusercontent.com/media/graevy/graevy.github.io/main/static/images/startuptime.png)


### Neovim and NixOS

There are three major traps I think you can fall into trying to wrangle neovim on nixos:

#### Trying to use NixOS to manage neovim's config (e.g. home-manager's `programs.neovim.plugins`, `nixvim`)

They don't reach feature parity with good neovim tooling, e.g. home-manager doesn't do conditional plugin loading with lazy-nvim[^2]. `nixvim` generates lua configs, and is probably the best tool for this, but [notes](https://github.com/nix-community/nixvim#additional-config) that "Sometimes NixVim won't be able to provide for all your customization needs. In these cases, the extraConfigVim and extraConfigLua options are provided". So the abstraction will leak, especially if you're as opinionated as I am, and there will be lua files and nix files to manage.

This is an inherent NixOS trade-off. You start with the straightforward declaration `programs.neovim.enable = true;`. Then there are helpful minor config options e.g. `defaultEditor`. Then, useful config options that NixOS can reasonably set that tooling can also set e.g. `viAlias` being also easily inserted in shell configs. Then things are maybe too complicated to implement declaration for, usually programs with package managers, yet NixOS happily supplies the footguns to proceed.

Not all NixOS program modules do this. Steam is functionally a package manager for games, yet `programs.steam` doesn't try to offer per-package (per-game) declaration. Steam's total environment is complex[^3], and thus best delegated to steam rather than the NixOS module. 

The regular neovim config will be portable to other distros; NixOS' bespoke configs won't be. Sometimes my packages don't break their config-space, and their config files should just be ported as inputs[^1].


#### Dynamic neovim tooling (`packer`, automatic lsp managers like `mason`)

You just end up losing nixos' advantages. Declarative version pinning, non-deterministic packer sync calls, etc...I do see advantage in the simplicity of hybrid environments, but what happens when an imperative install leaks out of neovim? Mason shoves things onto $PATH, and if anything uses those artifacts, and if they update imperatively, those are effectively undeclared dependencies.


#### Overcorrecting for simplicity

You can build features from neovim's popular tooling without the plugins themselves, by way of `autocmd`s and `opts/packadd` on top of `lazy.nvim`. Every time I've reached this point I've ended up replacing an autocmd block with a plugin. At the moment I have two autocmd blocks in my `init.lua`, one is a simple diagnostics toggle and the other is some LLM-slop to lazy-load my LSPs that I haven't finished evaluating. Both are experiments; do I even need to explicitly defer LSP loading, what sort of diagnostic toggle behavior am I looking for...Both should eventually become plugins with time.

There are thousands of neovim plugins, and if you're at a point where you're rolling your own, you're either deeeeeeep in the trenches or paranoid about breaking changes on updates. I find the sweet spot to be slightly below 30 plugins[^6] -- enough to be a strong IDE, few enough to avoid disastrous updates.


[^1]: Everybody is always going to lug their shell configs with them.

[^2]: Workarounds do exist, i.e. defining plugin load order in extraConfig

[^3]: Beyond just being very stateful. Per-game declaration means a massive maintenance development surface that, while easily delegable, isn't useful when Steam is right there!

[^4]: For instance, I'm a horrible person and try to use my IDE as a regular text editor, and so I want to conditionally load basic IDE features like line numbers.

[^5]: I did not truly understand the mindset of the dev who found the `xz` backdoor (because the ssh connections were taking ~500ms longer) until I noticed my neovim startup time occasionally went from ~80ms to ~300ms because, ultimately, I set a power_save profile in `tlp`. [My neo-tree loading](https://github.com/graevy/dotfiles/blob/c4684353f2df13f4098ae4657a2a1c2cfda60d34/.local/share/nvim/init.lua#L57C1-L62C4) is probably the most egregious example

[^6]: I'm at 22 at the time of writing, and trying to downsize.
