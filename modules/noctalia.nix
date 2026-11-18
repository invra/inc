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
        widget = {
          media.art_size = 28;
          active_window.icon_size = 22;
          sysmon = {
            visualization = "graph";

          };
        };
        bar = {
          default = {
            start = [ "launcher" "workspaces" "media" "audio_visualizer" ];
            center = [ "active_window" ];
            end = [ "tray" "ram" "cpu" "volume" "clock" "session" ];
            margin_ends = 0;
            margin_edge = 0;
            widget_spacing = 24;
            background_opacity = 0.15;
            padding = 15;
            position = "top";
            thickness = 42;
          };
        };
        osd = {
          position = "bottom_center";
          offset_y = 30;
        };
        notification = {
          width = 400;
          offset_x = 15;
          offset_y = 15;
          filter.spotify = {
            play_sound = false;
            filter = "spotify";
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
          panel = {
            transparency_mode = "glass";
            floating_offset = 20;
          };
          launcher = {
            show_icons = false;
            categories = false;
          };
          screenshot.save_to_file = false;
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
