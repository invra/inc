{
  self,
  lib,
  ...
}:
{
  flake.modules.darwin.base =
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
          mode.main.binding = {
            cmd-1 = "workspace 1";
            cmd-shift-1 = [
              "move-node-to-workspace 1"
              "workspace 1"
            ];
            cmd-2 = "workspace 2";
            cmd-shift-2 = [
              "move-node-to-workspace 2"
              "workspace 2"
            ];
            cmd-3 = "workspace 3";
            cmd-shift-3 = [
              "move-node-to-workspace 3"
              "workspace 3"
            ];
            cmd-4 = "workspace 4";
            cmd-shift-4 = [
              "move-node-to-workspace 4"
              "workspace 4"
            ];
            cmd-5 = "workspace 5";
            cmd-shift-5 = [
              "move-node-to-workspace 5"
              "workspace 5"
            ];
            cmd-6 = "workspace 6";
            cmd-shift-6 = [
              "move-node-to-workspace 6"
              "workspace 6"
            ];
            cmd-7 = "workspace 7";
            cmd-shift-7 = [
              "move-node-to-workspace 7"
              "workspace 7"
            ];
            cmd-8 = "workspace 8";
            cmd-shift-8 = [
              "move-node-to-workspace 8"
              "workspace 8"
            ];
            cmd-9 = "workspace 9";
            cmd-shift-9 = [
              "move-node-to-workspace 9"
              "workspace 9"
            ];
            alt-space = "layout floating tiling";
            alt-enter = "fullscreen";
            cmd-enter = "exec-and-forget ${pkgs.alacritty}/bin/alacritty";
            cmd-shift-s = "exec-and-forget screencapture -i -c";
            cmd-h = [ ];
            cmd-alt-h = [ ];
          };
        };
      };
    };

  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.sway = {
        enable = true;
        package = pkgs.swayfx;
      };
    };

  flake.modules.homeManager.base =
    {
      linux,
      pkgs,
      ...
    }:
    lib.optionalAttrs linux {
      wayland.windowManager.sway = let
        swaywpo = "${self.packages.${pkgs.stdenv.system}.swaywpo}/bin/swaywpo";
      in {
        enable = true;
        package = pkgs.swayfx;
        checkConfig = false;
        config = {
          modifier = "Mod4";
          output."*".bg = "${../wallpapers/flake.jpg} fill";
          gaps = {
            inner = 10;
            outer = 10;
          };
          window = {
            border = 5;
            titlebar = false;
            commands = [
              {
                criteria.title = "Picture-in-Picture";
                command = "floating enable, resize set width 700 height 400, sticky enable";
              }
            ];
          };
          colors =
            let
              mkColorSet = color: {
                border = color;
                background = color;
                childBorder = color;
                indicator = color;
                text = color;
              };
            in
            lib.mkForce {
              focused = mkColorSet "#ebbcbaff";
              unfocused = mkColorSet "#00000000";
              focusedInactive = mkColorSet "#00000000";
              urgent = mkColorSet "#eb6f92ff";
            };
          keybindings = {
            # Compositor embeded bindings
            #   E.g kill active client, switch spaces.
            "Mod4+f1" = "reload";
            "Mod4+f4" = "exit";
            "Mod1+Return" = "fullscreen";
            "Mod4+q" = "kill";

            "Mod4+1" = "exec ${swaywpo} workspace 1";
            "Mod4+Shift+1" = "exec ${swaywpo} move-container-to-workspace 1";
            "Mod4+2" = "exec ${swaywpo} workspace 2";
            "Mod4+Shift+2" = "exec ${swaywpo} move-container-to-workspace 2";
            "Mod4+3" = "exec ${swaywpo} workspace 3";
            "Mod4+Shift+3" = "exec ${swaywpo} move-container-to-workspace 3";
            "Mod4+4" = "exec ${swaywpo} workspace 4";
            "Mod4+Shift+4" = "exec ${swaywpo} move-container-to-workspace 4";
            "Mod4+5" = "exec ${swaywpo} workspace 5";
            "Mod4+Shift+5" = "exec ${swaywpo} move-container-to-workspace 5";

            # Exec bindings
            #   Ones which will do an external action not
            #   directly tied to sway.
            "Mod4+Return" = "exec alacritty";
            "Mod4+Space" = "exec ${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
            "Mod4+Shift+s" = "exec ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only";
            "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5";
            "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggleI";
          };
          startup = [
            { command = "${pkgs.eww}/bin/eww open bar0"; }
            { command = "${pkgs.eww}/bin/eww open bar1"; }
            { command = "systemctl --user restart xdg-desktop-portal-wlr"; }
          ];
        };
        extraConfig = ''
          corner_radius 12
        '';
      };
    };
}
