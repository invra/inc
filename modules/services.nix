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
