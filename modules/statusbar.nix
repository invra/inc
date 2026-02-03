{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, linux, ... }:
    lib.optionalAttrs linux {
      programs.eww = {
        enable = true;
        enableFishIntegration = true;
      };
      home.file = {
        ".config/eww/eww.scss".text = ''
          * {
            all: unset;
          }

          .bar {
            background-color: #191724;
            color: #e0def4;
            padding: 10px;
          }

          .sidestuff slider {
            all: unset;
            color: #ffd5cd;
          }

          .metric scale trough highlight {
            all: unset;
            background-color: #ebbcba;
            color: #000000;
            border-radius: 10px;
          }

          .metric scale trough {
            all: unset;
            background-color: #2a273f;
            border-radius: 50px;
            min-height: 3px;
            min-width: 50px;
            margin-left: 10px;
            margin-right: 20px;
          }

          .label-ram {
            font-size: large;
          }

          .workspaces button:hover {
            color: #D35D6E;
          }
        '';
        ".config/eww/eww.yuck".text = ''
          (defwidget bar []
            (centerbox :orientation "h"
              (workspaces)
              (music)
              (sidestuff)))

          (defwidget sidestuff []
            (box :class "sidestuff" :orientation "h" :space-evenly false :halign "end"
              (metric :label "''${(volume == 0) ? "   " : (volume < 75) ? "  " : "  "} ''${volume}%"
                      :value volume
                      :onchange "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ {}%")
              (metric :label "   ''${round(EWW_RAM.used_mem_perc, 0)}%"
                      :value {EWW_RAM.used_mem_perc}
                      :onchange "")
              time))

          (defwidget workspaces []
            (box :class "workspaces"
                 :orientation "h"
                 :space-evenly true
                 :halign "start"
                 :spacing 10
              (button :onclick "${pkgs.mangowc}/bin/mmsg -t 1" 1)
              (button :onclick "${pkgs.mangowc}/bin/mmsg -t 2" 2)
              (button :onclick "${pkgs.mangowc}/bin/mmsg -t 3" 3)
              (button :onclick "${pkgs.mangowc}/bin/mmsg -t 4" 4)
              (button :onclick "${pkgs.mangowc}/bin/mmsg -t 5" 5)))

          (defwidget music []
            (box :class "music"
                 :orientation "h"
                 :space-evenly false
                 :halign "center"
              {music != "" ? "''${music}" : ""}))

          (defwidget metric [label value onchange]
            (box :orientation "h"
                 :class "metric"
                 :space-evenly false
              (box :class "label" label)
              (scale :min 0
                     :max 101
                     :active {onchange != ""}
                     :value value
                     :onchange onchange)))

          (deflisten music :initial ""
            "${pkgs.playerctl}/bin/playerctl --follow metadata --format '{{ artist }} - {{ title }}' || true")

          (defpoll volume
            :interval "10ms"
            "${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print int($2 * 100) }'")

          (defpoll time :interval "10ms"
            "date '+%H:%M'")

          (defwindow bar
            :monitor 0
            :windowtype "desktop"
            :stacking "fg"
            :exclusive true
            :focusable false
            :geometry (geometry :x "0%"
                                :y "0%"
                                :width "100%"
                                :height "20px"
                                :anchor "top center")
            (bar))
        '';
      };
    };
}
