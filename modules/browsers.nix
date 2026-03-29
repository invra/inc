{ lib, inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ firefox ];
    };
  flake.modules.homeManager.base =
    { pkgs, linux, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];
      stylix.targets = {
        firefox.profileNames = [ "main" ];
        zen-browser.enable = false;
      };
      programs.firefox = {
        enable = true;
        profiles.main = {
          id = 0;
          isDefault = true;
          settings = {
            "browser.newtab.pinned" = [
              {
                title = "nixos";
                url = "https://nixos.org";
              }
            ];
          };
        };
      };
      programs.zen-browser =
        let
          # Generates the URL for the .xpi extension file
          # mkExtensionUrl :: { url ? String, path :: String } -> String
          # Automatically will force https://.
          # e.g mkExtensionUrl { url = "dl.premid.app"; path = "PreMiD.xpi"; }
          #     -> "https://dl.premid.app/PreMiD.xpi"
          mkExtensionUrl =
            {
              url ? "addons.mozilla.org",
              path,
            }:
            "https://${url}/${path}";

          # Wrapper around mkExtensionUrl to only need to provide
          # the special slug for official Mozilla extensions.
          # mkExtensionUrl :: String -> String
          # e.g mkMozExtensionUrl "ublock-origin"
          #     -> mkExtensionUrl { path = "firefox/downloads/latest/${id}/latest.xpi"
          #     -> "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
          mkMozExtensionUrl = id: mkExtensionUrl { path = "firefox/downloads/latest/${id}/latest.xpi"; };

          mkExtensionEntry =
            {
              install_url,
              pinned ? false,
            }:
            let
              base = {
                inherit install_url;
                installation_mode = "force_installed";
              };
            in
            if pinned then base // { default_area = "navbar"; } else base;

          mkExtensionSettings = builtins.mapAttrs (
            _: entry:
            if builtins.isAttrs entry then
              entry
            else
              mkExtensionEntry {
                install_url = mkMozExtensionUrl entry;
              }
          );
        in
        {
          enable = true;
          darwinDefaultsId = "app.zen-browser.zen";
          policies = {
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            ExtensionSettings = mkExtensionSettings {
              "uBlock0@raymondhill.net" = mkExtensionEntry {
                install_url = mkMozExtensionUrl "ublock-origin";
                pinned = true;
              };
              "support@premid.app" = mkExtensionEntry {
                install_url = mkExtensionUrl {
                  url = "dl.premid.app";
                  path = "PreMiD.xpi";
                };
              };
              "wappalyzer@crunchlabz.com" = "wappalyzer";
              "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
              "{861a3982-bb3b-49c6-bc17-4f50de104da1}" = "custom-user-agent-revived";
              "{0d7cafdd-501c-49ca-8ebb-e3341caaa55e}" = "youtube-nonstop";
            };
          };

          profiles.default = {
            id = 0;
            isDefault = true;
            search = {
              default = "Startpage";
              force = true;
              order = [ "Startpage" ];
              engines = {
                Startpage = {
                  urls = [ { template = "https://www.startpage.com/sp/search?q={searchTerms}"; } ];
                  definedAliases = [ "@sp" ];
                };
                NixOS = {
                  urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@nix" ];
                };
              };
            };
            settings = {
              "zen.workspaces.continue-where-left-off" = true;
              "zen.window-sync.enabled" = false;
              "zen.workspaces.natural-scroll" = true;
              "zen.view.compact.hide-tabbar" = true;
              "zen.view.compact.hide-toolbar" = true;
              "zen.view.compact.animate-sidebar" = false;
              "zen.welcome-screen.seen" = true;
              "zen.urlbar.behavior" = "float";
              browser = {
                tabs.warnOnClose = false;
                download.panel.shown = false;
              };
            };
          };
        };
    }
    // lib.optionalAttrs linux {
      wayland.windowManager.mango.settings.bind = [ "Super,B,spawn,zen-beta" ];
    };
}
