{
  inputs,
  self,
  lib,
  ...
}:
let
  polyModule =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          jack2
          home-manager
        ];

        shells = with pkgs; [
          bashInteractive
        ];
      };
    };
in
{
  nixpkgs.allowedUnfreePackages = [
    "bitwig-studio6"
    "steam"
    "steam-unwrapped"
    "discord"
  ];
  flake.modules = {
    darwin.base = polyModule;
    nixos.base =
      { pkgs, ... }:
      {
        imports = [ polyModule ];
        environment = {
          systemPackages = with pkgs; [
            lsof
            pciutils
            nautilus
            xwayland-satellite
          ];
        };

        programs = {
          obs-studio = {
            enable = true;
            enableVirtualCamera = true;
          };

          steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
          };
        };
        documentation.nixos.enable = false;
      };

    homeManager.base =
      { pkgs, ... }:
      {
        imports = [
          inputs.nixcord.homeModules.nixcord
        ];
        home.packages =
          with pkgs;
          [
            self.packages.${pkgs.stdenv.system}.dev
            self.packages.${pkgs.stdenv.system}.certified-by-lincoln
            viu
            ffmpeg
            file
            fd
            unzip
            yt-dlp
            wget
            killall
            prismlauncher
          ]
          ++ lib.optionals pkgs.stdenv.isDarwin [
            utm
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            wl-clipboard
            wayvnc
            crosspipe
            vlc
            pavucontrol
            blender
            ungoogled-chromium
          ]
          ++ (lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
            wineWow64Packages.stable
            winetricks
            yabridge
            yabridgectl
            bitwig-studio
            discord
          ]);

        programs = {
          nixcord = {
            enable = false;
            discord.equicord.enable = true;
          };
          ripgrep.enable = true;
          btop = {
            enable = true;
            settings = {
              theme_background = false;
              color_theme = "TTY";
              vim_keys = true;
              update_ms = 1000;
              truecolor = true;
              temp_scale = "celsius";

              proc_aggregate = true;
            };
          };
          spotify-player = {
            enable = false;

            settings = {
              theme = "rose-pine";
              notify_format = {
                summary = "{track}";
                body = "{artists} - {album}";
              };
              playback_refresh_duration_in_ms = 500;

              device = {
                volume = 40;
                bitrate = 320;
              };
              layout = {
                playback_window_position = "Bottom";
                library = {
                  playlist_percent = 60;
                  album_percent = 20;
                };
              };
            };

            themes = [
              {
                name = "rose-pine";

                palette = {
                  background = "#191724";
                  foreground = "#e0def4";
                  black = "#21202e";
                  blue = "#31748f";
                  cyan = "#9ccfd8";
                  green = "#9ccfd8";
                  magenta = "#c4a7e7";
                  red = "#eb6f92";
                  white = "#e0def4";
                  yellow = "#f6c177";
                  bright_black = "#1e1e2e";
                  bright_blue = "#89b4fa";
                  bright_cyan = "#89dceb";
                  bright_green = "#a6e3a1";
                  bright_magenta = "#cba6f7";
                  bright_red = "#f38ba8";
                  bright_white = "#cdd6f4";
                  bright_yellow = "#f9e2af";
                };

                component_style = {
                  selection = {
                    bg = "#403d52";
                    modifiers = [ "Bold" ];
                  };
                  block_title.fg = "Magenta";
                  playback_track = {
                    fg = "#ebbcba";
                    modifiers = [ "Bold" ];
                  };
                  playback_album.fg = "Yellow";
                  playback_metadata.fg = "Blue";
                  playback_progress_bar = {
                    bg = "#1f1d2e";
                    fg = "#c4a7e7";
                  };
                  current_playing = {
                    fg = "#ebbcba";
                    modifiers = [ "Bold" ];
                  };
                  page_desc = {
                    fg = "#ebbcba";
                    modifiers = [ "Bold" ];
                  };
                  table_header.fg = "Blue";
                  border = { };
                  playback_status = {
                    fg = "#ebbcba";
                    modifiers = [ "Bold" ];
                  };
                  playback_artists = {
                    fg = "#ebbcba";
                    modifiers = [ "Bold" ];
                  };
                  playlist_desc.fg = "Cyan";
                };
              }
            ];
          };
        };
      };
  };
}
