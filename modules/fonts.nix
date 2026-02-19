let
  polyModule =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        lilex
        ibm-plex
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
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
