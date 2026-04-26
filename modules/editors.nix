{
  flake.modules = {
    nixos.base =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ helix ];
      };
    homeManager.base =
      { pkgs, ... }:
      {
	home.packages = with pkgs; [
	  nixd
	];
        programs = {
          emacs = {
            enable = true;
          };
          helix = {
            enable = true;
            defaultEditor = true;

            languages.language = [
              {
                language-servers = [
                  "nixd"
                  "nil"
                ];
                name = "nix";
              }
            ];

            settings = {
              theme = "rose_pine";

              editor = {
                auto-pairs = false;
                color-modes = true;
                bufferline = "multiple";
                scrolloff = 100;
                mouse = false;
                popup-border = "all";
                end-of-line-diagnostics = "hint";
                cursor-shape.insert = "bar";
                inline-diagnostics.cursor-line = "info";
                statusline = {
                  left = [
                    "mode"
                    "spinner"
                  ];
                  center = [
                    "file-name"
                    "read-only-indicator"
                    "file-modification-indicator"
                  ];
                  right = [
                    "diagnostics"
                    "file-type"
                    "file-encoding"
                    "file-line-ending"
                  ];
                  workspace-diagnostics = [
                    "info"
                    "warning"
                    "error"
                  ];
                };
                lsp = {
                  display-inlay-hints = true;
                  display-progress-messages = true;
                };
                indent-guides = {
                  render = true;
                  character = "⸽";
                  skip-levels = 1;
                };
              };
              keys = {
                normal = {
                  A-r = ":config-reload";
                  space = {
                    w = ":w!";
                    q = ":bc";
                  };
                };
              };
            };
            extraPackages = with pkgs; [
              nil
              nixd
              marksman
              markdownlint-cli2
              bash-language-server
            ];
          };
        };
      };
  };
}
