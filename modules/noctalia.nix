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
        control_center.media.show_visualizer = false;
        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;

          widget_order = [
            "lockscreen-login-box@DP-3"
            "lockscreen-login-box@WL-1"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000002"
            "lockscreen-widget-0000000000000003"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget = {
            "lockscreen-login-box@DP-3" = {
              box_height = 70.0;
              box_width = 400.0;
              cx = 1280.0;
              cy = 1264.0;
              output = "DP-3";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_container";
                background_opacity = 0.0;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 12.0;
                layout = "compact";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = false;
                show_media_controls = false;
                show_password_reveal = false;
                show_session_buttons = false;
                show_unlock_hint = true;
                show_weather = false;
              };
            };

            "lockscreen-login-box@WL-1" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 628.0;
              cy = 1228.0;
              output = "WL-1";
              placement_height = 1410.0;
              placement_width = 1256.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_container";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_media_controls = true;
                show_password_reveal = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-widget-0000000000000001" = {
              box_height = 128.0;
              box_width = 384.0;
              cx = 1280.0;
              cy = 272.0;
              output = "DP-3";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "clock";

              settings.background = false;
            };

            "lockscreen-widget-0000000000000002" = {
              box_height = 128.0;
              box_width = 384.0;
              cx = 1280.0;
              cy = 432.0;
              output = "DP-3";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "media_player";

              settings = {
                background = false;
                background_opacity = 0.0;
              };
            };

            "lockscreen-widget-0000000000000003" = {
              box_height = 64.0;
              box_width = 384.0;
              cx = 1280.0;
              cy = 576.0;
              output = "DP-3";
              placement_height = 1440.0;
              placement_width = 2560.0;
              rotation = 0.0;
              type = "audio_visualizer";

              settings = {
                background = false;
                bands = 32;
                show_when_idle = true;
              };
            };
          };
        };
        lockscreen = {
          transition = [ "fade" ];
          transition_duration = 250;
        };
        widget = {
          media.art_size = 28;
          active_window.icon_size = 22;
          sysmon.visualization = "graph";
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
            floating_offset = 15;
          };
          launcher = {
            show_icons = false;
            categories = false;
            layout = "simple";
            compact = true;
          };
          screenshot = {
            save_to_file = false;

            region_dim_opacity = 0.3;
            show_region_dimensions = false;
          };
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
