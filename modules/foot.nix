{ lib, ... }:
{
  flake.modules.homeManager.base =
    { linux, ... }:
    {
      programs.foot = lib.optionalAttrs linux {
        enable = true;
        server.enable = true;

        settings = with lib; {
          main.font = mkForce "JetBrainsMono Nerd Font:size=14";

          colors.alpha = mkForce 0.85;
        };
      };
    };
}
