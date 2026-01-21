{ lib, ... }:
{
  flake.modules.homeManager.base =
    { linux, darwin, ... }:
    {
      programs.foot = lib.optionalAttrs linux {
        enable = true;
        server.enable = true;

        settings = with lib; {
          main.font = mkForce "JetBrainsMono Nerd Font:size=14";

          colors.alpha = mkForce 0.85;
        };
      };
      
      programs.alacritty = lib.optionalAttrs darwin {
        enable = true;
      };
    };
}
