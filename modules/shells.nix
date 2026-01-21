{ config, lib, ... }:
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
    darwin.base = x@{ pkgs, ... }: (
      lib.recursiveUpdate {
        users = {
          knownUsers = [ config.flake.meta.owner.username ];
          users.${config.flake.meta.owner.username} = {
            home = "/Users/${config.flake.meta.owner.username}";
            uid = 501;
          };
        };
      } (polyModule x)
    );
  };

  flake.modules.homeManager.base = {
    home.file.".hushlogin".text = "";

    stylix.targets.fish.enable = false;
    programs.fish = {
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
      '';
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "always";
    };

    stylix.targets.starship.enable = false;
    programs.starship = {
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
        format = "$username$directory$git_branch$git_status$bun$deno$rust$golang$haskell$haxe$zig$c$cpp$cmake$swift$dotnet$nix_shell$time\n$character";
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

    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
