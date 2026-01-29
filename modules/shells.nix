{ config, ... }:
let
  polyModule =
    { pkgs, ... }:
    {
      users.users.${config.flake.meta.owner.username}.shell = pkgs.fish;
      programs.fish.enable = true;
    };
in
{
  flake.modules = {
    nixos.base = polyModule;
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

  flake.modules.homeManager.base = {
    home.file.".hushlogin".text = "";

    stylix.targets.fish.enable = false;
    programs = {
      fish = {
        enable = true;
        shellAliases = {
          l = "ls -l";
          la = "ls -al";
          ":q" = "exit";
          fuckoff = "exit";
          edit = "taskset -c 0-7 hx";
        };

        interactiveShellInit = ''
          #!/bin/env fish

          set fish_greeting ""
          alias tree "eza --tree"

          if status is-interactive
            if not set -q TMUX
              tmux
            end
          end
        '';
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
        icons = "always";
      };

      starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          character = {
            error_symbol = "[ 󱞪](bold red)";
            success_symbol = "[ 󱞪](bold green)";
            vimcmd_replace_one_symbol = "[<](bold purple)";
            vimcmd_replace_symbol = "[<](bold purple)";
            vimcmd_symbol = "[<](bold green)";
            vimcmd_visual_symbol = "[<](bold yellow)";
          };
          continuation_prompt = "[.](bright-black) ";
          format = "$directory$git_branch$git_status$bun$deno$rust$golang$haskell$haxe$zig$c$cpp$cmake$swift$dotnet$nix_shell$time\n$character";
          bun.symbol = "bun ";
          c.symbol = "c ";
          cmake.symbol = "cmake ";
          cpp.symbol = "c++ ";
          deno.symbol = "deno ";
          directory.read_only = " ro";
          dotnet = {
            format = "via [$symbol($version )(target $tfm )]($style)";
            symbol = ".net ";
          };
          git_branch = {
            symbol = "git ";
            truncation_symbol = "...";
          };
          git_commit.tag_symbol = " tag ";
          git_status = {
            ahead = ">";
            behind = "<";
            deleted = "x";
            diverged = "<>";
            renamed = "r";
          };
          haskell.symbol = "haskell ";
          haxe.symbol = "haxe ";
          nix_shell.symbol = "nix ";
          package.symbol = "pkg ";
          rust.symbol = "rust ";
          swift.symbol = "swift ";
          zig.symbol = "zig ";
        };
      };

      carapace = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = [ "--cmd cd" ];
      };

      fastfetch = {
        enable = true;

        settings = {
          logo.source = "nixos";
          display = {
          size.binaryPrefix = "si";
            color = "blue";
            separator = " ";
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
          ];
        };
      };
    };

    stylix.targets.starship.enable = false;
  };
}
