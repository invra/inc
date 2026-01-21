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
    nixos.base = polyModule // {
      fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];
    };
    darwin.base = polyModule;
  };
}
