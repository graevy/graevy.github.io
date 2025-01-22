---
title: "Neovim"
date: 2025-02-25T22:19:06-08:00
draft: true
---

### Neovim and Nixos

[My neovim dotfiles](https://github.com/graevy/dotfiles/tree/nixos/.local/linkedobjs/nvim) are well-cooked now. There are three major traps I think you can fall into trying to wrangle neovim with nixos:

- trying to use nixos to manage neovim's config (home-manager's `programs.neovim.plugins`, `nixvim`)

They don't reach feature parity with good neovim tooling, e.g. home-manager doesn't do conditional plugin loading with lazy-nvim. `nixvim` generates lua configs, and is probably the best tool for this, but [notes](https://github.com/nix-community/nixvim#additional-config) that "Sometimes NixVim won't be able to provide for all your customization needs. In these cases, the extraConfigVim and extraConfigLua options are provided". So the abstraction will leak, especially if you're as ~~autistic~~ opinionated as I am, and there will be lua files and nix files to manage.

The regular neovim config will be portable to other distros.

- dynamic neovim tooling (`packer`, automatic lsp managers like `mason`)

You just end up losing nixos' advantages. Declarative version pinning, non-deterministic packer sync calls, etc.

- overcorrecting for simplicity

You can build features from neovim's popular tooling without the plugins themselves. Don't shirk e.g. `lazy-nvim` for building conditional plugin loading with `opts/packadd`, reinventing the wheel.
