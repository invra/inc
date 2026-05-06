{ inputs, ... }:
let
  stylixModule =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;
        polarity = "dark";
        enableReleaseChecks = false;
        image = ../wallpapers/flake.jpg;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    
        icons = {
          enable = true;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
          package = pkgs.papirus-icon-theme;
        };
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };
        fonts = {
          serif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Serif";
          };
          sansSerif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Sans";
          };
          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrains Mono Nerd Font";
          };
        };
      };
    };
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
        inputs.stylix.nixosModules.stylix
        stylixModule
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
      imports =[
        stylixModule
        polyModule
      ];
    };

    flake.modules.homeManager.base =
      { ... }:
      {
        imports = [
          inputs.stylix.nixosModules.stylix
          stylixModule
        ];
      };
  };
}
