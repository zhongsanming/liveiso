{
  description = "Minimal NixOS live ISO built from a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      modules = [ ./hosts/live.nix ];

      buildIso = system: format: nixos-generators.nixosGenerate {
        inherit system format;
        inherit modules;
      };
    in {
      packages = forAllSystems (system: {
        live = buildIso system "iso";
        installer = buildIso system "install-iso";
        default = buildIso system "iso";
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
