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
      imports = [
        polyModule
      ];
      fonts = {
        fontDir.enable = true;
        fontconfig = {
          enable = true;
          useEmbeddedBitmaps = true;
          defaultFonts = {
            monospace = [ "Lilex" ];
            serif = [ "IBM Plex Serif" ];
            sansSerif = [ "IBM Plex Sans" ];
          };
        };
      };
    };

    darwin.base = {
      imports = [
        polyModule
      ];
    };
    homeManager.base = { pkgs, ... }: {
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
      };
    };
  };
}
