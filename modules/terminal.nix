{ lib, config, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      users.users.${config.flake.meta.owner.username}.shell = pkgs.bash;
      programs.bash = {
        enable = true;
        interactiveShellInit = ''
          export NIX_SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
          export VISUAL="${pkgs.helix}/bin/hx";
          export EDITOR="${pkgs.helix}/bin/hx";
          if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
            exec ${pkgs.nushell}/bin/nu
          fi
        '';
      };
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
      home.file.".hushlogin".text = "";
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
        carapace = {
          enable = true;
          enableNushellIntegration = true;
        };
        zoxide = {
          enable = true;
          options = [ "--cmd cd" ];
          enableNushellIntegration = true;
        };
        nushell = {
          enable = true;
          shellAliases = let
            eza = "${pkgs.eza}/bin/eza";
          in {
            ls = "${eza} --icons"; 
            l = "${eza} --icons -l";
            la = "${eza} --icons -al";
            tree = "${eza} --icons --tree"; 
            edit = "taskset -c 0-7 hx";
            fuckoff = "exit";
            doas = if darwin then "sudo" else "${pkgs.doas-sudo-shim}/bin/sudo";
            q = "exit";
          };

          settings = {
            show_banner = false;
            table = {
              mode = "none";
              index_mode = "never";
            };
          };
          extraConfig = ''
            #!/bin/nu
            def create_left_prompt [] {
              let path = (ansi blue) + ($env.PWD | str replace $env.HOME "~")

              $path + (ansi reset) + "\n"
            }
            $env.PROMPT_COMMAND = { || create_left_prompt };
            $env.PROMPT_INDICATOR = { || $"(ansi green)λ(ansi reset) " };
          '';
        };

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
    };
}
