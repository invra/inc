{ inputs, lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.helium.nixosModules.helium
      ];
      environment.systemPackages = [ inputs.helium.packages.${pkgs.stdenv.system}.default ];
    };
  flake.modules.homeManager.base =
    {
      linux,
      ...
    }:
    {
      imports = [
        inputs.helium.homeModules.helium
      ];

      programs.helium = {
        enable = true;
        defaultBrowser = true;

        extensions = [
          {
            id = "fmkadmapgofadopljbjfkapdkoienihi";
            hash = "sha256-X3DIlm39NyFz8bGKVjubF8JGeS58EirqeETOBk8Hfgc=";
          }
        ];

        extraFlags = [
          "--force-dark-mode"
        ];

        extraPolicies = {
          HomepageLocation = "https://start.duckduckgo.com";
          PasswordManagerEnabled = false;
          DeveloperToolsAvailability = 1;
          ManagedBookmarks = [
            {
              toplevel_name = "Nix Ecosystem";
            }
            {
              url = "https://search.nixos.org/packages";
              name = "Nix Packages";
            }
          ];
        };

        preferences = {
          browser.show_home_button = true;
          bookmark_bar.show_on_all_tabs = true;
        };
      };
    }
    // lib.optionalAttrs linux {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "helium.desktop";
          "x-scheme-handler/http" = "helium.desktop";
          "x-scheme-handler/https" = "helium.desktop";
          "x-scheme-handler/about" = "helium.desktop";
          "x-scheme-handler/unknown" = "helium.desktop";
        };
      };
    };
}
