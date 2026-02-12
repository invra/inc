{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
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
            pkgs = import inputs.nixpkgs {
              inherit system;
              inherit (config.nixpkgs) config overlays;
            };

            modules = [
              (
                { darwin, ... }:
                {
                  nixpkgs.config = config.nixpkgs.config;
                  home = {
                    stateVersion = "25.11";
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
            inherit system;
            modules = [ cfg.module ];
          };
        };

        darwinConfigurations = lib.optionalAttrs isDarwin {
          "${name}" = inputs.nix-darwin.lib.darwinSystem {
            modules = [ cfg.module ];
          };
        };
      }
    ) config.configurations
  );
}
