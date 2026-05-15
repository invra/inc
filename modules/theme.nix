{ inputs, ... }:
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
        inputs.stylix.nixosModules.stylix
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

    flake.modules.homeManager.base =
      { ... }:
      {
        imports = [
          inputs.stylix.nixosModules.stylix
        ];
      };
  };
}
