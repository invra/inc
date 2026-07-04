{ lib, ... }:
{
  flake.modules = {
    nixos.base = {
      services.xserver.xkb = {
        layout = "us,us";
        variant = ",workman";
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
            "com.apple.keyboard.fnState" = true; # Whether fn need to be used to do Brightness, Vol, etc.
          };
        };
      };
  };
}
