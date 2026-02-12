{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
{
  options.nixpkgs = {
    config = {
      allowUnfreePredicate = lib.mkOption {
        type = lib.types.functionTo lib.types.bool;
        default = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
      };
    };
    overlays = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      default = [ ];
    };
    allowedUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
      default = [ ];
    };
  };

  config = rec {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;

    flake.meta.nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;

    perSystem =
      { system, ... }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          inherit (config.nixpkgs) config overlays;
        };
      };

    flake.modules.nixos.base = nixosArgs: {
      nix.nixPath = [
        "nixpkgs=${nixosArgs.config.nixpkgs.flake.source}"
      ];
      nixpkgs = {
        pkgs = withSystem nixosArgs.config.facter.report.system (psArgs: psArgs.pkgs);
        hostPlatform = nixosArgs.config.facter.report.system;
      };
    };

    flake.modules.homeManager.base.nixpkgs.config.allowUnfree = true;

    flake.modules.darwin.base = args: {
      nix.nixPath = [
        "nixpkgs=${args.config.nixpkgs.flake.source}"
      ];
      nixpkgs = {
        pkgs = import inputs.nixpkgs {
          system = "aarch64-darwin";
          inherit (config.nixpkgs) config overlays;
        };
        hostPlatform = "aarch64-darwin";
      };
    };
  };
}
