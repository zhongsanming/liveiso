{
  description = "Minimal NixOS live ISO built from a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      liveModule = { pkgs, lib, modulesPath, ... }:
        {
          # Start from the official minimal installer and add your live ISO changes below.
          imports = [
            "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
          ];

          system.stateVersion = "26.05";

          users.users.root.password = "nixos";

          boot.kernelPackages = pkgs.linuxPackages_latest;
          boot.supportedFilesystems = lib.mkForce [
            "btrfs"
            "ext4"
            "f2fs"
            "vfat"
            "xfs"
            "ntfs"
            "cifs"
          ];

          networking.hostName = "nixos-live";
          networking.networkmanager.enable = lib.mkDefault true;
          networking.wireless.enable = false;

          environment.systemPackages = with pkgs; [
            git
            nixos-install-tools
            vim
            tmux
            fish
            helix
          ];

          isoImage.makeEfiBootable = true;
          isoImage.makeUsbBootable = true;
        };

      modules = [ liveModule ];

      buildIso = system:
        (nixpkgs.lib.nixosSystem {
          inherit system modules;
        }).config.system.build.isoImage;
    in
    {
      packages = forAllSystems (system: {
        default = buildIso system;
        live = buildIso system;
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
