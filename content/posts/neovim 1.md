---
title: "Neovim 1"
date: 2025-02-25T22:19:06-08:00
draft: true
---

### Neovim and Nixos

[My neovim dotfiles](https://github.com/graevy/dotfiles/tree/nixos/.local/linkedobjs/nvim) are well-cooked now. There are three major traps I think you can fall into trying to wrangle neovim with nixos:

- trying to use nixos to manage neovim's config (home-manager's `programs.neovim.plugins`, `nixvim`)

They don't reach feature parity with good neovim tooling, e.g. home-manager doesn't do conditional plugin loading with lazy-nvim[^2]. `nixvim` generates lua configs, and is probably the best tool for this, but [notes](https://github.com/nix-community/nixvim#additional-config) that "Sometimes NixVim won't be able to provide for all your customization needs. In these cases, the extraConfigVim and extraConfigLua options are provided". So the abstraction will leak, especially if you're as opinionated as I am, and there will be lua files and nix files to manage.

This is an inherent NixOS trade-off. You start with the straightforward declaration `programs.neovim.enable = true;`. Then there are helpful minor config options e.g. `defaultEditor`. Then, useful config options that NixOS can reasonably set that tooling can also set e.g. `viAlias` being also easily inserted in shell configs. Then things are maybe too complicated to implement declaration for, usually programs with package managers, yet NixOS happily supplies the footguns to proceed.

Not all NixOS program modules do this. Steam is functionally a package manager for games, yet `programs.steam` doesn't try to offer per-package (per-game) declaration. Steam's total environment is complex[^3], and thus best delegated to steam rather than the NixOS module. 

The regular neovim config will be portable to other distros; NixOS' bespoke configs won't be. Sometimes my packages don't break their config-space, and their config files should just be ported as inputs[^1].

- dynamic neovim tooling (`packer`, automatic lsp managers like `mason`)

You just end up losing nixos' advantages. Declarative version pinning, non-deterministic packer sync calls, etc...but I do see advantage in the simplicity of hybrid environments.

- overcorrecting for simplicity

You can build features from neovim's popular tooling without the plugins themselves. Don't reinvent the wheel via e.g. `lazy-nvim` for building conditional plugin loading with `autocmd` or `opts/packadd`.

[^1]: Everybody is always going to lug their shell configs with them.

[^2]: Workarounds do exist, i.e. defining plugin load order in extraConfig

[^3]: Beyond just being very stateful. Per-game declaration means a massive maintenance development surface that, while easily delegable, isn't useful when Steam is right there!
