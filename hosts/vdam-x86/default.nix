{ config, ... }:
{
  configurations.vdam-x86.module = {
    imports = with config.flake.modules.nixos; [ base ];
    networking = {
      hostId = "0e8e163d";
      hostName = "NixOS";
    };
    facter.reportPath = ./facter.json;
    hardware.nvidia.open = false;
    fileSystems = {
      "/".device = "/dev/vda2";
    };
    system.stateVersion = "24.11";
  };
}
