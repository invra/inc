{ lib, config, ... }:
{
  flake.modules = {
    nixos.base =
      { pkgs, ... }:
      {
        users.users.${config.flake.meta.owner.username}.extraGroups = [
          "audio"
          "video"
        ];
        time.timeZone = "Australia/Sydney";
        hardware = {
          amdgpu.opencl.enable = true;
          graphics = {
            enable = true;
            enable32Bit = pkgs.stdenv.hostPlatform.isx86_64;
          };
        };
        security.rtkit.enable = true;
        services = {
          gitlab = {
            enable = true;
            databasePasswordFile = pkgs.writeText "dbPassword" "timtams";
            initialRootPasswordFile = pkgs.writeText "rootPassword" "";
            secrets = {
              secretFile = pkgs.writeText "secret" "Aig5zaic";
              otpFile = pkgs.writeText "otpsecret" "Riew9mue";
              dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
              jwsFile = pkgs.runCommand "oidcKeyBase" { } "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
              activeRecordPrimaryKeyFile = pkgs.writeText "arPrimaryKey" "somethingrandom32charslong123456";
              activeRecordDeterministicKeyFile = pkgs.writeText "arDeterministicKey" "somethingelse32charslong12345678";
              activeRecordSaltFile = pkgs.writeText "arSalt" "somesalt32charslong123456789012";
            };
          };
          nginx = {
            enable = true;
            recommendedProxySettings = true;
            virtualHosts = {
              localhost = {
                locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
              };
            };
          };
          tailscale.enable = true;
          blueman.enable = true;
          udisks2.enable = true;
          gvfs.enable = true;
          fwupd.enable = true;
          pipewire = {
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
            };
            wireplumber.extraConfig = {
              "99-disable-suspend" = {
                "monitor.alsa.rules" = [
                  {
                    matches = [
                      { "node.name" = "~alsa_input.*"; }
                      { "node.name" = "~alsa_output.*"; }
                    ];
                    actions.update-props."session.suspend-timeout-seconds" = 0;
                  }
                ];
              };
              "99-motu-m4-hardware" = {
                "monitor.alsa.rules" = [
                  {
                    matches = [
                      { "device.name" = "~alsa_card.usb-MOTU_M4*"; }
                    ];
                    actions.update-props = {
                      "device.profile" = "pro-audio";
                      "api.alsa.period-size" = 256;
                      "api.alsa.headroom" = 1024;
                    };
                  }
                ];
              };      
            };
          };

          libinput.enable = true;
          openssh.enable = true;
        };
        networking = {
          useNetworkd = true;
          wireless.enable = true;
          firewall = {
            enable = false;
            allowedTCPPorts = [
              22
              80
              443
              8080
            ];
          };
        };
        systemd = {
          targets.gitlab.wantedBy = lib.mkForce [ ];
          services = {
            gitlab-backup.environment.BACKUP = "dump";
            tailscaled.serviceConfig.Type = "idle";
          };
          network = {
            enable = true;
            wait-online.enable = false;
          };
        };
      };

    homeManager.base =
      { pkgs, linux, ... }:
      {
        services.udiskie = lib.optionalAttrs linux {
          enable = true;
          settings = {
            # workaround for
            # https://github.com/nix-community/home-manager/issues/632
            program_options.file_manager = "${pkgs.nautilus}/bin/nautilus";
          };
        };
      };
    darwin.base.services.tailscale.enable = true;
  };
}
