{
  lib,
  inputs,
  ...
}:
let
  mkWorkspaceControls = lib.mergeAttrsList (
    map (
      n:
      let
        num = toString n;
      in
      {
        "alt-${num}" = "workspace ${num}";
        "alt-shift-${num}" = "move-node-to-workspace ${num}";
      }
    ) (lib.range 1 9)
  );
in
{
  flake.modules = {
    darwin.base =
      { pkgs, ... }:
      {
        system.defaults.dock = {
          autohide = true;
          orientation = "bottom";
          show-recents = false;
          tilesize = 48;
          slow-motion-allowed = true;

          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
        };
        services.aerospace = {
          enable = true;
          settings = {
            gaps = {
              inner = {
                horizontal = 12;
                vertical = 12;
              };
              outer = {
                left = 10;
                right = 10;
                top = 10;
                bottom = 10;
              };
            };
            after-startup-command = [
              "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=0xebbcbaff inactive_color=0x00000000 width=10.0"
            ];
            workspace-to-monitor-force-assignment = {
              "1" = "main";
              "2" = "main";
              "3" = "main";
              "4" = "main";
              "5" = "main";
              "6" = "secondary";
              "7" = "secondary";
              "8" = "secondary";
              "9" = "secondary";
              "0" = "secondary";
            };
            mode.main.binding = {
              alt-space = "layout floating tiling";
              alt-enter = "fullscreen";
              cmd-enter = "exec-and-forget ${pkgs.ghostty-bin}/bin/ghostty";
              cmd-backslash = "exec-and-forget ${pkgs.emacs}/bin/emacs";
              cmd-shift-s = "exec-and-forget screencapture -i -c";
              alt-b = "exec-and-forget open -na helium";
              cmd-h = [ ];
              cmd-alt-h = [ ];
            }
            // mkWorkspaceControls;
          };
        };
      };

    nixos.base = {
      imports = [
        inputs.umbriel.nixosModules.default
      ];

      programs.umbriel.enable = true;
      services.desktopManager.plasma6.enable = true;
    };

    homeManager.base =
      {
        linux,
        pkgs,
        ...
      }:
      lib.optionalAttrs linux {
        imports = [
          inputs.umbriel.homeModules.default
        ];

        programs.umbriel = {
          enable = true;

          settings = {
            include.optional.files = [ "~/.config/umbriel/noctalia.toml" ];
            general = {
              autostart = [
                "noctalia"
              ];
              mod_key = "Alt";
              xwayland = true;
              xwayland_native_resolution = true;
              show_cheatsheet = true;
              focus_on_activate = true;
              honor_restored_maximize = true;
            };

            appearance = {
              prefer_no_csd = true;
              border_width = 3;
              corner_radius = 10;
              blur = {
                enabled = true;
                optimized = true;
                passes = 3;
                radius = 5;
                noise = 0.02;
                contrast = 0.9;
                saturation = 1.1;
              };
              title_bar.mode = "off";
              shadow.enabled = false;
            };

            input = {
              client_window_drag = true;
              keyboard.numlock_toggle = true;
              touchpad = {
                tap = true;
                natural_scroll = true;
                accel_profile = "flat";
                disable_while_typing = false;
                disable_on_external_mouse = false;
              };
              keyboard = {
                layout = "us,us";
                variant = ",workman";
                options = "caps:escape";
                repeat_rate = 50;
                repeat_delay = 200;
              };
              focus.follows_mouse = "always";
              cursor.hide_timeout_ms = 6000;
              drag_edge_scroll.enabled = false;
            };

            keybinds = {
              "Mod+Shift+F4" = "session-quit";
              "Mod+Return" = "window-toggle-fullscreen";
              "Mod+Space" = "window-toggle-floating";
              "Mod+Shift+Up" = "keyboard-layout-next";
              "Mod+Q" = "window-close";

              "XF86AudioPlay" = "spawn ${pkgs.playerctl}/bin/playerctl play-pause";
              "XF86AudioNext" = "spawn ${pkgs.playerctl}/bin/playerctl next";
              "XF86AudioPrev" = "spawn ${pkgs.playerctl}/bin/playerctl previous";
              "XF86AudioRaiseVolume" = "spawn ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5";
              "XF86AudioLowerVolume" = "spawn ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioMute" = "spawn ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "XF86AudioMicMute" = "spawn ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              "XF86MonBrightnessUp" = "spawn ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
              "XF86MonBrightnessDown" = "spawn ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

              "Super+Space" = "spawn ${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
              "Super+Shift+S" = "spawn ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only";
              "Super+Return" = "spawn ${pkgs.ghostty}/bin/ghostty";
              "Super+F" = "spawn ${pkgs.nautilus}/bin/nautilus";
              "Mod+B" = "spawn xdg-open https:";

              "Mod+1" = "workspace-switch 1";
              "Mod+2" = "workspace-switch 2";
              "Mod+3" = "workspace-switch 3";
              "Mod+4" = "workspace-switch 4";
              "Mod+5" = "workspace-switch 5";
              "Mod+6" = "workspace-switch 6";
              "Mod+7" = "workspace-switch 7";
              "Mod+8" = "workspace-switch 8";
              "Mod+9" = "workspace-switch 9";
              "Mod+Shift+1" = "window-move-to-workspace-silent 1";
              "Mod+Shift+2" = "window-move-to-workspace-silent 2";
              "Mod+Shift+3" = "window-move-to-workspace-silent 3";
              "Mod+Shift+4" = "window-move-to-workspace-silent 4";
              "Mod+Shift+5" = "window-move-to-workspace-silent 5";
              "Mod+Shift+6" = "window-move-to-workspace-silent 6";
              "Mod+Shift+7" = "window-move-to-workspace-silent 7";
              "Mod+Shift+8" = "window-move-to-workspace-silent 8";
              "Mod+Shift+9" = "window-move-to-workspace-silent 9";
            };

            layout = {
              mode = "dwindle";
              gap = 12;
            };

            output.DP-3 = {
              workspaces = [ "1" "2" "3" "4" "5" ];
              workspace_axis = "horizontal";
              mode = "2560x1440@200";
            };

            window_rule = [
              {
                match.title = "Picture-in-picture";
                default_pinned = true;
                default_floating = true;
                default_floating_size = {
                  width = 0.3;
                  height = 0.3;
                };
                default_position = {
                  x = 10;
                  y = 10;
                  anchor = "bottom_right";
                };
                opacity = 1;
                title_bar = "off";
              }
            ];

            layer_rule = [
              {
                match.namespace = "launcher";
                blur = true;
              }
              {
                match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
                blur = true;
                blur_ignore_alpha = 0.1;
                blur_popups = true;
                blur_optimized = false;
              }
            ];

            animation = {
              duration_ms = 150;
              layers.enabled = true;
            };
          };
        };
      };
  };
}
