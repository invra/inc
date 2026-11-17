{
  inputs,
  lib,
  ...
}:
{
  flake.modules.homeManager.base = { linux, ... }: lib.optionalAttrs linux {
    imports = [
      inputs.noctalia.homeModules.default
    ];
    programs.noctalia = {
      enable = true;
      settings = {
        bar = {
          default = {
            start = [ "launcher" "workspaces" ];
            center = [ "active_window" ];
            end = [ "tray" "network" "clock" "session" ];
            margin_ends = 0;
            margin_edge = 0;
            background_opacity = 0.15;
            padding = 15;
            position = "top";
            thickness = 42;
          };
        };
        shell = {
          font_family = "IBM Plex";
          telemetry_enabled = false;
          polkit_agent = true;
          password_style = "random";
          show_close_buttons = false;
          launcher = {
            default_view = "all";
            show_app_actions = true;
          };
          panel.transparency_mode = "glass";
          umbriel_audio_provider_enabled = true;
        };
        theme = {
          source = "builtin";
          builtin = "Rosé Pine";
          templates.builtin_ids = [ "foot" "gtk3" "gtk4" "kcolorscheme" "umbriel" ];
        };
        wallpaper = {
          directory = ../wallpapers;
          default.path = ../wallpapers/flake.jpg;
          transition_on_startup = true;
        };
      };
    };
  };
}
