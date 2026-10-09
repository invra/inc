{
  flake.modules = {
    nixos.base = {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        extraConfig.pipewire = {
          "10-clock-settings"."context.properties" = {
            "default.clock.rate" = 192000;
            "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];

            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 4096;
          };
          "20-motu-m4-inputs"."context.modules" = [
            {
              name = "libpipewire-module-loopback";
              args = {
                "node.description" = "MOTU M4 1-2";
                "capture.props" = {
                  "target.object" = "alsa_input.usb-MOTU_M4_M4MA0EE3AS-00.Direct__Direct__source";
                  "audio.position" = [ "FL" "FR" ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };
                "playback.props" = {
                  "node.name" = "motu_m4_in_1_2";
                  "media.class" = "Audio/Source";
                  "audio.position" = [ "FL" "FR" ];
                };
              };
            }
            {
              name = "libpipewire-module-loopback";
              args = {
                "node.description" = "MOTU M4 3-4";
                "capture.props" = {
                  "target.object" = "alsa_input.usb-MOTU_M4_M4MA0EE3AS-00.Direct__Direct__source";
                  "audio.position" = [ "RL" "RR" ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };
                "playback.props" = {
                  "node.name" = "motu_m4_in_3_4";
                  "media.class" = "Audio/Source";
                  "audio.position" = [ "FL" "FR" ];
                };
              };
            }
          ];
        };
        wireplumber.extraConfig = {
          "99-disable-suspend"."monitor.alsa.rules" = [
            {
              matches = [
                { "node.name" = "~alsa_input.*"; }
                { "node.name" = "~alsa_output.*"; }
              ];
              actions.update-props."session.suspend-timeout-seconds" = 0;
            }
          ];
          "99-motu-m4-hardware"."monitor.alsa.rules" = [
            {
              matches = [
                { "device.name" = "~alsa_card.usb-MOTU_M4*"; }
              ];
              actions.update-props = {
                "api.alsa.period-size" = 256;
                "api.alsa.headroom" = 1024;
              };
            }
          ];
        };
      };
    };
  };
}
