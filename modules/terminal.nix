{ lib, config, ... }:
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

  flake.modules.homeManager.base =
    { linux, darwin, ... }:
    {
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

            if status is-interactive && not set -q TMUX
              tmux
            end
          '';
        };

        tmux = {
          enable = true;

          terminal = "tmux-256color";
          mouse = true;
          keyMode = "vi";
          clock24 = true;
          historyLimit = 100000;

          extraConfig = ''
            unbind r
            bind r source ~/.config/tmux/tmux.conf\; display "Reloaded!"

            unbind C-b
            set -g prefix C-g
            bind-key C-g send-prefix

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R

            unbind %
            bind-key -T prefix | split-window -h -c "#{pane_current_path}"
            unbind '"'
            bind-key -T prefix - split-window -v -c "#{pane_current_path}"

            set-window-option -g mode-keys vi
            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
            bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
            unbind -T copy-mode-vi MouseDragEnd1Pane

            bind -n M-h select-pane -L
            bind -n M-j select-pane -D
            bind -n M-k select-pane -U
            bind -n M-l select-pane -R

            bind -n M-1 select-window -t 1
            bind -n M-2 select-window -t 2
            bind -n M-3 select-window -t 3
            bind -n M-4 select-window -t 4
            bind -n M-5 select-window -t 5
            bind -n M-6 select-window -t 6
            bind -n M-7 select-window -t 7
            bind -n M-8 select-window -t 8
            bind -n M-9 select-window -t 9

            bind -n C-f resize-pane -Z

            # Floating scratch popup
            bind -n M-f if-shell -F '#{==:#{session_name},scratch}' \
              'detach-client' \
              'display-popup -T "Scratch Session" -E "tmux new-session -A -s scratch -c \"#{pane_current_path}\""'

            thm_bg="#191724"
            thm_fg="#e0def4"
            thm_cyan="#9ccfd8"
            thm_black="#21202e"
            thm_gray="#524f67"
            thm_magenta="#c4a7e7"
            thm_pink="#ebbcba"
            thm_red="#eb6f92"
            thm_green="#31748f"
            thm_yellow="#f6c177"
            thm_blue="#31748f"
            thm_orange="#ebbcba"
            thm_black4="#403d52"
            thm_graywhite="#403d52"

            set -g base-index 1
            set -g pane-base-index 1
            set -g renumber-windows on

            set -g status-position top
            set -g status on
            set -g status-bg "$thm_bg"
            set -g status-justify left
            set -g status-left-length 100
            set -g status-right-length 100

            set-hook -g client-session-changed \
              'if-shell -F "#{==:#{session_name},scratch}" "set -w status off" "set -w status on"'

            set -g message-style "fg=$thm_cyan,bg=$thm_gray,align=centre"
            set -g message-command-style "fg=$thm_cyan,bg=$thm_gray,align=centre"

            set -g pane-border-style "fg=$thm_graywhite"
            set -g pane-active-border-style "fg=$thm_blue"
            set -g pane-border-indicators arrows
            set -g pane-border-format " #T"

            set-hook -g after-new-window   'run-shell -b "if [ #{window_panes} -eq 1 ]; then tmux set pane-border-status off; fi"'
            set-hook -g after-kill-pane    'run-shell -b "if [ #{window_panes} -eq 1 ]; then tmux set pane-border-status off; fi"'
            set-hook -g pane-exited        'run-shell -b "if [ #{window_panes} -eq 1 ]; then tmux set pane-border-status off; fi"'
            set-hook -g after-split-window 'run-shell -b "if [ #{window_panes} -gt 1 ]; then tmux set pane-border-status top; fi"'

            set -g popup-border-style "fg=$thm_cyan"
            set -g popup-border-lines rounded

            set -g window-status-style "fg=$thm_fg,bg=$thm_bg"
            set -g window-status-activity-style "fg=$thm_fg,bg=$thm_bg"
            set -g window-status-separator ""

            set -g status-left "#{?pane_in_mode,#[fg=$thm_yellow]  COPY,#{?client_prefix,#[fg=$thm_green]  TMUX,#[fg=$thm_blue]  Locked}} #[fg=$thm_gray]|#[fg=$thm_fg]"
            set -g window-status-format "#[fg=$thm_blue] 󰓩 #I"
            set -g window-status-current-format "#[fg=$thm_green] #I #[fg=$thm_magenta]"

            set -g clock-mode-colour "$thm_blue"
            set -g mode-style "fg=$thm_blue bg=$thm_black4 bold"

            set -g default-terminal "tmux-256color"
            set -as terminal-features ",*:RGB"
            set -a terminal-features 'foot*:sixel'
            set -g set-clipboard on
            set -g escape-time 0
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

      programs.foot = lib.optionalAttrs linux {
        enable = true;
        server.enable = true;

        settings = with lib; {
          main.font = mkForce "JetBrainsMono Nerd Font:size=18";

          colors.alpha = mkForce 0.85;
        };
      };

      programs.alacritty = lib.optionalAttrs darwin {
        enable = true;
      };
    };
}
