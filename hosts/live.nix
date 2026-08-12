{ pkgs, lib, modulesPath, ... }:
{
  # Start from the official minimal installer and add your live ISO changes below.
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  system.stateVersion = "25.05";

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
}
