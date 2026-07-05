{
  description = "An opinionated palette for nix-canvas: a software catalog (each app defined once), composable wants, looks, reusable Home Manager modules and the synthppuccin theme engine.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    canvas.url = "github:theferrer/nix-canvas";
    canvas.inputs.nixpkgs.follows = "nixpkgs";

    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
    dms.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      canvas,
      dms,
      nixvim,
      nix-index-database,
      home-manager,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      flakeModules = {
        dmsModule = dms.homeModules.dank-material-shell;
        nixvimModule = nixvim.homeModules.nixvim;
        commaModule = nix-index-database.homeModules.nix-index;
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );
    in
    {
      nixosModules.default = import ./modules/nixos.nix flakeModules;

      overlays.default = import ./overlays;

      homeModules = {
        default = import ./modules/home.nix flakeModules;

        themes = import ./theme/engine;
        xdg = import ./shared/xdg;
        audio = import ./shared/audio;
      };

      checks = forAllSystems (
        pkgs:
        (import ./tests {
          inherit
            pkgs
            lib
            canvas
            home-manager
            ;
          inherit (flakeModules) dmsModule nixvimModule commaModule;
        })
        // {
          statix = pkgs.runCommand "palette-statix" { } ''
            ${pkgs.statix}/bin/statix check ${./.}
            echo ok > $out
          '';
          deadnix = pkgs.runCommand "palette-deadnix" { } ''
            ${pkgs.deadnix}/bin/deadnix --fail ${./.}
            echo ok > $out
          '';
          formatting = pkgs.runCommand "palette-formatting" { } ''
            ${pkgs.nixfmt}/bin/nixfmt --check $(find ${./.} -name '*.nix')
            echo ok > $out
          '';
        }
      );

      formatter = forAllSystems (pkgs: pkgs.nixfmt);

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.nixfmt
            pkgs.nil
            pkgs.statix
            pkgs.deadnix
          ];
        };
      });
    };
}
