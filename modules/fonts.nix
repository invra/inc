let
  polyModule =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        lilex
        ibm-plex
        noto-fonts
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
      ];
    };
in
{
  flake.modules = {
    nixos.base = {
      imports = [ polyModule ];
      fonts = {
        fontDir.enable = true;
        fontconfig = {
          useEmbeddedBitmaps = true;
          defaultFonts.monospace = [ "Fira Mono" ];
        };
      };
    };
    darwin.base = polyModule;
  };
}
