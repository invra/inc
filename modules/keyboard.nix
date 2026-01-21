{
  flake.modules = {
    nixos.base = {
    };

    darwin.base = {
      system.keyboard = {
        enableKeyMapping = true;
        swapLeftCtrlAndFn = true;
        remapCapsLockToEscape = true;
        swapLeftCommandAndLeftAlt = true;
      };
    };
  };
}
