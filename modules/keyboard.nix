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
      { darwin, ... }:
      {
        targets.darwin = lib.optionalAttrs darwin {
          defaults.NSGlobalDomain = {
            KeyRepeat = 2;
            "com.apple.keyboard.fnState" = true; # Wether fn need to be used to do Brightness, Vol, etc.
          };
        };
        # wayland.windowManager.mangowc = lib.optionalAttrs linux {
        # numlockon = "0";
        # repeat_rate = "85";
        # repeat_delay = "400";
        # xkb_rules_layout = "us";
        # xkb_rules_variant = "workman";
        # xkb_rules_options = "caps:escape";
        # };
      };
  };
}
