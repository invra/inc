{
  self,
  lib,
  ...
}:
let
  mkWorkspaceControls =
    {
      mod ? "alt",
      command ? "",
      aerospace ? false,
    }:
    lib.mergeAttrsList (
      map (
        n:
        let
          num = toString n;
          sep = if aerospace then "-" else "+";
        in
        {
          "${mod}${sep}${num}" = "${command} workspace ${num}";
          "${mod}${sep}shift${sep}${num}" = "${command} move-${
            if aerospace then "node" else "container"
          }-to-workspace ${num}";
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
            mode.main.binding = {
              alt-space = "layout floating tiling";
              alt-enter = "fullscreen";
              cmd-enter = "exec-and-forget ${pkgs.ghostty-bin}/bin/ghostty";
              cmd-backslash = "exec-and-forget ${pkgs.emacs}/bin/emacs";
              cmd-shift-s = "exec-and-forget screencapture -i -c";
              cmd-h = [ ];
              cmd-alt-h = [ ];
            }
            // mkWorkspaceControls { aerospace = true; };
          };
        };
      };

    nixos.base =
      { pkgs, ... }:
      {
        programs.sway = {
          enable = true;
          package = pkgs.swayfx;
        };
      };

    homeManager.base =
      {
        linux,
        pkgs,
        ...
      }:
      lib.optionalAttrs linux {
        wayland.windowManager.sway = {
          enable = true;
          package = pkgs.swayfx;
          systemd.enable = true;
          checkConfig = false;
          config = {
            modifier = "Mod4";
            output."*".bg = "${../wallpapers/flake.jpg} fill";
            gaps = {
              inner = 10;
              outer = 10;
            };
            window = {
              border = 3;
              titlebar = false;
              commands = [
                {
                  criteria.title = "Picture-in-picture";
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
              # Compositor embedded bindings
              #   E.g kill active client, switch spaces.
              "Mod1+f1" = "reload";
              "Mod1+Shift+f4" = "exit";
              "Mod1+Return" = "fullscreen";
              "Mod1+q" = "kill";

              # Exec bindings
              #   Ones which will do an external action not
              #   directly tied to sway.
              "Mod4+Return" = "exec ghostty";
              "Mod4+Space" = "exec ${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
              "Mod4+Shift+s" = "exec ${pkgs.hyprshot}/bin/hyprshot -m region --clipboard-only";
              "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5";
              "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            }
            // mkWorkspaceControls { command = "exec ${self.packages.${pkgs.stdenv.system}.wpo}/bin/wpo"; };
            startup = [
              { command = "${pkgs.eww}/bin/eww open bar0"; }
              { command = "${pkgs.eww}/bin/eww open bar1"; }
              { command = "systemctl --user restart xdg-desktop-portal-wlr"; }
            ];
          };
        };
      };
  };
}
