{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- version control / review ---
    git
    git-lfs
    gh
    delta # git-delta

    # --- secrets / crypto ---
    age
    sops
    gnupg

    # --- shell UX / CLI tools ---
    vim
    bat
    htop
    btop
    fzf
    ripgrep
    fd
    eza
    jq
    yq-go
    just
    lftp
    p7zip
    unzip
    zip
    wl-clipboard
    shellcheck
    shfmt
    nixfmt
    tree
    lazygit
    lazyssh
    lazysql
    lazydocker

    # --- python ---
    python3
    python3Packages.pip
    python3Packages.virtualenv

    # --- containers ---
    docker
    podman-compose

    # --- infra ---
    ansible
    terraform
    google-cloud-sdk

    # --- development ---
    maven
    jdk25
    go
    nodejs_26
    yarn
  ];

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    GOPATH = "$HOME/go";
  };
}
