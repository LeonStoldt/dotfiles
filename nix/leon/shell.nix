{ pkgs, ... }:

# Shell-adjacent *programs*, not shell *configuration*.
{
  home.packages = with pkgs; [
    zsh
    # Sourced by ~/.zshrc from $HOME/.nix-profile/share/... — see dot_zshrc
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting

    chezmoi
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # caches evaluation; keeps a GC root
    enableZshIntegration = false; # ~/.zshrc is chezmoi's (see note above)
    enableBashIntegration = false;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      diff.colorMoved = "default";
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;
    };
  };
}
