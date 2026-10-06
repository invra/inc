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

    nixos.base =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          mangowc
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
        imports = [
          inputs.mangowm.hmModules.mango
        ];

        wayland.windowManager.mango = {
          enable = true;
          systemd.enable = true;

          settings = {          
            exec_once = [
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots"
              "systemctl --user restart xdg-desktop-portal"
              "systemctl --user restart xdg-desktop-portal-wlr"
              "${pkgs.eww}/bin/eww open bar0"
              "${pkgs.eww}/bin/eww open bar1"
              "${pkgs.mako}/bin/mako"
              "${pkgs.swaybg}/bin/swaybg"
            ];

            exec = [
              "${pkgs.swaybg}/bin/swaybg --image ${../wallpapers/flake.jpg}"
            ];
                        
            blur = "0";
            blur_layer = "0";
            blur_optimized = "1";
            blur_params_num_passes = 2;
            blur_params_radius = 5;
            blur_params_noise = 0.02;
            blur_params_brightness = 0.9;
            blur_params_contrast = 0.9;
            blur_params_saturation = 1.2;
            
            border_px = "4";
            border_radius = "15";
            no_radius_when_single = "0";
            focused_opacity = "1.0";
            unfocused_opacity = "0.9";

            gap_inner_horizontal = "10";
            gap_inner_vertical = "10";
            gap_outer_horizontal = "10";
            gap_outer_vertical = "10";
            scratchpad_width_ratio = "0.8";
            scratchpad_height_ratio = "0.9";
            root_color = "0x201b14ff";
            border_color = "0x00000000";
            focus_color = "0xebbcbaff";
            maximized_screen_color = "0xf6c177ff";
            urgent_color = "0xeb6f92ff";
            scratchpad_color = "0x31748fff";
            global_color = "0xc4a7e7ff";
            overlay_color = "0x9ccfd8ff";

            xkb_rules_layout="us,us";
            xkb_rules_variant=",workman";
            xkb_rules_options="grp:lalt_lshift_toggle";
           
            bind = [
              "Alt+Shift,F4,quit"
              "Alt,q,killclient,"

              "Super,R,reload_config"

              "NONE,XF86AudioPlay,spawn,${pkgs.playerctl}/bin/playerctl play-pause"
              "NONE,XF86AudioNext,spawn,${pkgs.playerctl}/bin/playerctl next"
              "NONE,XF86AudioPrev,spawn,${pkgs.playerctl}/bin/playerctl previous"
              "NONE,XF86AudioRaiseVolume,spawn,${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5"
              "NONE,XF86AudioLowerVolume,spawn,${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              "NONE,XF86AudioMute,spawn,${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              "NONE,XF86AudioMicMute,spawn,${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              "NONE,XF86MonBrightnessUp,spawn,${pkgs.brightnessctl}/bin/brightnessctl set +5%"
              "NONE,XF86MonBrightnessDown,spawn,${pkgs.brightnessctl}/bin/brightnessctl set 5%-"

              "Super,space,spawn,${pkgs.tofi}/bin/tofi-drun --drun-launch=true"
              "Super+SHIFT,S,spawn,${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only"
              "Super,Return,spawn,${pkgs.ghostty}/bin/ghostty"
              "Super,F,spawn,${pkgs.nautilus}/bin/nautilus"
              "Alt,B,spawn,xdg-open https:"

              "Super,g,toggleglobal,"
              "ALT,Tab,toggleoverview,"
              "ALT,space,togglefloating,"
              "ALT,Return,togglefullscreen,"

              "Alt,1,view,1,0"
              "Alt,2,view,2,0"
              "Alt,3,view,3,0"
              "Alt,4,view,4,0"
              "Alt,5,view,5,0"
              "CTRL+Super,Left,viewtoleft,0"
              "CTRL+Super,Right,viewtoright,0"

              "Alt+Shift,1,tag,1,0"
              "Alt+Shift,2,tag,2,0"
              "Alt+Shift,3,tag,3,0"
              "Alt+Shift,4,tag,4,0"
              "Alt+Shift,5,tag,5,0"
            ];
            
            mousebind = [
              "Super,btn_left,moveresize,curmove"
              "Super,btn_right,moveresize,curresize"
            ];
            
            layer_rule = [
              "animation_type_open:zoom,layer_name:tofi-drun"
              "animation_type_close:zoom,layer_name:tofi-drun"
            ];

            window_rule = [
              "is_floating:1,height:398,width:700,offset_y:99,offset_x:99,is_global:1,is_overlay:1,title:Picture-in-Picture"
            ];
          };
        };
      };
  };
}
