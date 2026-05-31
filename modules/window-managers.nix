{
  lib,
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
            mode.main.binding = {
              alt-space = "layout floating tiling";
              alt-enter = "fullscreen";
              cmd-enter = "exec-and-forget ${pkgs.ghostty-bin}/bin/ghostty";
              cmd-backslash = "exec-and-forget ${pkgs.emacs}/bin/emacs";
              cmd-shift-s = "exec-and-forget screencapture -i -c";
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
        programs.sway = {
          enable = true;
          package = pkgs.swayfx;
        };
      };

    homeManager.base =
      {
        linux,
        ...
      }:
      lib.optionalAttrs linux {
        # TODO: Implement beansprout config here
      };
  };
}
