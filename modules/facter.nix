{ inputs, lib, ... }:
{
  flake.modules = {
    nixos.base = {
      imports = [ inputs.nixos-facter-modules.nixosModules.facter ];
      facter.detected.dhcp.enable = false;
    };

    homeManager.base =
      { pkgs, linux, ... }:
      lib.optionalAttrs linux {
        home.packages = with pkgs; [ nixos-facter ];
      };
  };
}
