{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
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
    {
      config = lib.optionalAttrs linux {
        xdg = {
          enable = true;
          mime.enable = true;
          terminal-exec = {
            enable = true;
            settings = {
              default = [ "foot.desktop" ];
            };
          };
          mimeApps = {
            enable = true;
            defaultApplications = {
              "text/html" = "librewolf.desktop";
              "x-scheme-handler/http" = "librewolf.desktop";
              "x-scheme-handler/https" = "librewolf.desktop";
              "x-scheme-handler/about" = "librewolf.desktop";
              "x-scheme-handler/unknown" = "librewolf.desktop";
            };
          };

          userDirs = {
            enable = true;
            createDirectories = true;

            desktop = "${config.home.homeDirectory}/desk";
            documents = "${config.home.homeDirectory}/docs";
            download = "${config.home.homeDirectory}/downloads";
            music = "${config.home.homeDirectory}/music";
            pictures = "${config.home.homeDirectory}/pics";
            publicShare = "${config.home.homeDirectory}/pub";
            templates = "${config.home.homeDirectory}/templates";
            videos = "${config.home.homeDirectory}/vids";
          };
        };

        home.packages = with pkgs; [
          xdg-utils
        ];
      };
    };
}
