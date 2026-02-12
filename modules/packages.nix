{ lib, inputs, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          jack2
          helix
          git
          home-manager
        ];

        shells = with pkgs; [
          bashInteractive
          fish
        ];
      };
    };
in
{
  nixpkgs.allowedUnfreePackages = [
    "bitwig-studio-unwrapped"
    "steam"
    "steam-unwrapped"
  ];
  flake.modules.darwin.base = polyModule;
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ polyModule ];
      environment = {
        systemPackages = with pkgs; [
          lsof
          foot
          pciutils
          nautilus
          swww
          firefox
          xwayland-satellite
        ];
      };

      programs = {
        obs-studio = {
          enable = true;
          enableVirtualCamera = true;
          package = (
            pkgs.obs-studio.override {
              cudaSupport = true;
            }
          );
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

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          sl
          (inputs.dev-nix.packages.${stdenv.hostPlatform.system}.default)
          (inputs.helium.packages.${stdenv.hostPlatform.system}.default)
          dbgate
          prismlauncher
          viu
          ffmpeg
          file
          fd
          unzip
          nil
          nixd
          yt-dlp
          yazi
          wget
          firefox
          killall
        ]
        ++ lib.optionals (!(stdenv.isLinux && stdenv.isAarch64)) [
          insomnia
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          alacritty
          pika
          utm
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          wl-clipboard
          wayvnc
          helvum
          easyeffects
          vlc
          pavucontrol
          # davinci-resolve
          krita
          wayvnc
        ]
        ++ (lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
          wineWowPackages.waylandFull
          winetricks
          yabridge
          yabridgectl
          bitwig-studio
        ]);

      programs.firefox = {
        enable = true;

        profiles = {
          main = {
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
      };

      stylix.targets = {
        firefox.profileNames = [ "main" ];
        btop.enable = false;
      };

      programs = {
        ripgrep.enable = true;

        zed-editor = {
          enable = true;
          extensions = [
            "nix"
            "zig"
            "toml"
            "rose-pine-theme"
          ];
        };

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
      };
    };
}
