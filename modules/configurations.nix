{
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    configurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options.module = lib.mkOption {
            type = lib.types.deferredModule;
          };
        }
      );
    };
    nixpkgs = {
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
  };

  config.flake = lib.foldl' lib.recursiveUpdate { } (
    lib.mapAttrsToList (
      name: cfg:
      let
        isDarwin = lib.hasPrefix "mac" name;

        system =
          if isDarwin then
            "aarch64-darwin"
          else if lib.hasSuffix "x86" name then
            "x86_64-linux"
          else if lib.hasSuffix "aarch64" name then
            "aarch64-linux"
          else
            "x86_64-linux";

        isLinux = lib.hasSuffix "linux" system;

        extraSpecialArgs = {
          inherit inputs;
          linux = isLinux;
          darwin = isDarwin;
        };
      in
      {
        homeConfigurations = lib.optionalAttrs (system != "") {
          "${name}" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs { inherit system; };

            modules = [
              (
                { darwin, ... }:
                {
                  nixpkgs.config = {
                    inherit (config.nixpkgs) overlays;
                    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
                  };
                  home = {
                    stateVersion = "26.05";
                    username = config.flake.meta.owner.username;
                    homeDirectory =
                      if darwin then
                        "/Users/${config.flake.meta.owner.username}"
                      else
                        "/home/${config.flake.meta.owner.username}";
                  };
                  programs.home-manager.enable = true;
                  systemd.user.startServices = "sd-switch";
                }
              )
              config.flake.modules.homeManager.base
            ];
            inherit extraSpecialArgs;
          };
        };

        nixosConfigurations = lib.optionalAttrs isLinux {
          "${name}" = lib.nixosSystem {
            modules = [
              (args: {
                nix.nixPath = [
                  "nixpkgs=${args.config.nixpkgs.flake.source}"
                ];
                nixpkgs = {
                  pkgs = import inputs.nixpkgs {
                    inherit (args.config.facter.report) system;
                    inherit (config.nixpkgs) overlays;
                    inherit (config.nixpkgs) allowUnfreePredicate;

                    config.allowUnfreePredicate =
                      pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
                  };
                  hostPlatform = args.config.facter.report.system;
                };
              })
              cfg.module
            ];
          };
        };

        darwinConfigurations = lib.optionalAttrs isDarwin {
          "${name}" = inputs.nix-darwin.lib.darwinSystem {
            modules = [
              (args: {
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
              })
              cfg.module
            ];
          };
        };
      }
    ) config.configurations
  );
}
