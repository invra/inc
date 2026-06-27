{ lib, ... }:
{
  flake.modules.nixos.base = {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      config = {
        preferred = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
      };
    };
  };
  flake.modules.homeManager.base =
    {
      config,
      pkgs,
      linux,
      ...
    }:
    lib.optionalAttrs linux {
      xdg = {
        enable = true;
        mime.enable = true;
        terminal-exec = {
          enable = true;
          settings = {
            default = [ "ghostty.desktop" ];
          };
        };

        userDirs = {
          enable = true;
          createDirectories = true;

          desktop = "${config.home.homeDirectory}/desk";
          documents = "${config.home.homeDirectory}/docs";
          download = "${config.home.homeDirectory}/dwn";
          music = "${config.home.homeDirectory}/music";
          pictures = "${config.home.homeDirectory}/pics";
          publicShare = "${config.home.homeDirectory}/pub";
          projects = "${config.home.homeDirectory}/proj";
          templates = "${config.home.homeDirectory}/templates";
          videos = "${config.home.homeDirectory}/vids";
        };
      };

      home.packages = with pkgs; [
        xdg-utils
      ];
    };
}
