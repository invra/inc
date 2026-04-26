{ lib, ... }:
{
  flake.modules = {
    nixos.base = {
      services.xserver.xkb = {
        layout = "us";
        variant = "workman";
        options = "caps:escape";
      };
    };

    darwin.base = {
      system.keyboard = {
        enableKeyMapping = true;
        swapLeftCtrlAndFn = true;
        remapCapsLockToEscape = true;
        swapLeftCommandAndLeftAlt = true;
      };
    };

    homeManager.base =
      { darwin, linux, ... }:
      {
        targets.darwin = lib.optionalAttrs darwin {
          defaults.NSGlobalDomain = {
            KeyRepeat = 2;
            "com.apple.keyboard.fnState" = true; # Whether fn need to be used to do Brightness, Vol, etc.
          };
        };
      }
      // lib.optionalAttrs linux {
        wayland.windowManager.sway.config.input."*" = {
          repeat_rate = "50";
          repeat_delay = "250";
          xkb_layout = "us,us";
          xkb_variant = ",workman";
          xkb_options = "grp:caps_toggle";
        };
      };
  };
}
