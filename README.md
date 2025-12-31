<p align="center">
  <img src="./assets/fireflake.svg" alt="Fireflake logo" />
</p>

# Dotfiles (a.k.a *"Fireflake"*)

This is my personal dotfiles repo, managed entirely via
[`home-manager`](https://github.com/nix-community/home-manager),
[`nix-darwin`](https://github.com/nix-darwin/nix-darwin) and
[Nix](https://nixos.org) in general. I named it "Fireflake" because I needed
some form of unique namespace for certain settings in my configurations.

I currently manage two machines from this repo:
- _"Bullshit Machine"_, my PC running NixOS on a Hyprland-based setup
- "Storm Prism", my MacBook Pro running macOS, managed via `nix-darwin` and
  Homebrew, running [Aerospace](https://github.com/nikitabobko/AeroSpace) as a
  window manager.

## Usage

This repo is not really useful for anyone except me, unless you're looking to
draw inspiration from it to make your own (which I heavily encourage)! That being said,
the gist is fairly simple:

- Install Nix with flakes support. Use whatever installer you wish, but
  generally the [Lix](https://git.lix.systems/lix-project/lix-installer) and
  [Determinate Nix](https://github.com/DeterminateSystems/nix-installer)
  installer are the only ones that work nicely on macOS (for now, hopefully).
- Run `nix develop` on the repository.
- Rekey all Agenix secrets via `agenix -r` after updating `secrets/secrets.nix`
  to contain the new SSH public keychains for each host you're configuring.
- Run `nh {os/home} switch .` at your leisure!

## Structure

Fireflake generally splits configuration between the system and user-level
via the split between the OS-specific configuration (on a per-host level) and
`home-manager` configurations at the user level. The gist being:

- Anything that is system-wide should exist in `darwinConfigurations/nixosConfigurations`.
- Anything that is user-specific should exist in `homeConfigurations`.

The repo's Nix modules are split like this:

```
.
├── flake.nix              # Flake entrypoint
├── modules/
│   ├── home/              # Home-manager modules
│   │   ├── programs/      # Application configs (fish, doom, vscode, etc.)
│   │   ├── hypr/          # Hyprland configuration (for Linux only)
│   │   └── backup/        # Borgmatic setup (for automated backups)
│   └── darwin/            # nix-darwin modules
│       └── hosts/         # Per-machine configs
├── BullshitMachine/       # NixOS machine configuration (legacy, will move)
├── lib/                   # Utility functions (legacy, will move)
└── secrets/               # Age-encrypted secrets
```

## Rice Buzzwords

For a brief overview of the general tools/theming I use, here's
a quick list, with links to each relevant program/feature:

- [Catppuccin Mocha](https://catppuccin.com/) is set up across literally
  everything I use, using the [Nix module](https://nix.catppuccin.com/) when
  relevant.
- [Hyprland](https://hypr.land/) environment, with
  [ashell](https://malpenzibo.github.io/ashell/) and
  [Hyprshell](https://github.com/H3rmt/hyprshell) for a simple enough tiling DE on Linux.
- [Fish shell](https://fishshell.com/) with custom functions and [Starship
  prompt](https://starship.rs/)
- [Doom Emacs](https://github.com/doomemacs/doomemacs), with all its packages
  installed in the Nix store via
  [`nix-doom-emacs-unstraightened`](https://github.com/marienz/nix-doom-emacs-unstraightened)
  - While this was a cool experiment to see how declarative you can go with
    setting up configuration, I don't recommend this approach. You're far better
    off letting Doom Emacs install all the relevant packages and _only managing
    the dotfiles_ via `home-manager`, not the whole installation. It was nice
    that it worked, though.
- [VS Code](https://code.visualstudio.com/) replicating my existing Doom
  Emacs/LazyVim setups using the power of
  [vscode-which-key](https://github.com/VSpaceCode/vscode-which-key).
  - I am aware of [VSpaceCode](https://vspacecode.github.io/)'s existence. I
    may switch to it in the near future, for now I've just begun exploring a
    foray into using VSCode full-time.
- A collection of CLI tools I love:
  [ripgrep](https://github.com/BurntSushi/ripgrep),
  [fzf](https://github.com/junegunn/fzf), [bat](https://github.com/sharkdp/bat),
  [delta](https://github.com/dandavison/delta),
  [yazi](https://github.com/sxyazi/yazi),
  [Helix](https://github.com/helix-editor/helix),
  [xh](https://github.com/ducaale/xh),
  and more.
- [Jujutsu](https://github.com/jj-vcs/jj) as my primary VCS tool, with Git
  installed as an obvious fallback.
