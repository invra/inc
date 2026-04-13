{ self, lib, inputs, ... }:
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
    "bitwig-studio6"
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
          self.packages.${pkgs.stdenv.system}.dev
          self.packages.${pkgs.stdenv.system}.certified-by-lincoln
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
          (discord.override {
            withOpenASAR = true;
            withVencord = true;
          })
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

      programs = {
        ripgrep.enable = true;
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
