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
    "discord"
  ];
  flake.modules.darwin.base = polyModule;
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ polyModule ];
      environment = {
        systemPackages = with pkgs; [
          lsof
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
        inputs.nixcord.homeModules.nixcord
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
          yt-dlp
          yazi
          wget
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
          crosspipe
          easyeffects
          vlc
          pavucontrol
          blender
          krita
          wayvnc
        ]
        ++ (lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
          wineWow64Packages.stable
          winetricks
          yabridge
          yabridgectl
          bitwig-studio
        ]);

      stylix.targets.btop.enable = false;

      programs = {
        ripgrep.enable = true;
        nixcord = {
          enable = true;
          discord = {
            vencord.enable = false;
            equicord.enable = true;
          };

          config.plugins = {
            # nothing yet
          };
        };

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
