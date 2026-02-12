{ config, ... }:
{
  nixpkgs.allowedUnfreePackages = [
    "mongodb"
  ];
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
          gvfs.enable = true;
          qemuGuest.enable = true;
          spice-vdagentd.enable = true;
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

    darwin.base.services.tailscale.enable = true;
  };
}
