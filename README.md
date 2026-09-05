# Leon's personal dotfiles
> including nix setup and chezmoi dotfiles

## Installation
Usually expected location: `$HOME/setup/dotfiles`
``` shell
git clone --depth=1 git@github.com:LeonStoldt/dotfiles.git "${HOME}/setup/dotfiles"
```
or
```shell
gh repo clone LeonStoldt/dotfiles "${HOME}/setup/dotfiles" -- --depth=1
```

Specific dotfiles for work (if enabled) can be placed into `${HOME}/setup/dotfiles-work` and will be picked up automatically by a manifest file, defining where to link each work dotfile.

---

## Thinking and organizing in layers
```text
                 _______________
                |               |
                |   dotfiles    |
         _______|_______________|_______
        |                               |
        |       Nix + Home Manager      |
 _______|_______________________________|_______
|                                               |
|         OS (e.g. Fedora Bootc Image)          |
|_______________________________________________|
```

---

### Layer 1 — OS
> e.g. custom Fedora Bootc Image

**=> [LeOS](https://github.com/LeonStoldt/LeOS)**

---

### Layer 2 — nix / home-manager
> organize tools, UI applications and development environment 'asCode'

Nix-Scripts to setup a fresh machine or keep existing setup updated.
The idea is that the OS delivers the minimal and basic tools and everything else is installed via nix.
That way, switching to a new OS can still use nix and dotfiles setup even though the base has changed.

```
home-manager switch --flake ~/setup/dotfiles/nix#leon
```

---

### Layer 3 — dotfiles
> personal and custom dotfiles

Keep personal flair and customizations in dotfiles, managed via [chezmoi](https://www.chezmoi.io/). This layer gets applied on top of everything installed to configure it the way you (or I) like it. The reason why I've decided for chezmoi (instead of e.g. nix-managed) is that chezmoi is well-established and does handle secrets nicely.

---

### Where to locate setup scripts: nix vs. chezmoi

The two tools overlap, so the split is by **question answered**, not by file type:

| | nix / home-manager (layer 2) | chezmoi (layer 3) |
|---|---|---|
| Answers | *What is installed on this machine?* | *How is it configured for me?* |
| Content | packages, toolchains, flatpaks, env vars | custom dotfiles and configurations, identity, aliases, secrets |
| Sharing | shareable as-is | personal |
| Secrets | **never** | yes, encrypted |

Examples:
- `~/.zshrc`, `~/.zshenv`, `~/.bashrc`, `~/.profile` → **chezmoi**.
  home-manager installs `zsh`, `oh-my-zsh`, `direnv`, `fzf` but every shell integration is configured with `enableZshIntegration = false`, so it never writes zsh config.
- `.zshrc`/`.bashrc` each source `hm-session-vars.sh` themselves to pick up the nix environment.
- `~/.gitconfig` → **chezmoi** (identity), but `~/.config/git/config` → **home-manager** (delta, rebase, prune, rerere). Git reads both and `~/.gitconfig` wins.
- `~/.ssh/*` → **chezmoi**
- `~/.config/niri`, `alacritty`, … → **chezmoi**. The programs themselves come from the **OS layer** and are customized via dotfiles.
