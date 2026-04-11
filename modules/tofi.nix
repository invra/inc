{ lib, ... }:
{
  flake.modules.homeManager.base =
    { linux, ... }:
    {
      programs.tofi = lib.optionalAttrs linux {
        enable = true;

        settings = {
          # Generator doesnt wrap "" so intentional space is escaped.
          prompt-text = "\"󱞪 \"";
          text-color = "#e0def4";
          prompt-color = "#ebbcba";
          selection-color = "#c4a7e7";
          background-color = "#191724e6";

          width = "100%";
          padding-left = "35%";
          padding-top = "30%";
          height = "100%";
          border-width = 0;
          outline-width = 0;
          result-spacing = 14;
          num-results = 8;
          font = "JetBrains Mono Nerd Font";
          font-variations = "wght 600";
          font-size = 26;
        };
      };
    };
}
