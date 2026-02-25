{ inputs, ... }:
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
        stylix.targets.helix.enable = false;

        programs.helix = {
          enable = true;
          defaultEditor = true;

          languages = {
            language = [
              {
                name = "rust";
                indent = {
                  tab-width = 2;
                  unit = " ";
                };
              }
              {
                language-servers = [
                  "nixd"
                  "nil"
                ];
                name = "nix";
              }
            ];
          };

          settings = {
            theme = "rose_pine";

            editor = {
              line-number = "relative";
              color-modes = true;
              bufferline = "multiple";
              scrolloff = 100;
              mouse = false;
              popup-border = "all";
              end-of-line-diagnostics = "hint";
              cursor-shape.insert = "bar";
              inline-diagnostics.cursor-line = "warning";
              insert-final-newline = false;
              statusline = {
                left = [
                  "mode"
                  "file-modification-indicator"
                  "spinner"
                ];
                center = [ "file-name" ];
                right = [
                  "diagnostics"
                  "file-type"
                  "file-encoding"
                  "file-line-ending"
                ];
              };
              lsp = {
                display-inlay-hints = true;
                display-progress-messages = true;
              };
              indent-guides = {
                render = true;
                character = "╎";
                skip-levels = 1;
              };
            };
            keys = {
              normal = {
                A-r = ":config-reload";
                A-j = [
                  "keep_primary_selection"
                  "move_line_down"
                  "extend_to_line_bounds"
                  "extend_line_above"
                  "split_selection_on_newline"
                  "select_mode"
                  "goto_line_end_newline"
                  "normal_mode"
                  "rotate_selection_contents_forward"
                  "keep_primary_selection"
                  "move_line_down"
                ];
                A-k = [
                  "keep_primary_selection"
                  "extend_to_line_bounds"
                  "extend_line_above"
                  "split_selection_on_newline"
                  "select_mode"
                  "goto_line_end_newline"
                  "normal_mode"
                  "rotate_selection_contents_forward"
                  "keep_primary_selection"
                ];
                space = {
                  space = "@<space>f";
                  w = ":wq!";
                  W = ":w!";
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
}
