{
  lib,
  inputs,
  config,
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

  config = {
    flake.meta.nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;

    flake.modules.nixos.base = nixosArgs: {
      nix.nixPath = [
        "nixpkgs=${nixosArgs.config.nixpkgs.flake.source}"
      ];
      nixpkgs = {
        pkgs = import inputs.nixpkgs {
          inherit (nixosArgs.config.facter.report) system;
          inherit (config.nixpkgs) overlays;
          
          config.allowUnfreePredicate =
            pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
        };
        hostPlatform = nixosArgs.config.facter.report.system;
      };
    };

    flake.modules.homeManager.base.nixpkgs = {
      config = {
        inherit (config.nixpkgs) overlays;
        allowUnfreePredicate =
          pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
      };
    };

    flake.modules.darwin.base = args: {
      nix.nixPath = [
        "nixpkgs=${args.config.nixpkgs.flake.source}"
      ];
      nixpkgs = {
        pkgs = import inputs.nixpkgs {
          system = "aarch64-darwin";
          inherit (config.nixpkgs) overlays;
          
          config.allowUnfreePredicate =
            pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
        };
        hostPlatform = "aarch64-darwin";
      };
    };
  };
}
