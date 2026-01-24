# Neovim config

Personal Neovim configuration powered by `lazy.nvim`.

## Requirements

- Neovim `0.10+`
- Git
- `ripgrep` (`rg`) for search pickers/grep

Some plugins may require additional tools depending on what you enable/use (e.g. LSP servers via `mason.nvim`, `yarn` for `markdown-preview.nvim`, etc.).

## Install

```sh
# Backup your existing config first (optional)
mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/Setoryz/neovim-config.git ~/.config/nvim
nvim
```

On first launch, `lazy.nvim` will install plugins automatically.

## Notes

- Obsidian integration uses a local vault path; update it in `lua/seyi/plugins/obsidian.lua`.
- This config includes optional integrations like Wakatime/Codeium; enable/configure them according to your own setup.

## Formatting

This repo includes a `.stylua.toml`. To format Lua files:

```sh
stylua .
```
