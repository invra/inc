{
  lib,
  self,
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

    nixos.base =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          river
          self.packages.${stdenv.system}.beansprout   
        ];
        services.desktopManager.plasma6.enable = true;
      };

    homeManager.base =
      {
        linux,
        pkgs,
        ...
      }:
      lib.optionalAttrs linux {
        xdg.configFile = {
          "river/init" = {
            text = ''
              #!/bin/bash
              ${self.packages.${pkgs.stdenv.system}.beansprout}/bin/beansprout &
              eww open bar0
              eww open bar1
            '';
            executable = true;
          };
          "beansprout/config.kdl".text = ''
            attach_mode top
            primary_count 1
            primary_ratio 0.55
            single_window_ratio 1.0
            primary_side left 
            focus_follows_pointer #true
            output_focus_follows_pointer #true
            pointer_warp_on_focus_change #true
            focus_on_send if_visible

            wallpaper_image_path "~/.config/nix/wallpapers/flake.jpg"

            borders {
              width 2
              color_focused "0x89b4fa"
              color_unfocused "0x1e1e2e"
            }
            window_rules {
              float title="Picture-in-picture"
              float title="Picture-in-Picture"
              float title="*Preferences*"
            }
            keybinds {
              spawn Mod4 Return ghostty
              spawn Mod1 B "xdg-open about://blank"
              spawn Mod4 Space "tofi-drun --drun-launch=true"
              spawn Mod1+Shift S "hyprshot -m region --clipboard-only"
              focus_next_window Mod4 J
              focus_prev_window Mod4 K
              focus_next_output Mod1 Period
              focus_prev_output Mod1 Comma
              send_to_next_output Mod4+Shift Period
              send_to_prev_output Mod4+Shift Comma
              zoom Mod4 Z
              toggle_float Mod1 F
              change_primary_ratio Mod4 H 0.05
              change_primary_ratio Mod4 L -0.05
              increment_primary_count Mod4 I
              decrement_primary_count Mod4 D
              reload_config Mod1 F1
              toggle_fullscreen Mod1 Return
              close_window Mod1 Q
              exit_river Mod1+Shift F4
              swap_next Mod4+Shift N
              swap_prev Mod4+Shift P
              move_left Mod4+Shift H 100
              move_down Mod4+Shift J 100
              move_up Mod4+Shift K 100
              move_right Mod4+Shift L 100
              resize_width Mod1 H -100
              resize_height Mod1 J 100
              resize_height Mod1 K -100
              resize_width Mod1 L 100

              spawn None XF86AudioRaiseVolume "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5"
              spawn None XF86AudioLowerVolume "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              spawn None XF86AudioMute "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              spawn None XF86AudioMedia "playerctl play-pause"
              spawn None XF86AudioPlay "playerctl play-pause"
              spawn None XF86AudioPrev "playerctl previous"
              spawn None XF86AudioNext "playerctl next"

              tag_bind Mod1 set_output_tags
              tag_bind Mod1+Shift set_window_tags
              tag_bind Mod1+Ctrl toggle_output_tags
              tag_bind Mod1+Ctrl+Shift toggle_window_tags
            }

            pointer_binds {
              move_window Mod4 BTN_LEFT
              resize_window Mod4 BTN_RIGHT
            }

            keyboard_layout {
              layout "us,us"
              variant ",workman"
              options "grp:caps_toggle"
            }

            input {
              accel_profile "flat"
            }
          '';
        };
      };
  };
}
