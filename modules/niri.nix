{
  lib,
  # inputs,
  ...
}:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [
        # inputs.niri.nixosModules.niri
      ];
      programs.niri = {
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];
    };

  flake.modules.homeManager.base =
    {
      # pkgs,
      linux,
      ...
    }:
    lib.optionalAttrs linux {
    };
}
