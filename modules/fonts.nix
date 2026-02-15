let
  polyModule =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        hack-font
        fira-code
        noto-fonts
        liberation_ttf
        fira-code-symbols
        noto-fonts-cjk-sans
        nerd-fonts.fira-mono
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
