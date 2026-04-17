{ lib, config, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      users.users.${config.flake.meta.owner.username}.shell = pkgs.elvish;
      environment.etc."elvish/rc.elv".text = ''
        #!/usr/bin/env elvish
        set paths = [
          ~/.nix-profile/bin
          ~/.local/state/nix/profile/bin
          /run/wrappers/bin
          /nix/var/nix/profiles/default/bin
          /run/current-system/sw/bin
          $@paths
        ]
      '';
    };
in
{
  flake.modules = {
    nixos.base = {
      imports = [ polyModule ];
      console = {
        useXkbConfig = true;
        colors = [
          "191724"
          "eb6f92"
          "31748f"
          "f6c177"
          "9ccfd8"
          "c4a7e7"
          "ebbcba"
          "e0def4"
          "26233a"
          "eb6f92"
          "31748f"
          "f6c177"
          "9ccfd8"
          "c4a7e7"
          "ebbcba"
          "e0def4"
        ];
      };
    };
    darwin.base = {
      imports = [ polyModule ];

      users = {
        knownUsers = [ config.flake.meta.owner.username ];
        users.${config.flake.meta.owner.username} = {
          home = "/Users/${config.flake.meta.owner.username}";
          uid = 501;
        };
      };
    };
  };

  flake.modules.homeManager.base =
    {
      pkgs,
      linux,
      darwin,
      ...
    }:
    {
      home.packages = with pkgs; [
        eza
        zoxide
        carapace
      ];
      home.file.".hushlogin".text = "";
      xdg.configFile = {
        "elvish/lib/github.com/zzamboni/elvish-modules" = {
          recursive = true;
          source = pkgs.stdenv.mkDerivation {
            name = "elvish-modules-patched";
            src = pkgs.fetchFromGitHub {
              owner = "zzamboni";
              repo = "elvish-modules";
              rev = "9005c970346ab06214b3cd3ed3e70f04f3c632ba";
              sha256 = "/Dwtl12QzPvMoMMGoj+v3dwX2ZwFT8t/bohVy1zDE0c=";
            };
            patches = [
              ../custom/patches/elvish-modules-nix.elv.patch
            ];
            buildInputs = [ ];
            installPhase = ''
              mkdir -p $out
              cp -r ./* $out/
            '';
          };
        };
        "elvish/rc.elv" = {
          executable = true;
          text = ''
            #!/usr/bin/env elvish
            use str
            use path
            use github.com/zzamboni/elvish-modules/nix
            use github.com/zzamboni/elvish-modules/alias

            set paths = [
              ~/.nix-profile/bin
              ~/.local/state/nix/profile/bin
              /run/wrappers/bin
              /nix/var/nix/profiles/default/bin
              /run/current-system/sw/bin
              $@paths
            ]
            nix:multi-user-setup

            # Output for Left Prompt
            set edit:prompt = {
              styled (tilde-abbr $pwd) blue
              styled "\nλ " green
            }
            # No Right Prompt
            set edit:rprompt = { put "" }
            set edit:insert:binding[Alt-x] = { exit }

            alias:new &save ls eza --icons 
            alias:new &save l eza --icons -l
            alias:new &save la eza --icons -al
            alias:new &save tree eza --icons --tree 
            alias:new &save edit taskset -c 0-7 hx
            alias:new &save fuckoff exit
            alias:new &save doas ${if darwin then "sudo" else "${pkgs.doas-sudo-shim}/bin/sudo"}
            alias:new &save q exit

            set E:NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
            set E:VISUAL = "${pkgs.helix}/bin/hx"
            set E:EDITOR = "${pkgs.helix}/bin/hx";
            set-env CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
            eval (carapace _carapace | slurp)
            eval (zoxide init elvish --cmd cd | slurp)
          '';
        };
      };

      programs = {
        fastfetch = {
          enable = true;

          settings = {
            logo.source = "nixos";
            display = {
              size.binaryPrefix = "si";
              color = "blue";
              separator = "  ";
            };
            modules = [
              {
                type = "os";
                key = "os   ";
                keyColor = "blue";
                format = "{name} {version}";
              }
              {
                type = "kernel";
                key = "krnl ";
                keyColor = "blue";
              }
              {
                type = "packages";
                key = "pkgs ";
                keyColor = "blue";
              }
              {
                type = "shell";
                key = "shell";
                keyColor = "blue";
              }
              "break"
              {
                type = "wm";
                key = "wm   ";
                keyColor = "red";
              }
              {
                type = "terminal";
                key = "term ";
                keyColor = "red";
              }
              {
                type = "font";
                key = "font ";
                keyColor = "red";
              }
              {
                type = "icons";
                key = "icon ";
                keyColor = "red";
              }
              "break"
              {
                type = "board";
                key = "pc   ";
                keyColor = "green";
              }
              {
                type = "cpu";
                key = "cpu  ";
                keyColor = "green";
              }
              {
                type = "memory";
                key = "mem  ";
                keyColor = "green";
              }
              {
                type = "gpu";
                key = "gpu  ";
                keyColor = "green";
              }
              {
                type = "disk";
                key = "disk ";
                keyColor = "green";
              }
              "break"
              {
                type = "localip";
                key = "ip   ";
                keyColor = "yellow";
              }
              {
                type = "dns";
                key = "dns  ";
                keyColor = "yellow";
              }
              "break"
              {
                type = "custom";
                key = "hg   ";
                format = "https://hg.sr.ht/~invra/";
                keyColor = "magenta";
              }
              {
                type = "custom";
                key = "git  ";
                format = "https://gitlab.com/invra/";
                keyColor = "magenta";
              }
              {
                type = "custom";
                key = "darcs";
                format = "https://hub.darcs.net/invra/";
                keyColor = "magenta";
              }
            ];
          };
        };
      };

      programs = {
        ghostty = {
          enable = true;
          package = pkgs.ghostty-bin;
          settings = {
            theme = "Rose Pine";
            font-size = 16.0;
            font-family = "Lilex";
            background-opacity = if linux then lib.mkForce 0.85 else lib.mkForce 0.95;
            macos-titlebar-style = "hidden";
          };
        };
      };
    };
}
