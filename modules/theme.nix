{ lib, ... }:
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

    darwin.base = polyModule;

    flake.modules.homeManager.base =
      { linux, ... }:
      let
        rosepine-gtk = fetchGit {
          url = "https://github.com/rose-pine/gtk";
          rev = "3a11f84e11685aacaa749deea1e9f02872b99fdf";
          shallow = true;
        };
      in
      lib.mkOptional linux {
        xdg.configFile."gtk-4.0/gtk.css".source = "${rosepine-gtk}/gtk4/rose-pine.css";
      };
  };
}
