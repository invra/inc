{ lib, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        font-awesome
        liberation_ttf
        noto-fonts
        noto-fonts-color-emoji
      ];
    };
in
{
  flake.modules = {
    nixos.base =
      x:
      (lib.recursiveUpdate {
        fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];
      } (polyModule x));
    darwin.base = polyModule;
  };
}
