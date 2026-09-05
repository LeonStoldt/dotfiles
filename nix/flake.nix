{
  description = "Layer 2 — nix/home-manager: development configuration and flatpaks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHome = username: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit jdks username; };
        modules = [
          nix-flatpak.homeManagerModules.nix-flatpak
          #./shared
          (./. + "/${username}")
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }
        ];
      };
    in
    {
      # home-manager switch --flake ~/dev/machine-config/nix#leon
      homeConfigurations.leon = mkHome "leon";
      # home-manager switch --flake ~/dev/machine-config/nix#<USERNAME>
      # homeConfigurations.<USERNAME> = mkHome "<USERNAME>";

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
