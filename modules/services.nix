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
        hardware.graphics = {
          enable = true;
          enable32Bit = pkgs.stdenv.isx86_64;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
          ];
        };
        services = {
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
          services.tailscaled.serviceConfig.Type = "idle";
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
