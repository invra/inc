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
        hardware.graphics = {
          enable = true;
          enable32Bit = pkgs.stdenv.isx86_64;
        };
        services = {
          tailscale.enable = true;
          blueman.enable = true;
          gvfs.enable = true;
          qemuGuest.enable = true;
          spice-vdagentd.enable = true;
          xserver = {
            enable = true;
            excludePackages = with pkgs; [ xterm ];
          };
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
          # mongodb.enable = true;
        };
        networking = {
          networkmanager.enable = true;
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
      };

    darwin.base.services.tailscale.enable = true;
  };
}
