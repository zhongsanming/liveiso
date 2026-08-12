{
  description = "Minimal NixOS live ISO built from a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      modules = [ ./hosts/live.nix ];

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
