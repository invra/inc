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
      environment.systemPackages = with pkgs; [ fastfetch ]
        ++ lib.optionals stdenv.isLinux [ ghostty ]
        ++ lib.optionals stdenv.isDarwin [ ghostty-bin ];
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
          package = if pkgs.stdenv.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
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
          shellAliases =
            let
              eza = "${pkgs.eza}/bin/eza";
            in
            {
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
      };
    };
}
