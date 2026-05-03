{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ ungoogled-chromium ];
    };
  flake.modules.homeManager.base =
    {
      linux,
      ...
    }:
    {
      programs = {
        chromium = {
          enable = true;
          extensions = [
            # ublock
            { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
          ];
        };
      };
    }
    // lib.optionalAttrs linux {
      wayland.windowManager.sway.config.keybindings."Mod4+b" = "exec xdg-open about://blank";
    };
}
