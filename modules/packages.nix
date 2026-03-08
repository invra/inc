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
          swww
          firefox
          pciutils
          nautilus
          alacritty
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
      imports = [
        inputs.nix-doom-emacs-unstraightened.homeModule
      ];
      home.packages =
        with pkgs;
        [
          sl
          (inputs.dev-nix.packages.${stdenv.hostPlatform.system}.default)
          prismlauncher
          viu
          ffmpeg
          file
          fd
          unzip
          nil
          nixd
          # INFO: Couldn't build - python errors
          # yt-dlp
          yazi
          wget
          firefox
          killall
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
          blender
          # INFO: Couldn't build - build failure
          # krita
          wayvnc
        ]
        ++ (lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
          wineWow64Packages.waylandFull
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

        # doom-emacs = {
        #   enable = true;
        # };

        zed-editor = {
          enable = true;
          extraPackages = with pkgs; [
            nil
            nixd
            rust-analyzer
          ];
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
