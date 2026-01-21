{ lib, inputs, ... }:
let
  polyModule = pkgs: {
    environment = {
      systemPackages = with pkgs; [
        jack2
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
  flake.modules.darwin.base = { pkgs, ... }: polyModule pkgs;
  flake.modules.nixos.base =
    { pkgs, ... }:
    lib.mkMerge [
      (polyModule pkgs)
      {
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
      }
    ];

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
          (pkgs.stdenv.mkDerivation rec {
            pname = "linearmouse";
            version = "0.10.1";
            src = pkgs.fetchurl {
              url = "https://github.com/linearmouse/linearmouse/releases/download/v${version}/LinearMouse.dmg";
              sha256 = "sha256-0000000000000000000000000000000000000000000=";
            };
            nativeBuildInputs = [
              pkgs.makeWrapper
              pkgs.undmg
            ];
            installPhase = ''
              tmp_mount=$(mktemp -d /tmp/${pname}-mount.XXXXXX)
              /usr/bin/hdiutil attach -nobrowse "$src" -mountpoint "$tmp_mount"

              mkdir -p $out/Applications
              cp -R "$tmp_mount/${filename}" "$out/Applications/"

              /usr/bin/hdiutil detach "$tmp_mount"
              rmdir "$tmp_mount"

              mkdir -p $out/bin
              makeWrapper "$out/Applications/LinearMouse.app/Contents/MacOS/linearmouse" "$out/bin/linearmouse"
            '';
            meta = {
              description = "The mouse and trackpad customizer for macOS.";
              homepage = "https://linearmouse.org";
            };
          })
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
          (yabridgectl.override { wine = wineWowPackages.waylandFull; })
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
