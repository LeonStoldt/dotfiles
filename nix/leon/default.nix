{ ... }:
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./flatpak.nix
  ];
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  systemd.user.startServices = "suggest";
}
