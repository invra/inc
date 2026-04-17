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
