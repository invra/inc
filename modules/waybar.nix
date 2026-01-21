{ lib, ... }:
{
  flake.modules.homeManager.base =
    { linux, ... }:
    {
      stylix.targets.waybar.enable = false;
      programs.waybar.enable = lib.mkIf linux true;
      home.file = lib.optionalAttrs linux {
        ".config/waybar/config".text = ''
          {
              "layer": "top",
              "position": "top",
              "height": 25,
              "spacing": 0,
              "margin-top": 0,
              "margin-left": 0,
              "margin-right": 0,
              "modules-left": [
                "custom/launcher",
                "ext/workspaces",
                "dwl/window"
              ],
              "modules-center": [
              ],
              "modules-right": [
                "network",
                "pulseaudio",
                "battery",
                "tray",
                "clock",
              ],
              "custom/launcher": {
                "format": "{}",
                "tooltip": true,
                "exec": "echo '{\"text\":\"󱄅 \",\"tooltip\":\"Drun | Run\"}'",
                "return-type": "json",
                "on-click": "bash -c 'pkill tofi-drun || tofi-drun --drun-launch=true'",
              },
              "hyprland/workspaces": {
                "format": "",
                "format-icons": {
                    "active": "",
                    "default": ""
                },
                "on-scroll-up": "hyprctl dispatch workspace e-1",
                "on-scroll-down": "hyprctl dispatch workspace e+1",
                "on-click": "activate"
              },
              "cpu": {
                "format": " {usage}%",
                "tooltip": true,
                "interval": 2
              },
              "memory": {
                "format": " {}%",
                "tooltip": true,
                "interval": 2
              },
              "temperature": {
                  "critical-threshold": 40,
                  "format-critical": "{icon} {temperatureC}°C",
                  "format": "{icon} {temperatureC}°C",
                  "format-icons": [
                      "",
                      "",
                      ""
                  ],
                  "tooltip": true,
                  "interval": 2
              },
              "disk": {
                  "format": " {percentage_used}% ({free})",
                  "tooltip": true,
                  "interval": 2
              },
              "hyprland/window": {
                  "format": "{}",
                  "separate-outputs": true,
                  "max-length": 35
              },
              "network": {
                  "format": "↕ {bandwidthTotalBytes}",
                  "format-disconnected": "{icon} No Internet",
                  "format-linked": " {ifname} (No IP)",
                  "format-alt": "↕{bandwidthUpBytes} | ↕{bandwidthDownBytes}",
                  "tooltip-format": "{ifname}: {ipaddr}/{cidr}  {gwaddr}",
                  "tooltip-format-wifi": "{icon} {essid} ({signalStrength}%)",
                  "tooltip-format-ethernet": "{icon} {ipaddr}/{cidr}",
                  "tooltip-format-disconnected": "{icon} Disconnected",
                  "on-click-right": "nm-connection-editor",
                  "format-icons": {
                      "ethernet": "",
                      "disconnected": "⚠",
                      "wifi": [
                          "睊",
                          "直"
                      ]
                  },
                  "interval": 2
              },
              "pulseaudio": {
                  "format": "{icon}  {volume}%",
                  "format-bluetooth": "{icon} {volume}%",
                  "format-bluetooth-muted": "",
                  "format-source": "{volume}% ",
                  "format-source-muted": "",
                  "format-muted": "",
                  "format-icons": {
                      "alsa_output.pci-0000_00_1f.3.analog-stereo": "",
                      "alsa_output.pci-0000_00_1f.3.analog-stereo-muted": "",
                      "headphones": "",
                      "handsfree": "",
                      "headset": "",
                      "phone": "",
                      "phone-muted": "",
                      "portable": "",
                      "car": "",
                      "default": ["", ""]
                  },
                  "on-click": "pavucontrol"
              },
              "battery": {
                  "states": {
                      "good": 100,
                      "warning": 30,
                      "critical": 10
                  },
                  "format": "{icon} {capacity}%",
                  "format-charging": " {capacity}%",
                  "format-plugged": " {capacity}%",
                  "format-alt": "{icon} {time}",
                  "format-full": " {capacity}%",
                  "format-icons": [
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      "",
                      ""
                  ],
                  "interval": 2
              },
              "tray": {
                  "icon-size": 15,
                  "spacing": 15
              },
              "clock": {
                  "format": " {:%d <small>%a</small> %H:%M}",
                  "format-alt": " {:%A %B %d %Y (%V) | %r}",
                  "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
                  "calendar-weeks-pos": "right",
                  "today-format": "<span color='#f38ba8'><b><u>{}</u></b></span>",
                  "format-calendar": "<span color='#f2cdcd'><b>{}</b></span>",
                  "format-calendar-weeks": "<span color='#94e2d5'><b>W{:%U}</b></span>",
                  "format-calendar-weekdays": "<span color='#f9e2af'><b>{}</b></span>",
                  "interval": 60
              },
          }
        '';
        ".config/waybar/style.css".text = ''
          @define-color base  #191724;
          @define-color surface #1f1d2e;
          @define-color mantle #1f1d2e;
          @define-color crust #11111b;

          @define-color text #e0def4;
          @define-color subtext0 #a6adc8;
          @define-color subtext1 #bac2de;

          @define-color surface0 rgba(22, 25, 37, 0.9);
          @define-color surface1 #45475a;
          @define-color surface2 #585b70;
          @define-color surface3 #394161;

          @define-color overlay0 #6c7086;
          @define-color overlay1 #7f849c;
          @define-color overlay2 #9ba3c3;

          @define-color blue #89b4fa;
          @define-color lavender #c4a7e7;
          @define-color sapphire #74c7ec;
          @define-color sky #ebbcba;
          @define-color teal #94e2d5;
          @define-color green #9ccfd8;
          @define-color yellow #f9e2af;
          @define-color peach #fab387;
          @define-color maroon #eba0ac;
          @define-color red #eb6f92;
          @define-color mauve #cba6f7;
          @define-color pink #f5c2e7;
          @define-color flamingo #f2cdcd;
          @define-color rosewater #f5e0dc;

          /* =============================== */
          /* Universal Styling */
          * {
            border: none;
            border-radius: 0;
            font-family: 'JetBrains Mono Nerd Font';
            font-size: 16px;
            min-height: 0;
          }

          /* =============================== */


          /* =============================== */
          /* Bar Styling */
          #waybar {
            background: @base;
            color: @text;
          }

          /* =============================== */


          /* =============================== */
          /* Main Modules */
          #custom-launcher,
          #workspaces,
          #window,
          #tray,
          #backlight,
          #clock,
          #battery,
          #pulseaudio,
          #network,
          #mpd,
          #cpu,
          #memory,
          #disk,
          #temperature,
          #custom-music,
          #custom-updates,
          #custom-nordvpn,
          #custom-notifications,
          #custom-power,
          #custom-custom,
          #custom-cycle_wall,
          #custom-clipboard,
          #custom-ss,
          #custom-weather {
            background-color: @surface;
            color: @text;
            border-radius: 5px;
            padding: 5px 1rem;
            margin-top: 8px;
            margin-bottom: 8px;
            margin-right: 15px;
          }

          #custom-power {
            margin-right: 0;
          }

          /* =============================== */
          /* Launcher Module */
          #custom-launcher {
            color: #9ccfd8;
            font-size: 27px;
            font-weight: bold;
            padding-top: 0px;
            padding-bottom: 0px;
            padding-left: 9px;
            padding-right: 0px;
            margin-left: 30px
          }

          /* =============================== */
          /* Workspaces */
          #workspaces {
            padding-left: 8px;
            padding-right: 8px;
          }

          #workspaces * {
            font-size: 0px;
          }

          #workspaces button {
            background-color: @surface3;
            color: @mauve;
            border-radius: 100%;
            min-height: 14px;
            min-width: 17px;
            margin: 5px 8px;
            padding: 0px;
            box-shadow: rgba(0, 0, 0, 0.288) 2px 2px 5px 2px;
          }

          #workspaces button.active {
            background: radial-gradient(circle, rgba(203, 166, 247, 1) 0%, rgba(193, 168, 247, 1) 12%, rgba(249, 226, 175, 1) 19%, rgba(189, 169, 247, 1) 20%, rgba(182, 171, 247, 1) 24%, rgba(198, 255, 194, 1) 36%, rgba(177, 172, 247, 1) 37%, rgba(170, 173, 248, 1) 48%, rgba(255, 255, 255, 1) 52%, rgba(166, 174, 248, 1) 52%, rgba(160, 175, 248, 1) 59%, rgba(148, 226, 213, 1) 66%, rgba(155, 176, 248, 1) 67%, rgba(152, 177, 248, 1) 68%, rgba(205, 214, 244, 1) 77%, rgba(148, 178, 249, 1) 78%, rgba(144, 179, 250, 1) 82%, rgba(180, 190, 254, 1) 83%, rgba(141, 179, 250, 1) 90%, rgba(137, 180, 250, 1) 100%);
            background-size: 400% 400%;
            animation: gradient_f 20s ease-in-out infinite;
            transition: all 0.3s cubic-bezier(.55, -0.68, .48, 1.682);
          }

          #workspaces button:hover {
            background-color: @mauve;
          }

          @keyframes gradient {
            0% {
              background-position: 0% 50%;
            }

            50% {
              background-position: 100% 30%;
            }

            100% {
              background-position: 0% 50%;
            }
          }

          @keyframes gradient_f {
            0% {
              background-position: 0% 200%;
            }

            50% {
              background-position: 200% 0%;
            }

            100% {
              background-position: 400% 200%;
            }
          }

          @keyframes gradient_f_nh {
            0% {
              background-position: 0% 200%;
            }

            100% {
              background-position: 200% 200%;
            }
          }

          /* =============================== */


          /* =============================== */
          /* System Monitoring Modules */
          #cpu,
          #memory,
          #temperature {
            color: @blue;
          }

          #memory {
            border-radius: 0px;
          }

          #temperature {
            border-radius: 0px;
          }

          #disk {
            color: @peach;
            border-radius: 0px;
          }

          /* =============================== */
          /* Clock Module */
          #clock {
            color: @flamingo;
            margin-right: 30px;
          }

          /* =============================== */
          /* Network Module */
          #network {
            color: @blue;
          }

          /* =============================== */


          /* =============================== */
          /* PulseAudio Module */
          #pulseaudio {
            color: @mauve;
          }

          /* =============================== */


          /* =============================== */
          /* Battery Module */
          #battery {
            color: @green;
          }

          #battery.charging {
            color: @green;
          }

          #battery.warning:not(.charging) {
            color: @maroon;
          }

          #battery.critical:not(.charging) {
            color: @red;
            animation-name: blink;
            animation-duration: 1s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          @keyframes blink {
            to {
              background: @red;
              color: @surface1;
            }
          }

          /* =============================== */
          /* Tray Module */
          #tray {
            color: @mauve;
            padding-right: 1.25rem;
          }
        '';
      };
    };
}
